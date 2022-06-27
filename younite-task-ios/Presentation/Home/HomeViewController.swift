//
//  ViewController.swift
//  younite-task-ios
//
//  Created by Rashid on 26/06/2022.
//

import UIKit
import MultiPeer

enum DataType: UInt32 {
    case image = 1
}


struct Test {
    var url: String
    var progress: Double = 0
    var fileData: Data?
}

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    fileprivate let cellIdentifier = "HomeTableViewCell"

    private var imagesArray: [Test] = [
        Test(url: "https://www.sample-videos.com/img/Sample-jpg-image-15mb.jpeg"),
        Test(url: "https://www.sample-videos.com/img/Sample-png-image-3mb.png"),
        Test(url: "https://www.sample-videos.com/img/Sample-jpg-image-5mb.jpg"),
    ]
    private var presenter: HomeViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        presenter = HomeViewPresenter(networkClient: NetworkClientImp(), presenterOutput: self)
        presenter.downloadImages(urls: imagesArray.map { $0.url })

        MultiPeer.instance.delegate = self
        MultiPeer.instance.initialize(serviceType: "younite-task")
        MultiPeer.instance.autoConnect()
    }
}

extension HomeViewController: MultiPeerDelegate {
    func multiPeer(didReceiveData data: Data, ofType type: UInt32) {
        if type == DataType.image.rawValue {
            let alert = UIAlertController(title: "Image Received", message: "You received image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    func multiPeer(connectedDevicesChanged devices: [String]) {

    }
}

extension HomeViewController: HomePreseterOutputs {
    func homePresenter(downloadedImage url: String, data: Data) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            for index in 0...self.imagesArray.count - 1 {
                if url == self.imagesArray[index].url {
                    self.imagesArray[index].fileData = data
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
    }

    func homePresenter(url OfImage: String, progress: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            for index in 0...self.imagesArray.count - 1 {
                if OfImage == self.imagesArray[index].url {
                    self.imagesArray[index].progress = progress
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HomeTableViewCell

        cell.configure(downloadedImage: imagesArray[indexPath.row].fileData, progress: imagesArray[indexPath.row].progress)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.imagesArray[indexPath.row].progress < 1 {
            return
        }

        let actionsheet = UIAlertController(title: "Share", message: "", preferredStyle: .actionSheet)

        actionsheet.addAction(UIAlertAction(title: "Share", style: .default, handler: { action in
            MultiPeer.instance.stopSearching()

            defer {
                MultiPeer.instance.autoConnect()
            }


            if let imageData = self.imagesArray[indexPath.row].fileData {
                MultiPeer.instance.send(data: imageData, type: DataType.image.rawValue)
            }
        }))

        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionsheet, animated: true)
    }
}


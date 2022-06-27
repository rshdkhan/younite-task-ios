//
//  ViewController.swift
//  younite-task-ios
//
//  Created by Rashid on 26/06/2022.
//

import UIKit

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
    }
}

extension HomeViewController: HomePreseterOutputs {
    func homePresenter(downloadedImage url: String, data: Data) {
        for index in 0...imagesArray.count - 1 {
            if url == imagesArray[index].url {
                imagesArray[index].fileData = data
                tableView.reloadData()
            }
        }
    }

    func homePresenter(url OfImage: String, progress: Double) {
        for index in 0...imagesArray.count - 1 {
            if OfImage == imagesArray[index].url {
                imagesArray[index].progress = progress
                tableView.reloadData()
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
}


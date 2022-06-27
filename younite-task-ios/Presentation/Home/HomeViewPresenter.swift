//
//  HomePresenter.swift
//  younite-task-ios
//
//  Created by Rashid on 26/06/2022.
//

import Foundation

protocol HomePresenterInput {
    func downloadImages(urls: [String])
}

protocol HomePreseterOutputs {
    func homePresenter(downloadedImage url: String, data: Data)
    func homePresenter(url OfImage: String, progress: Double)
}

class HomeViewPresenter: HomePresenterInput {
    private var networkClient: NetworkClient!
    private var presenterOutputs: HomePreseterOutputs

    init(networkClient: NetworkClient, presenterOutput: HomePreseterOutputs) {
        self.networkClient = networkClient
        self.presenterOutputs = presenterOutput
    }

    func downloadImages(urls: [String]) {

        for stringUrl in urls {
            if let path = self.destinationPath() {

                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let self = self else { return }

                    print("isMainThread >> \(Thread.isMainThread)")

                    self.networkClient.download(url: stringUrl, atPath: path) { progress, url in
                        self.presenterOutputs.homePresenter(url: url.absoluteString, progress: progress)
                    } completion: { data, url in
                        self.presenterOutputs.homePresenter(downloadedImage: url, data: data)
                    }
                }
            }
        }

    }

    private func destinationPath() -> URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let imagesPathURL = documentsURL.appendingPathComponent("/images/")
        return imagesPathURL.appendingPathComponent(String(format: "%d.png", Int.random(in: 1...999)))
    }

}

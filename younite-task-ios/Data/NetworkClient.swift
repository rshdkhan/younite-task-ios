//
//  NetworkClient.swift
//  younite-task-ios
//
//  Created by Rashid on 26/06/2022.
//

import Foundation
import Alamofire

protocol NetworkClient {
    func download(url: String, atPath destinationPath: URL, withDownloadProgress progress: @escaping (Double, URL)->(), completion: @escaping (Data, String)->())
}

class NetworkClientImp: NetworkClient {
    func download(url: String, atPath destinationPath: URL, withDownloadProgress progress: @escaping (Double, URL) -> (), completion: @escaping (Data, String)->()) {
        let destination: DownloadRequest.Destination = { _, _ in
            return (destinationPath, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(url, interceptor: nil, to: destination).validate().responseData { response in
            switch response.result {
                case .success(let data):
                    completion(data, url)
                    break
                case .failure(let error):
                    print("error occured >>> \(error)")
                    
                    break
            }
        }.downloadProgress { cProgress in
            progress(cProgress.fractionCompleted, URL(string: url)!)
            print("progress >>> \(cProgress.fractionCompleted)")
        }
    }
}

//
//  HomeTableViewCell.swift
//  younite-task-ios
//
//  Created by Rashid on 26/06/2022.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var ivDownloadedImage: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    func configure(downloadedImage: Data?, progress: Double) {
        if let data = downloadedImage {
            self.ivDownloadedImage.image = UIImage(data: data)
        }

        self.progressBar.progress = Float(progress)
    }
}

//
//  DetailsViewController.swift
//  younite-task-ios
//
//  Created by Rashid on 27/06/2022.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var ivImage: UIImageView!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()


        ivImage.image = image
    }
}

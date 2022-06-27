//
//  UIViewControllerExt.swift
//  younite-task-ios
//
//  Created by Rashid on 27/06/2022.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, positiveActionTitle: String = "OK", positiveButtonAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Show", style: .default, handler: { action in
            positiveButtonAction()
        }))

        self.present(alert, animated: true)
    }
}

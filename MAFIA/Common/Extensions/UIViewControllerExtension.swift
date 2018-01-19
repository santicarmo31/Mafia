//
//  UIViewControllerExtension.swift
//  MAFIA
//
//  Created by Luis Alejandro Ramirez Suarez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String?, message: String?, preferredStyle: UIAlertControllerStyle = .alert, completionFirstAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okayAction = UIAlertAction(title: "OKAY".localized(), style: .default) { _ in
            completionFirstAction?()
        }
        
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIViewController: BaseView {
    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertControllerStyle, completionFirstAction: (() -> Void)?) {
        self.presentAlert(title: title, message: message, preferredStyle: preferredStyle, completionFirstAction: completionFirstAction)
    }
}


//
//  UIViewController+Ext.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 22.03.2022.
//

import UIKit

extension UIViewController {
    
    func presentMDTAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = MDTAlertVC(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        present(alertVC, animated: true)
    }
    
    func presentDefaultError() {
        let alertVC = MDTAlertVC(title: "Something Went Wrong",
                                message: "We were unable to complete your task at this time. Please try again.",
                                buttonTitle: "OK")
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        present(alertVC, animated: true)
    }
    
}



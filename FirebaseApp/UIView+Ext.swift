//
//  UIView+Ext.swift
//  NeonAppsFirebase
//
//  Created by Taha Özmen on 19.03.2024.
//


import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

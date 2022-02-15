//
//  UIView+Extension.swift
//  SPPDFKit
//
//  Created by Qingpu Shi on 2022/2/15.
//

import UIKit

extension UIView {

    func addSubview(_ subview: UIView, _ constraints: [NSLayoutConstraint]) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)

        NSLayoutConstraint.activate(constraints)
    }

    func addSubviewToFullScreen(_ subview: UIView) {
        self.addSubview(subview, [
            subview.topAnchor.constraint(equalTo: self.topAnchor),
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]);
    }

    func addSubviewToSafeArea(_ subview: UIView) {
        self.addSubview(subview, [
            subview.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            subview.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ]);
    }
}

//
//  SPImages.swift
//  SPPDFKit
//
//  Created by Qingpu Shi on 2022/2/15.
//

import UIKit

class SPImages {
    private static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle(for: SPImages.self), compatibleWith: nil)
    }

    static let edit: UIImage? = SPImages.image(named: "edit")
    static let print: UIImage? = SPImages.image(named: "print")
    static let search: UIImage? = SPImages.image(named: "search")
    static let thumbnail: UIImage? = SPImages.image(named: "thumbnail")
}

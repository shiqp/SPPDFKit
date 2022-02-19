//
//  SPPDFImageAnnotation.swift
//  SPPDFKit
//
//  Created by Qingpu Shi on 2022/2/20.
//

import PDFKit

class SPPDFImageAnnotation: PDFAnnotation {
    var image: UIImage?

    convenience init(bounds: CGRect, image: UIImage) {
        self.init(bounds: bounds, forType: .stamp, withProperties: nil)
        self.image = image
    }

    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        if let image = image?.cgImage {
            context.draw(image, in: bounds)
        }
    }
}

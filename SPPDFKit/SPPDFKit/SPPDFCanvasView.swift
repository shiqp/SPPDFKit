//
//  SPPDFCanvasView.swift
//  SPPDFKit
//
//  Created by Qingpu Shi on 2022/2/20.
//

import PencilKit
import PDFKit

class SPPDFCanvasView: PKCanvasView {

    func saveDrawing(to pdfView: PDFView) {
        guard let page = pdfView.currentPage else {
            return
        }

        if drawing.bounds.isEmpty || drawing.strokes.isEmpty {
            return
        }

        let bounds = pdfView.convert(drawing.bounds, to: page)
        let image = drawing.image(from: drawing.bounds, scale: UIScreen.main.scale)
        let annotation = SPPDFImageAnnotation(bounds: bounds, image: image)
        let drawingValue = drawing.dataRepresentation().base64EncodedString()
        annotation.setValue(drawingValue, forAnnotationKey: .drawing)

        page.addAnnotation(annotation)
    }

    func restoreDrawing(from pdfView: PDFView) {
        guard let page = pdfView.currentPage else {
            return
        }

        self.drawing = PKDrawing()
        for annotation in page.annotations {
            if let drawingValue = annotation.value(forAnnotationKey: .drawing) as? String,
               let drawingData = Data(base64Encoded: drawingValue),
               var drawing = try? PKDrawing(data: drawingData) {
                let source = drawing.bounds
                let destination = pdfView.convert(annotation.bounds, from: page)
                let transform =
                CGAffineTransform(a: destination.width / source.width,
                                  b: 0,
                                  c: 0,
                                  d: destination.height / source.height,
                                  tx: (destination.minX * source.maxX - destination.maxX * source.minX) / source.width,
                                  ty: (destination.minY * source.maxY - destination.maxY * source.minY) / source.height)

                drawing.transform(using: transform)
                self.drawing.append(drawing)

                page.removeAnnotation(annotation)
            }
        }
    }
}

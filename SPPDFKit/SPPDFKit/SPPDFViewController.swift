//
//  SPPDFViewController.swift
//  SPPDFKit
//
//  Created by Qingpu Shi on 2022/2/15.
//

import PDFKit
import PencilKit

open class SPPDFViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    private let pdfView = PDFView()

    private var canvasView: PKCanvasView? {
        didSet {
            if let canvasView = oldValue {
                saveDrawing(from: canvasView)
            } else if let canvasView = canvasView {
                restoreDrawing(to: canvasView)
            }
        }
    }

    private let toolPicker = PKToolPicker()

    open var documentURL: URL? {
        didSet {
            if let url = documentURL {
                pdfView.document = PDFDocument(url: url)
            } else {
                pdfView.document = nil
            }
        }
    }

    open var documentData: Data? {
        didSet {
            if let data = documentData {
                pdfView.document = PDFDocument(data: data)
            } else {
                pdfView.document = nil
            }
        }
    }

    // MARK: - Life Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        initPDFView()
        initNavigationItems()
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        _ = dismissCanvasView()
    }

    // MARK: - Init Views
    
    private func initPDFView() {
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true)
        pdfView.autoScales = true
        pdfView.accessibilityIdentifier = SPAccessibilityIdentifier.PDFView
        pdfView.backgroundColor = .systemBackground
        view.addSubviewToFullScreen(pdfView)
    }
    
    private func initNavigationItems() {
        let edit = UIBarButtonItem(image: SPImages.edit, style: .plain, target: self, action: #selector(editFile))
        let print = UIBarButtonItem(image: SPImages.print, style: .plain, target: self, action: #selector(printFile))
        let search = UIBarButtonItem(image: SPImages.search, style: .plain, target: self, action: #selector(searchFile))
        let thumbnail = UIBarButtonItem(image: SPImages.thumbnail, style: .plain, target: self, action: #selector(showThumbnail))
        
        navigationItem.rightBarButtonItems = [print, edit, search, thumbnail]
    }

    // MARK: - Private Functions

    private func saveDrawing(from canvasView: PKCanvasView) {
        if let page = pdfView.currentPage {
            let drawing = canvasView.drawing
            if drawing.bounds.isEmpty || drawing.strokes.isEmpty {
                return
            }

            let bounds = pdfView.convert(drawing.bounds, to: page)
            let image = canvasView.drawing.image(from: drawing.bounds, scale: UIScreen.main.scale)
            let annotation = SPPDFImageAnnotation(bounds: bounds, image: image)
            let drawingValue = drawing.dataRepresentation().base64EncodedString()
            annotation.setValue(drawingValue, forAnnotationKey: .drawing)

            page.addAnnotation(annotation)
        }
    }

    private func restoreDrawing(to canvasView: PKCanvasView) {
        if let page = pdfView.currentPage {
            canvasView.drawing = PKDrawing()
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
                    canvasView.drawing.append(drawing)

                    page.removeAnnotation(annotation)
                }
            }
        }
    }

    private func dismissCanvasView() -> Bool {
        guard let canvasView = self.canvasView else {
            return false
        }

        canvasView.becomeFirstResponder()
        toolPicker.removeObserver(canvasView)
        toolPicker.setVisible(false, forFirstResponder: canvasView)

        canvasView.removeFromSuperview()

        self.canvasView = nil
        return true
    }

    private func presentCanvasView() {
        let canvasView = PKCanvasView()

        canvasView.delegate = self
        canvasView.backgroundColor = .clear
        canvasView.drawingPolicy = .anyInput
        canvasView.becomeFirstResponder()

        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)

        view.addSubviewToFullScreen(canvasView)
        self.canvasView = canvasView
    }

    // MARK: - Actions
    
    @objc func editFile() {
        if dismissCanvasView() {
            return
        }

        presentCanvasView()
    }
    
    @objc func printFile() {
        
    }
    
    @objc func searchFile() {
        
    }
    
    @objc func showThumbnail() {
        
    }
}

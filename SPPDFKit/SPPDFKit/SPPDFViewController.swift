//
//  SPPDFViewController.swift
//  SPPDFKit
//
//  Created by Qingpu Shi on 2022/2/15.
//

import PDFKit
import PencilKit

open class SPPDFViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    let pdfView = PDFView()

    var canvasView: PKCanvasView? {
        didSet {
            if let canvasView = oldValue {
                saveDrawing(from: canvasView)
            }
        }
    }

    private func saveDrawing(from canvasView: PKCanvasView) {
        if let page = pdfView.currentPage {
            let drawing = canvasView.drawing
            let bounds = pdfView.convert(drawing.bounds, to: page)
            let image = canvasView.drawing.image(from: drawing.bounds, scale: 1.0)
            let annotation = SPPDFImageAnnotation(bounds: bounds, image: image)
            
            page.addAnnotation(annotation)
        }
    }

    let toolPicker = PKToolPicker()

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

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        initPDFView()
        initNavigationItems()
    }
    
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
    
    @objc func editFile() {
        if let canvasView = self.canvasView {
            canvasView.becomeFirstResponder()
            toolPicker.removeObserver(canvasView)
            toolPicker.setVisible(false, forFirstResponder: canvasView)

            canvasView.removeFromSuperview()

            self.canvasView = nil
            return
        }

        let canvasView = PKCanvasView()
        view.addSubviewToFullScreen(canvasView)

        canvasView.delegate = self
        canvasView.backgroundColor = .clear
        canvasView.drawingPolicy = .anyInput
        canvasView.becomeFirstResponder()

        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)

        self.canvasView = canvasView
    }
    
    @objc func printFile() {
        
    }
    
    @objc func searchFile() {
        
    }
    
    @objc func showThumbnail() {
        
    }
}

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

    private var canvasView: SPPDFCanvasView?

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

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit
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

    private func dismissCanvasView() -> Bool {
        guard let canvasView = self.canvasView else {
            return false
        }

        canvasView.becomeFirstResponder()
        toolPicker.removeObserver(canvasView)
        toolPicker.setVisible(false, forFirstResponder: canvasView)

        canvasView.saveDrawing(to: pdfView)
        canvasView.removeFromSuperview()

        self.canvasView = nil
        return true
    }

    private func presentCanvasView() {
        guard self.canvasView == nil else {
            return
        }

        let canvasView = SPPDFCanvasView()

        canvasView.delegate = self
        canvasView.backgroundColor = .clear
        canvasView.drawingPolicy = .anyInput
        canvasView.becomeFirstResponder()

        view.addSubviewToFullScreen(canvasView)
        canvasView.restoreDrawing(from: pdfView)
        self.canvasView = canvasView

        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
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

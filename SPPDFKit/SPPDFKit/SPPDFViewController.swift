//
//  SPPDFViewController.swift
//  SPPDFKit
//
//  Created by Qingpu Shi on 2022/2/15.
//

import PDFKit

open class SPPDFViewController: UIViewController {

    let pdfView = PDFView()
    
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
        
        pdfView.autoScales = true
        view.addSubviewToFullScreen(pdfView)
    }
}

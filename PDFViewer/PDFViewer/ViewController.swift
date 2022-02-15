//
//  ViewController.swift
//  PDFViewer
//
//  Created by Qingpu Shi on 2022/2/15.
//

import UIKit
import SPPDFKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backButtonDisplayMode = .minimal
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pdfVC = segue.destination as? SPPDFViewController,
           let url = Bundle.main.url(forResource: "sample", withExtension: "pdf") {
            pdfVC.documentURL = url
        }
    }
}


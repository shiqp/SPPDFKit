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

        self.navigationItem.title = "PDF Viewer"
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pdfVC = segue.destination as? SPPDFViewController,
           let url = Bundle.main.url(forResource: "sample", withExtension: "pdf") {
            pdfVC.documentURL = url
        }
    }
}


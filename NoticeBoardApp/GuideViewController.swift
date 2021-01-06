//
//  GuideViewController.swift
//  WeatherReportApp
//
//  Created by Ramesh Madavaram on 01/01/21.
//

import UIKit
import WebKit
class GuideViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let htmlFile = Bundle.main.path(forResource: "Guide", ofType: "html")
        let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        webView.loadHTMLString(html!, baseURL: nil)
    }
    
    
}

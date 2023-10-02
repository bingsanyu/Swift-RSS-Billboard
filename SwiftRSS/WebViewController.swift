//
//  ViewController.swift
//  SwiftRSS
//
//  Created by mrguo on 2022/11/22.
//

import UIKit
import WebKit
class WebViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var webView: WKWebView!
    
    
    var blogPostURL: URL? = nil
    var blogPostHTML: String? = nil
    override func viewDidLoad() {
        if blogPostHTML == nil {
            let request = URLRequest(url: blogPostURL!)
            webView.load(request)
            webView.sizeToFit()
        }
        else {
            let header = """
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
                        <style>
                            body {
                                font-family: "Avenir";
                                font-size: 16px;
                            }
                        </style>
                    </head>
                    <body>
                    """
            
            webView.loadHTMLString(header + blogPostHTML! + "</body>", baseURL: nil)
        }

    }

    @IBAction func openInSafari(_ sender: Any) {
        UIApplication.shared.open(blogPostURL!, options: [:], completionHandler: nil)
    }
}

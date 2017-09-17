//
//  ReadNewsViewController.swift
//  WSJ RSS feed
//
//  Created by Alper Demirci on 9/17/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import UIKit
import Foundation

class ReadArticleViewController: UIViewController {
    
    var rssItems: RSSItem? {
        didSet {
            navigationItem.title = rssItems?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        webViewSetUp(url: (rssItems?.link!)!)
    }
    
    //web view set up
    func webViewSetUp(url: String) {
        
        //if the url is empty take me to wsj/articles section instead
        let urlToGoTo = url != "" ? url : "https://www.wsj.com/articles"
        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        webView.loadRequest(NSURLRequest(url: NSURL(string: urlToGoTo)! as URL) as URLRequest)
        webView.delegate = self as? UIWebViewDelegate
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
    }
    
    
    
}

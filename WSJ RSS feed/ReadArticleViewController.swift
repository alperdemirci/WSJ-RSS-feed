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
    
    //MARK: WebView set up
    func webViewSetUp(url: String) {
        
        //if the url is empty take me to wsj/articles section instead
        let urlToGoTo = !(url.isEmpty) ? url : "https://www.wsj.com/articles"
        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        webView.loadRequest(NSURLRequest(url: NSURL(string: urlToGoTo)! as URL) as URLRequest)
        webView.delegate = self as? UIWebViewDelegate
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
    }
    // MARK: - Read
    // I have checked the warning message and this is something I can't fix it. Link for further reading
    //https://forums.developer.apple.com/thread/63189
}

//
//  ViewController.swift
//  WSJ RSS feed
//
//  Created by Alper Demirci on 9/15/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import UIKit


//class Item {
//    var title = ""
//    var guid = [Guid]()
//    var description = ""
//    var media = [Media]()
//    var link = ""
//    var pubDate = Date()
//}
//class Category {
//    var domain: String?
//    var contains: String?
//}
//class Media {
//    var xmlns : String?
//    var url: String?
//    var type: String?
//    var media: String?
//    var height: String?
//    var width: String?
//}
//class Guid {
//    var isPermaLink: String?
//}




import UIKit

class RssFeederViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var rssItems: [RSSItem]?
    let urlString = "https://www.wsj.com/xml/rss/3_7041.xml"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromRssFeeder()
    }
    
    private func fetchDataFromRssFeeder()  {
        let feedParser = XMLParserDataAdaptor()
        feedParser.parseFeed(url: urlString) { (rssItems) in
            self.rssItems = rssItems
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer:0), with: .left)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard the rssItems for initial start as well as if there is a no data in the feeder to avoid crashes
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return the cell from the prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RssFeederTableViewCell
        
        if let item = rssItems?[indexPath.item] {
            cell.item = item
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


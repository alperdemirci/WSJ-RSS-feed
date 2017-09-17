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

class RssFeederViewController: UITableViewController {
    
    let cellId = "cellId"
    
    @IBOutlet weak var tableView: UITableView!
    private var rssItems: [RSSItem]?
    let urlString = "https://www.wsj.com/xml/rss/3_7041.xml"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register tableViewCell
        tableView.register(RssFeederTableViewCell.self, forCellReuseIdentifier: cellId)
        fetchDataFromRssFeeder()
        navigationControllerSetup()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard the rssItems for initial start as well as if there is a no data in the feeder to avoid crashes
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return the cell from the prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RssFeederTableViewCell
        if let item = rssItems?[indexPath.item] {
            
            let url = URL(string: item.url!)
            if url != nil {
                cell.hasImageView.downloadImageFromURL(url: url!)
            } else {
                cell.hasImageView.image = nil
            }
            
            cell.item = item
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: da
    func dateAndTime() -> String {
        let todayName = Date().dayOfWeek()!
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        let todayDate = formatter.string(from: currentDateTime) // September 16, 2017
        
        
        return (todayName + ", " + todayDate)
    }
    
    // MARK: Nav Bar
    func navigationControllerSetup() {
        let theDate = dateAndTime()
        //set up multiline title
        let topText = NSLocalizedString("THE WALL STREET JOURNAL RSS", comment: "")
        let bottomText = NSLocalizedString(theDate, comment: "")

        let titleParameters = [ NSFontAttributeName: UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 15)!, NSForegroundColorAttributeName: UIColor.black]
        let subtitleParameters = [ NSFontAttributeName: UIFont(name: "ArialRoundedMTBold", size: 10)!, NSForegroundColorAttributeName: UIColor.gray]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: topText, attributes: titleParameters)
        let subtitle:NSAttributedString = NSAttributedString(string: bottomText, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        let width = UIScreen.main.bounds.width
        var height = 50
        if let navHeight = navigationController?.navigationBar.frame.size.height {
            height = Int(navHeight)
        }
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Int(width), height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel

    }
}

// extention to print out the name of the date
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}


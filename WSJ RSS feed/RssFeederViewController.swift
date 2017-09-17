//
//  ViewController.swift
//  WSJ RSS feed
//
//  Created by Alper Demirci on 9/15/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import UIKit

class RssFeederViewController: UITableViewController {
    
    let cellId = "cellId"
    
    //    @IBOutlet weak var tableView: UITableView!
    private var rssItems: [RSSItem]?
    let urlString = "https://www.wsj.com/xml/rss/3_7041.xml"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register tableViewCell
        tableView.register(RssFeederTableViewCell.self, forCellReuseIdentifier: cellId)
        
        //set the estimatedRowHeight for tableview and activate the table view autodimensions
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        fetchDataFromRssFeeder()
        navigationTitleSetup()
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
        return (todayName + ", " + todayDate)
    }
    
    // MARK: Nav Bar
    func navigationControllerSetup() {
        let theDate = dateAndTime()
        //set up multiline title
        let topText = NSLocalizedString("THE WALL STREET JOURNAL RSS", comment: "")
        let bottomText = NSLocalizedString(theDate, comment: "")
        
        
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


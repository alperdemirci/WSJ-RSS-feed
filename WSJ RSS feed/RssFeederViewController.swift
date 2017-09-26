//
//  ViewController.swift
//  WSJ RSS feed
//
//  Created by Alper Demirci on 9/15/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import UIKit

class RssFeederViewController: UITableViewController, TopicsDelegate {
    
    let topicsLauncher = TopicsLauncher()
    
    private let cellId = "cellId"
    
    private var rssItems: [RSSItem]?
    private var topicHeader: String = "Opinion"
    var urlString = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        tableviewSetup()
        fetchDataFromRssFeeder(urlString: "https://www.wsj.com/xml/rss/3_7041.xml")
        
        navigationTitleSetup()
        navigationButtonSetup()
    }
    // MARK: - XML Data Call
    func fetchDataFromRssFeeder(urlString: String? )  {
        guard urlString != "" else {
            print("Check your URL")
            return
        }
        let feedParser = XMLParserDataAdaptor()
        feedParser.parseFeed(url: urlString!) { (rssItems) in
            self.rssItems = rssItems
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer:0), with: .left)
            }
        }
    }
    
    //MARK: - TableView Delegate Methods
    func tableviewSetup() {
        //register tableViewCell
        tableView.register(RssFeederTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        
        //set the estimatedRowHeight for tableview and activate the table view autodimensions
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
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
    
    // MARK: TableView delegate methods for header title and adjustment
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let readArticleController = ReadArticleViewController()
        readArticleController.rssItems = (rssItems?[indexPath.row])!
        navigationController?.pushViewController(readArticleController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return topicHeader
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //        view.tintColor = UIColor(red: 0.967, green: 0.985, blue: 0.998, alpha: 0.9)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.black
            headerView.textLabel?.textAlignment = .center
            headerView.backgroundView?.backgroundColor = UIColor(red: 0.967, green: 0.985, blue: 0.998, alpha: 0.9)
        }
    }
    
    //MARK: - Delegate Method
    func topicSelected(topics: TopicsClass) {
        let address = topics.address
        guard topics.name != self.topicHeader else {
            return
        }
        self.topicHeader = topics.name
        urlString = address.replace(target: "http", withString: "https")
        
        fetchDataFromRssFeeder(urlString: urlString)
        tableView.reloadData()
    }
}
    // MARK: - Exntesions

    //MARK: To get the day of the week
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
    // MARK: RSSFeederViewController Extension for Navigation Controller Setup
extension RssFeederViewController {
    
    //MARK: Date And Time Display
    func dateAndTime() -> String {
        let todayName = Date().dayOfWeek()!
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        let todayDate = formatter.string(from: currentDateTime)
        return (todayName + ", " + todayDate)
    }
    
    func navigationTitleSetup() {
//        let theDate = helperFunctions.dateAndTime()
        //set up multiline title
        let topText = NSLocalizedString("THE WALL STREET JOURNAL", comment: "")
        let bottomText = NSLocalizedString(dateAndTime(), comment: "")
        
        //title and subtitle(date) attribute setup
        let titleWithAttribute = [ NSFontAttributeName: UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 15)!, NSForegroundColorAttributeName: UIColor.black]
        let subtitleWithAttribute = [ NSFontAttributeName: UIFont(name: "ArialRoundedMTBold", size: 10)!, NSForegroundColorAttributeName: UIColor.gray]
        
        //push the attributed titles and subtitle
        let title:NSMutableAttributedString = NSMutableAttributedString(string: topText, attributes: titleWithAttribute)
        let subtitle:NSAttributedString = NSAttributedString(string: bottomText, attributes: subtitleWithAttribute)
        
        // append title and subtitle to title constant
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        //setup the size
        let width = UIScreen.main.bounds.width
        var height = 50
        if let navHeight = navigationController?.navigationBar.frame.size.height {
            height = Int(navHeight)
        }
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Int(width), height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        //assign the titleLabel to navigationItem
        navigationItem.titleView = titleLabel
    }
    
    func navigationButtonSetup() {
        let bookmarks = UIBarButtonItem.init(
            barButtonSystemItem: .bookmarks,
            target: self,
            action: #selector(callBookmarkTopics))
        self.navigationItem.leftBarButtonItem = bookmarks
        
        let refresh = UIBarButtonItem.init(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshContent))
        self.navigationItem.rightBarButtonItem = refresh
    }
    
    func callBookmarkTopics() {
        //show topics mmenu
        self.topicsLauncher.delegate = self
        self.topicsLauncher.presentTopicsView()
    }
    
    func refreshContent() {
        fetchDataFromRssFeeder(urlString: urlString)
        tableView.reloadData()
        view.layoutIfNeeded()

    }
}

//
//  XMLParser.swift
//  WSJ RSS feed
//
//  Created by Alper Demirci on 9/15/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//




import Foundation

class XMLParserDataAdaptor: NSObject, XMLParserDelegate {
    
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var currentLink: String = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var currentURL: String = "" {
        didSet {
            currentURL = currentURL.replace(target: "http", withString: "https")
        }
    }
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private var currentPubDateForSorting: String = "" {
        didSet {
            currentPubDateForSorting = currentPubDateForSorting.trimmingCharacters(in: .whitespacesAndNewlines)
            if let range = currentPubDateForSorting.range(of: ", ") {
                currentPubDateForSorting = currentPubDateForSorting.substring(from: range.upperBound)
            }
        }
    }
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    //  MARK: - ParserFeed - Main function
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        guard url != "" else {
            print("There is something wrong with the URL you just send, Please double check")
            return
        }
        let request  = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
            task.resume()
    }
    
    //  MARK: - XML PArser Delegate Methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
       
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentPubDateForSorting = ""
            currentURL = ""
            currentLink = ""
            
            
        } else if currentElement == "media:content" {
            if let mediaLinkForImage = attributeDict["url"] {
                //                    guard mediaLinkForImage != "" else {
                //                        return
                //                    }
                currentURL = mediaLinkForImage
            }
        }
        
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
            case "title": currentTitle += string
            case "description": currentDescription += string
            case "pubDate":
                currentPubDate += string
                currentPubDateForSorting += string
            case "url": currentURL += string
            case "link": currentLink += string
            default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, link: currentLink, pubDate: currentPubDate, pubDateForSorting: currentPubDateForSorting, url: currentURL)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        let sortedRSSItemObject = rssItems.sorted { (lhs: RSSItem, rhs: RSSItem) in lhs.pubDateForSorting! > rhs.pubDateForSorting! }
        parserCompletionHandler?(sortedRSSItemObject)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}

extension String {
    
    func strstr(needle: String, beforeNeedle: Bool = false) -> String? {
        guard let range = self.range(of: needle) else { return nil }
        
        if beforeNeedle {
            return self.substring(to: range.lowerBound)
        }
        
        return self.substring(from: range.upperBound)
    }
    
}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

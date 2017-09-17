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
    private var currentElementMediaLinkForImage = ""
    private var currentMedia: [Media]? = nil
    private var currentLink = ""
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
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    //  MARK: - ParserFeed - Main function
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        
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
        currentElementMediaLinkForImage = ""
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentURL = ""
            
            
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
            case "pubDate": currentPubDate += string
            case "url": currentURL += string
            default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, link: currentLink, pubDate: currentPubDate, media: currentElementMediaLinkForImage, url: currentURL)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}


extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

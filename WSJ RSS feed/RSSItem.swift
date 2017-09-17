//
//  rssItem.swift
//  WSJ RSS feed
//
//  Created by alper on 9/16/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import Foundation

class Media {
    var url = ""
    var type = ""
    var height = ""
    var width = ""
}


struct RSSItem {
    var title: String
    var description: String?
    var link: String?
    var pubDate: String?
    var media: String?
    var url: String?
//    var mediaAll = [Media]()
}

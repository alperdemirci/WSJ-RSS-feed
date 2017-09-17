//
//  NetworkDataAdaptor.swift
//  WSJ RSS feed
//
//  Created by alper on 9/16/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSURL, AnyObject>()
extension UIImageView {
    
    func downloadImageFromURL(url: URL) {
        
        if let checkCacbedImage = imageCache.object(forKey: url as NSURL) as? UIImage {
            self.image = checkCacbedImage
            return
        }
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url, completionHandler: { (data, request, error) in
            if error != nil {
                print(error ?? "Error on the Network call")
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: url as NSURL)
                    self.image = downloadedImage
                }
                
            }
        })
        task.resume()
    }
}


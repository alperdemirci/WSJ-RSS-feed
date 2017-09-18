//
//  TopicsLauncher.swift
//  WSJ RSS feed
//
//  Created by Alper Demirci on 9/17/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//


class TopicsClass: NSObject {
    var name: String
    var address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}

protocol TopicsDelegate {
      func topicSelected(topics: TopicsClass)
}

import UIKit

class TopicsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    var delegate: TopicsDelegate?
    
    let rssTopicOption: [TopicsClass]? = {
        return [TopicsClass(name: "Option", address: "http://www.wsj.com/xml/rss/3_7041.xml" ),
                TopicsClass(name: "World News", address: "http://www.wsj.com/xml/rss/3_7085.xml"),
                TopicsClass(name: "U.S. Business", address: "http://www.wsj.com/xml/rss/3_7014.xml"),
                TopicsClass(name: "Markets News", address: "http://www.wsj.com/xml/rss/3_7031.xml"),
                TopicsClass(name: "Technology", address: "http://www.wsj.com/xml/rss/3_7455.xml"),
                TopicsClass(name: "Lifestyle", address: "http://www.wsj.com/xml/rss/3_7201.xml")]
    }()    
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let vc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.backgroundColor = UIColor.white
        return vc
    }()
    
    let cellId = "cellId"
    
    func presentTopicsView() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.size.height)
            
            window.addSubview(collectionView)
            
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: 0, width: window.frame.size.width-window.frame.size.width/4, height: window.frame.size.height)
            }, completion: nil)
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.size.height)
            }
        }) { (completed: Bool) in
           
        }
    }

    //MARK: - Collection View Delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rssTopicOption!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! TopicsCell
        if let topics = rssTopicOption?[indexPath.item] {
            cell.rssTopicOption = topics
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        handleDismiss()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.size.height)
            }
        }) { (completed: Bool) in
            if let topic = self.rssTopicOption?[indexPath.item] {
                self.delegate?.topicSelected(topics: topic)
            }
        }
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TopicsCell.self, forCellWithReuseIdentifier: cellId)
        
        
    }
}










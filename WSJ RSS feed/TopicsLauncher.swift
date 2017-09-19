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
    var activeSection: Bool
    
    init(name: String, address: String, activeSection: Bool) {
        self.name = name
        self.address = address
        self.activeSection = activeSection
    }
}

protocol TopicsDelegate {
      func topicSelected(topics: TopicsClass)
}

import UIKit

class TopicsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    var delegate: TopicsDelegate?
    
    var rssTopicOption: [TopicsClass]? = {
        return [TopicsClass(name: "Opinion", address: "http://www.wsj.com/xml/rss/3_7041.xml", activeSection: true ),
                TopicsClass(name: "World News", address: "http://www.wsj.com/xml/rss/3_7085.xml", activeSection: false),
                TopicsClass(name: "U.S. Business", address: "http://www.wsj.com/xml/rss/3_7014.xml", activeSection: false),
                TopicsClass(name: "Markets News", address: "http://www.wsj.com/xml/rss/3_7031.xml", activeSection: false),
                TopicsClass(name: "Technology", address: "http://www.wsj.com/xml/rss/3_7455.xml", activeSection: false),
                TopicsClass(name: "Lifestyle", address: "http://www.wsj.com/xml/rss/3_7201.xml", activeSection: false)]
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
            if rssTopicOption?[indexPath.row].activeSection == true {
                cell.backgroundColor =  UIColor.lightGray
                cell.topicText.textColor =  UIColor.white
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        handleDismiss()
        for i in 0...(rssTopicOption!.count-1) {
            if rssTopicOption?[i].activeSection == true {
               rssTopicOption?[i].activeSection = false
            }
        }
        rssTopicOption?[indexPath.row].activeSection = true
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
    
    func collectionView(_:UICollectionView, layout: UICollectionViewLayout, referenceSizeForHeaderInSection: Int) -> CGSize {
        if referenceSizeForHeaderInSection > 0 {
            return CGSize.zero
        }
        return CGSize(width:0, height:70)
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TopicsCell.self, forCellWithReuseIdentifier: cellId)
        
        
    }
}










//
//  TopicsCell.swift
//  WSJ RSS feed
//
//  Created by Alper Demirci on 9/17/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import UIKit

class TopicsCell: BaseCell {

    var rssTopicOption: TopicsClass? {
        didSet {
            topicText.text = rssTopicOption?.name
        }
    }
    let topicText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "sdfsdfsdf"
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
//            UIView.animate(withDuration: 1) { 
            self.backgroundColor = self.isHighlighted ? UIColor.darkGray : UIColor.white
            self.topicText.textColor = self.isHighlighted ? UIColor.white : UIColor.black
//            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        super.setupViews()
        
        addSubview(topicText)
        
        addConstraintsWithFormat(format: "H:|-20-[v0]|", views: topicText)
        addConstraintsWithFormat(format: "V:|[v0]|", views: topicText)
        
        addConstraint(NSLayoutConstraint(item: topicText, attribute: NSLayoutAttribute.centerY, relatedBy: .equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//custom cellection view cell for easy override
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        
    }
}


extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

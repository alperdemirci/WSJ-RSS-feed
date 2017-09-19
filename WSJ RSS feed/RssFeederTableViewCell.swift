//
//  RssFeederTableViewCell.swift
//  WSJ RSS feed
//
//  Created by Alper Demirci on 9/15/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import UIKit

class RssFeederTableViewCell: UITableViewCell {
    

    var titleLabel: UILabel = {
       var label = UILabel()
        label.font = label.font.withSize(20)
        label.text = ""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(15)
        label.text = ""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var publishedDateLabel: UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(10)
        label.text = ""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hasImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    var testingConstraints = 75
    private var linkForImage = ""
    private var imageFlag = true
    var item: RSSItem! {
        didSet {
            titleLabel.text = item.title
            descriptionLabel.text = item.description
            if item.pubDate != "" {
                    publishedDateLabel.text = "Published: " + item.pubDate!
            } else {
                publishedDateLabel.text = "Unknown"
            }
            
            linkForImage = item.url ?? ""
            if linkForImage == "" {
                imageFlag = false
            }
            setupViews()
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(hasImageView)
        addSubview(descriptionLabel)
        
        // constraint added to subViews
        if imageFlag == false {
//            testingConstraints = 0
            
            
        }
        //else {
//            willRemoveSubview(hasImageView)
//            //        //title label constrrains
//            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[titleLabel]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["titleLabel": titleLabel]))
//            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLabel]-10-[descriptionLabel]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["titleLabel": titleLabel, "descriptionLabel": descriptionLabel]))
//            //
//            //        //description label constrrains
//            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[descriptionLabel]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["descriptionLabel": descriptionLabel]))
//        }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[titleLabel]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["titleLabel": titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[descriptionLabel]-10-[hasImageView(\(testingConstraints))]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["descriptionLabel": descriptionLabel, "hasImageView": hasImageView]))
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLabel]-5-[descriptionLabel]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["descriptionLabel": descriptionLabel, "titleLabel": titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLabel]-[hasImageView(\(testingConstraints))]-(>=5)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["hasImageView": hasImageView, "titleLabel": titleLabel]))
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


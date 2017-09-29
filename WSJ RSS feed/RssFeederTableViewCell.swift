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
            if !(item.pubDate?.isEmpty)! {
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(hasImageView)
        addSubview(descriptionLabel)
        addSubview(publishedDateLabel)
            
            addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: titleLabel)
            addConstraintsWithFormat(format: "V:|-10-[v0]-10-[v1]-10-[v2]-10-|", views: titleLabel, descriptionLabel, publishedDateLabel)
            addConstraintsWithFormat(format: "H:|-10-[v0][v1(68)]-10-|", views: descriptionLabel, hasImageView)
            addConstraintsWithFormat(format: "V:[v0]-5-[v1(68)]", views: titleLabel, hasImageView)
            addConstraintsWithFormat(format: "H:|-10-[v0]", views: publishedDateLabel)
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


//
//  TableViewCell.swift
//  sampleTableView
//
//  Created by alper on 9/15/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import UIKit

class RssFeederTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    var item: RSSItem! {
        didSet {
            label.text = item.title
        }
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

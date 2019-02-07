//
//  TableViewCell.swift
//  Tapptic
//
//  Created by Lilian on 23/01/2019.
//  Copyright © 2019 Lilian. All rights reserved.
//

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell { 
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nameImageView: UIImageView!
    
    // MARK : This method will fill the cell of the Master VC part -
    func fillWith(object: ObjectModel) {
        if let name = object.name {
            nameLabel.text = name
        }
        if let imageUrl = object.image {
            nameImageView?.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
    }
    
    // MARK : Setup cell style -
    func setSelectedStyle() {
        self.contentView.backgroundColor = UIColor.red
        self.nameLabel.textColor = UIColor.white
    }
    
    func setTouchedStyle() {
        self.contentView.backgroundColor = UIColor.blue
        self.nameLabel.textColor = UIColor.white
    }

}

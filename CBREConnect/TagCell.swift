//
//  TagCell.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/18/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import Foundation
import UIKit

class TagCell: UICollectionViewCell{
    @IBOutlet weak var tagTitle: UILabel!
    @IBOutlet weak var tagTitleMaxWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.tagTitleMaxWidthConstraint.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
    }
    
}

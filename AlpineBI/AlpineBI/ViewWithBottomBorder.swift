//
//  ViewWithBottomBorder.swift
//  AlpineBI
//
//  Created by Munish Sethi on 10/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class ViewWithBottomBorder: UIView{
    override func awakeFromNib() {
        let topBorderView = UIView(frame: CGRect(x: 0, y: self.frame.height-1,
                                                 width: self.frame.width,
                                                 height: 1))
        topBorderView.backgroundColor = UIColor.gray
        self.addSubview(topBorderView)
    }
    
}

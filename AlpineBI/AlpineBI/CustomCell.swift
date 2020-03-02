//
//  CustomCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 02/03/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
protocol CustomCell {
     var delegate: CallBackProtocol! { get set }
     var parent: UIViewController! {get set}
}

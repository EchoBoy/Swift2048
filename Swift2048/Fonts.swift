//
//  Fonts.swift
//  Swift2048
//
//  Created by 李航 on 3/9/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import Foundation
import UIKit

struct Fonts
{
    //[数字的位数:(字体大小,字体粗细)]
    static let CellsFont:[Int:(Int,Float)] = [
        1:(34,-0.1),
        2:(32,-0.2),
        3:(30,-0.3),
        4:(28,-0.4),
        5:(24,-0.6),
    ]
    
    static let bigTitle = UIFont.systemFontOfSize(30,weight: 0.2)
    
    static let buttonTitle = UIFont.systemFontOfSize(15,weight: -0.4)
    
    static func getCellFont(var number:Int) -> UIFont {
        var bit = 1
        while number > 9{
            number = number/10
            bit++
        }
        let (fontSize, fontWeight) = CellsFont[bit]!
        return UIFont.systemFontOfSize(CGFloat(fontSize), weight: CGFloat(fontWeight))
    }
}

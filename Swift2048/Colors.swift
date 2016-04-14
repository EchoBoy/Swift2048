//
//  Colors.swift
//  Swift2048
//
//  Created by 李航 on 3/9/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import Foundation
import UIKit

struct Colors
{
    static let CellsBackgrounds:[Int:UInt32] = [
        0:0xff_ff_ff,
        2:0xff_b9_0f,
        4:0xff_a5_00,
        8:0xff_7f_24,
        16:0xff_45_00,
        32:0xff_63_47,
        64:0xe5_46_46,
        128:0xe3_35_39,
        256:0xdc_14_3c,
        512:0x00_cd_66,
        1024:0x32_cd_32,
        2048:0x00_a0_00,
        4096:0x99_32_cc,
        8192:0x94_00_d3,
        16384:0x80_00_80,
        32768:0x4b_00_82,
        65536:0x22_22_22,
    ]
    static let GameBackground = UIColor(hexColor: 0xff_da_b9)
    static func getCellBackground(number: Int) -> UIColor {
        if number == 0{
            return UIColor.clearColor()
        }
        return UIColor(hexColor: CellsBackgrounds[number]!)
    }
    
    static let ScoreBackGroundColor = UIColor.grayColor()
}

extension UIColor
{
    convenience init(hexColor: UInt32) {
        let redComponent = CGFloat((hexColor & 0xFF_00_00) >> 16) / CGFloat(255)
        let greenComponent = CGFloat((hexColor & 0x00_FF_00) >> 8) / CGFloat(255)
        let blueComponent = CGFloat((hexColor & 0x00_00_FF)) / CGFloat(255)
        self.init(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1)
    }
}
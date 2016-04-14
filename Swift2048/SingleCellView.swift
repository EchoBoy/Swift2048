//
//  SingleCellView.swift
//  Swift2048
//
//  Created by 李航 on 3/9/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class SingleCellView: UILabel
{
    //当前元素的值
    var value:Int = 0 {
        didSet{
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        text = ""
        //设置圆角
        layer.cornerRadius = 8
        layer.masksToBounds = true
        textAlignment = .Center
        textColor = UIColor.whiteColor()
        backgroundColor = Colors.getCellBackground(0)
        layer.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update() {
        
        //更新显示的数字
        if value == 0 {
            text = ""
        }else {
            text = String(value)
        }
        
        //更新背景颜色,字体
        backgroundColor = Colors.getCellBackground(value)
        font = Fonts.getCellFont(value)
    }
}

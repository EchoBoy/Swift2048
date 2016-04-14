//
//  ScoreView.swift
//  Swift2048
//
//  Created by 李航 on 3/9/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    
    let titleLabel:UILabel
    
    let scoreLabel:UILabel
    
    var score:Int {
        didSet{
            self.scoreLabel.text = String(self.score)
        }
    }
    
    override init(frame: CGRect) {
        
        let height = frame.height
        let width = frame.width
        
        titleLabel = UILabel(frame: CGRectMake(0,0,width,height/2))
        titleLabel.text = "SCORE"
        titleLabel.textAlignment = .Center
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.8)
        
        scoreLabel = UILabel(frame: CGRectMake(0,height/2,width,height/2))
        scoreLabel.text = "0"
        scoreLabel.textAlignment = .Center
        scoreLabel.backgroundColor = UIColor.clearColor()
        scoreLabel.textColor = UIColor.whiteColor()
        
        score = 0
        
        super.init(frame: frame)
        self.backgroundColor = Colors.ScoreBackGroundColor
        self.addSubview(titleLabel)
        self.addSubview(scoreLabel)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }
    
    func isTheBest() {
        self.titleLabel.text = "BEST"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



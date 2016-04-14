//
//  ViewController.swift
//  Swift2048
//
//  Created by 李航 on 3/8/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var playView:PlayView!
    
    var dataSource:Model!
    
    var big2048Title:UILabel!
    
    var currentScore:ScoreView!
    
    var bestScore:ScoreView!
    
    var restart:UIButton!
    
    var testButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Model(dimension: 4, initCellsNumber: 2)
        
        //初始化view
        big2048Title = UILabel(frame: CGRectMake(10,30,80,80))
        big2048Title.text = "2048"
        big2048Title.textAlignment = .Center
        big2048Title.textColor = UIColor.whiteColor()
        big2048Title.font = Fonts.bigTitle
        big2048Title.backgroundColor = Colors.getCellBackground(2048)
        big2048Title.layer.cornerRadius = 5
        big2048Title.layer.masksToBounds = true
        self.view.addSubview(big2048Title)
        
        currentScore = ScoreView(frame: CGRectMake(115,30,75,50))
        currentScore.score = 0
        self.view.addSubview(currentScore)
        
        bestScore = ScoreView(frame: CGRectMake(200,30,75,50))
        bestScore.isTheBest()
        bestScore.score = self.getBest()
        self.view.addSubview(bestScore)
        
        restart = UIButton(frame: CGRectMake(115,82,75,20))
        restart.setTitle("New Game", forState: .Normal)
        restart.titleLabel?.font = Fonts.buttonTitle
        restart.backgroundColor = UIColor.grayColor()
        restart.layer.cornerRadius = 4
        restart.layer.masksToBounds = true
        restart.titleLabel?.textColor = UIColor.whiteColor()
        restart.addTarget(self, action: "newGame", forControlEvents: .TouchUpInside)
        self.view.addSubview(restart)
        
        testButton = UIButton(frame: CGRectMake(200,82,75,20))
        testButton.setTitle("Test", forState: .Normal)
        testButton.backgroundColor = UIColor.grayColor()
        testButton.layer.cornerRadius = 4
        testButton.layer.masksToBounds = true
        testButton.titleLabel?.textColor = UIColor.whiteColor()
        testButton.addTarget(self, action: "test", forControlEvents: .TouchUpInside)
        self.view.addSubview(testButton)
        
        
        playView = PlayView(frame: CGRectMake(0,150,self.view.frame.width,self.view.frame.width))
        
        let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGestureRecognizerUp.direction = .Up
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGestureRecognizerDown.direction = .Down
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGestureRecognizerRight.direction = .Right
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGestureRecognizerLeft.direction = .Left
        
        playView.addGestureRecognizer(swipeGestureRecognizerUp)
        playView.addGestureRecognizer(swipeGestureRecognizerDown)
        playView.addGestureRecognizer(swipeGestureRecognizerRight)
        playView.addGestureRecognizer(swipeGestureRecognizerLeft)
        self.view.addSubview(playView)
        
        updateCells()
    }
    
    func updateCells() {
        playView.updateCells(dataSource.newCells, moveCells: dataSource.moveCells, mergeCells: dataSource.mergeCells)
    }
    
    func swipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Up:
            dataSource.swipe(directon: .Up)
            print("---------------------Up")
        case UISwipeGestureRecognizerDirection.Down:
            dataSource.swipe(directon: .Down)
            print("---------------------down")
        case UISwipeGestureRecognizerDirection.Left:
            dataSource.swipe(directon: .Left)
            print("---------------------left")
        case UISwipeGestureRecognizerDirection.Right:
            dataSource.swipe(directon: .Right)
            print("---------------------right")
        default:
            NSLog("unknown direction")
        }
        
        updateCells()
        updateScore(dataSource.score)
        dataSource.testDataPrint()
        //死亡
        if !dataSource.isLive() {
            death()
        }
    }
    
    func newGame() {
        currentScore.score = 0
        playView.newGame()
        dataSource = Model(dimension: 4, initCellsNumber: 2)
        updateCells()
    }
    
    func updateScore(score: Int) {
        self.currentScore.score = score
        if score > self.bestScore.score {
            self.bestScore.score = score
            setBest(score)
        }
    }
    
    func getBest() -> Int {
        let plistPath = NSBundle.mainBundle().pathForResource("best", ofType: "plist")
        let data = NSDictionary(contentsOfFile: plistPath!)! as Dictionary
        let best = data["Best"]
        return Int(String(best!))!
    }
    
    func setBest(best: Int) {
        let plistPath = NSBundle.mainBundle().pathForResource("best", ofType: "plist")
        let data = NSMutableDictionary(contentsOfFile: plistPath!)
        data?.setObject(best, forKey: "Best")
        
        data?.writeToFile(plistPath!, atomically: true)
        NSLog("\(getBest())")
    }
    
    func death() {
        let alert = UIAlertController(title: "You Death", message: "you have been death!", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (button: UIAlertAction) in
            self.newGame()
        })
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    //测试方法
    func test() {
        let testThread = NSThread(target: self, selector: "test_", object: nil)
        testThread.start()
    }
    
    func test_() {
        NSLog("auto swipe")
        let up = UISwipeGestureRecognizer()
        up.direction = .Up
        let down = UISwipeGestureRecognizer()
        down.direction = .Down
        let left = UISwipeGestureRecognizer()
        left.direction = .Left
        let right = UISwipeGestureRecognizer()
        right.direction = .Right
        while dataSource.isLive() {
            sleep(1)
            swipe(up)
            sleep(1)
            swipe(down)
            sleep(1)
            swipe(left)
            sleep(1)
            swipe(right)
        }
    }
}
















































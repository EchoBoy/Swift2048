//
//  Swift2048Tests.swift
//  Swift2048Tests
//
//  Created by 李航 on 3/8/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import XCTest
@testable import Swift2048

class Swift2048Tests: XCTestCase {
    let model = Model(dimension: 4, initCellsNumber: 2)
    
    func testSwipe() {
        while model.isLive() {
            model.testDataPrint()
            NSLog("-------------------------swipe up")
            model.swipe(directon: .Up)
            model.testDataPrint()
            NSLog("-------------------------swipe down")
            model.swipe(directon: .Down)
            model.testDataPrint()
            NSLog("-------------------------swipe right")
            model.swipe(directon: .Right)
            model.testDataPrint()
            NSLog("-------------------------swipe left")
            model.swipe(directon: .Left)
            model.testDataPrint()
        }
    }
    
    
}

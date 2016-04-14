//
//  Direction.swift
//  Swift2048
//
//  Created by 李航 on 3/8/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

enum Direction
{
    case Up,Down,Left,Right
    
    static func getAllDirection() -> [Direction] {
        return [.Up,.Down,.Left,.Right]
    }
}

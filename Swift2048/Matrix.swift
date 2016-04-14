//
//  Matrix.swift
//  Swift2048
//
//  Created by 李航 on 3/8/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

//自定义数据结构来存放数据
struct Matrix
{
    let rows: Int, columns: Int
    var grid: [Int]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows*columns, repeatedValue: 0)
    }
    
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row>=0 && row<self.rows && column>=0 && column<self.columns
    }
    
    subscript(row: Int, column: Int) -> Int {
        get{
            assert(indexIsValidForRow(row, column: column), "数组超出范围")
            return grid[row * columns + column]
        }
        
        set{
            assert(indexIsValidForRow(row, column: column), "数组超出范围")
            grid[row * columns + column] = newValue
        }
    }
}

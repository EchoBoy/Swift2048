//
//  Model.swift
//  Swift2048
//
//  Created by 李航 on 3/8/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import Foundation

class Model
{
    //封装数据和数据的操作(代码段)
    
    //MARK: Properties
    
    //游戏维度 (4X4)
    let dimension: Int
    //存放数字
    var data: Matrix
    //分数
    var score: Int
    
    //空白的cell的坐标
    var emptyCells:[(Int,Int)]
    
    //用于UI的动画
    //新产生的cell
    var newCells = [(Int,Int,Int)]()
    //移动的cell
    var moveCells = [(Int,Int,Int,Int)]()
    //合并的cell
    var mergeCells = [(Int,Int)]()
    
    //测试方法,数据输出
    func testDataPrint() {
        //数组输出
        for x in 0..<dimension {
            var oneLine = ""
            for y in 0..<dimension {
                oneLine += String(data[x,y]) + "   "
            }
            print(oneLine)
        }
        //分数输出
        print("Score: \(score)")
        //输出用于ui动画更新的
        print("newCells: \(newCells)")
        print("moveCells: \(moveCells)")
        print("mergeCells: \(mergeCells)")
        print("")
    }
    
    //MARK: Method
    init(dimension: Int, data: Matrix, score: Int, emptyCells: [(Int,Int)]) {
        self.data = data
        self.dimension = dimension
        self.score = score
        self.emptyCells = emptyCells
    }
    
    init(dimension: Int, initCellsNumber: Int) {
        self.dimension = dimension
        self.score = 0
        self.data = Matrix(rows: dimension, columns: dimension)
        self.emptyCells = [(Int,Int)]()
        for i in 0..<dimension {
            for j in 0..<dimension {
                emptyCells.append((i,j))
            }
        }
        
        for _ in 0..<initCellsNumber {
            setNewCell()
        }
        
        
    }
    
    /**
     * 难点:通过坐标的变换,将上,下,左,右四个方向的滑动合拼装换成向上滑动
     * 下面是向上滑动的具体算法
     * 1.对矩阵进行按 列 遍历
     * 2.每一列 从上到下 进行遍历,获取某个元素 E(x,y,direction) 作为当前元素
     *
     * 开始移动判断(非空移动到空元素的位置)
     * 3.判断当前元素E的值是否为空(为0)
     * 4.若E为空,就在该列向下找,知道找到一个非空元素,或把该列找完为止
     * 5.若没没有找到非空元素,则表示该列剩下的都是空元素,结束该列的遍历,返回2,开始下一列的遍历
     * 6.若找到了非空元素T,将T移动至E的位置
     *
     * 开始合拼判断(经过以上操作,当前元素E肯定不是空)
     * 7.找到该列下一个非空元素
     * 8.若找到非空的元素T1与E的值相等,则把T1移动到E的位置,值加倍
     * 9.若不相等,则开始遍历下一个元素
     *
    **/
    
    func swipe(directon dct: Direction) {
        //一个新的周期开始,清空UI动画的cells数据
        cleanAnimationData()
        
        //1.对矩阵进行按 列 遍历
        for x in 0..<dimension {
            //2.每一列 从上到下 进行遍历,获取某个元素 E(x,y,direction) 作为当前元素
            for y in 0..<dimension {
                
                //开始移动判断(非空移动到空元素的位置)
                //3.判断当前元素E的值是否为空(为0)
                if transformValue(x, y, dct) == 0 {
                    //4.若E为空,就在该列向下找,知道找到一个非空元素,或把该列找完为止
                    for k in y+1..<dimension {
                        //6.若找到了非空元素T,将T移动至E的位置
                        if transformValue(x, k, dct) != 0 {
                            //非空元素原来的坐标
                            let (oldX,oldY) = transformPosition(x, k, dct)
                            //非空元素新的坐标
                            let (newX,newY) = transformPosition(x, y, dct)
                            moveCell(oldPosition:(oldX,oldY) , newPosition: (newX,newY))
                            break
                        }
                    }
                    //5.若没没有找到非空元素,则表示该列剩下的都是空元素,结束该列的遍历,返回2,开始下一列的遍历
                    if transformValue(x, y, dct) == 0 {
                        break
                    }
                }
                
                //开始合拼判断(经过以上操作,当前元素E肯定不是空)
                //7.找到该列下一个非空元素
                let currentValue = transformValue(x, y, dct)
                for k in y+1..<dimension {
                    let tmp = transformValue(x, k, dct)
                    if tmp != 0 {
                        //8.若找到非空的元素T1与E的值相等,则把T1移动到E的位置,值加倍
                        if currentValue == tmp {
                            //找到相同值的元素的原坐标
                            let (oldX,oldY) = transformPosition(x, k, dct)
                            //将他移动到当前元素的位置
                            let (newX,newY) = transformPosition(x, y, dct)
                            moveCell(oldPosition: (oldX,oldY), newPosition: (newX,newY))
                            mergeCell(newX, y: newY)
                        }
                        //9.若不相等,则开始遍历下一个元素
                        break
                    }
                }
            }
        }
        //遍历完成之后,添加新的值
        if !moveCells.isEmpty {
            setNewCell()
        }
        
    }
    
    func isLive() -> Bool {
        for dct in Direction.getAllDirection() {
            if simulatorSwipe(dct) {
                return true
            }
        }
        return false
    }
    //模拟某一方向上的移动,可以移动(可以合并或者有空元素)返回true,否则返回false
    func simulatorSwipe(dct: Direction) -> Bool {
        for x in 0..<dimension {
            for y in 0..<dimension {
                //按列遍历所有元素
                let currentValue = transformValue(x, y, dct)
                //存在空元素就表示可以移动
                if currentValue == 0 {
                    return true
                }
                //非空就看下一个元素,是否可以合拼
                //当前元素不是该列的最后一个,保证有下一个元素
                if y < dimension-1 {
                    let nextValue = transformValue(x, y+1, dct)
                    //下一个元素可以为空,或者与当前元素相等
                    if nextValue == 0 || nextValue == currentValue {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    ///------------------------坐标转换
    //通过坐标的转换,将四个方向转换成一个方向
    func transformPosition(x: Int, _ y: Int, _ direction: Direction) -> (newX: Int, newY :Int) {
        switch direction {
        case .Up:
            return (y,x)
        case .Down:
            return (dimension-1-y,dimension-1-x)
        case .Right:
            return (x,dimension-1-y)
        case .Left:
            return (dimension-1-x,y)
        }
    }
    
    func transformValue(x: Int, _ y: Int, _ direction: Direction) -> Int {
        let (newX,newY) = transformPosition(x, y, direction)
        return data[newX,newY]
    }
    
    ///------------------------用于UI动画更新的数据
    
    func updateEmptyCells() {
        emptyCells.removeAll()
        for x in 0..<dimension {
            for y in 0..<dimension {
                if data[x,y] == 0 {
                    emptyCells.append((x,y))
                }
            }
        }
    }
    //清除UI动画的数据
    func cleanAnimationData() {
        newCells.removeAll()
        moveCells.removeAll()
        mergeCells.removeAll()
    }
    
    //设置一个新的cell,并返回新cell的位置和值信息
    func setNewCell() -> (x: Int,y: Int,value: Int) {
        updateEmptyCells()
        
        //随机获取一个空的位置
        let (x, y) = emptyCells.removeAtIndex(Int(arc4random_uniform(UInt32(emptyCells.count))))
        //产生0~9的一个随机数,若为0这值为4
        //2和4的几率为1:9
        let initValue = arc4random_uniform(10) == 0 ? 4:2
        data[x,y] = initValue
        //记录新的cell
        newCells.append((x,y,initValue))
        
        return (x,y,initValue)
    }
    
    func moveCell(oldPosition old:(Int, Int), newPosition new:(Int, Int)) {
        let (oldX,oldY) = old
        let (newX,newY) = new
        data[newX,newY] = data[oldX,oldY]
        data[oldX,oldY] = 0
        //记录移动的cell
        moveCells.append(oldX,oldY,newX,newY)
    }
    
    func mergeCell(x: Int, y: Int) {
        let oldValue = data[x,y]
        data[x,y] = oldValue*2
        //更新分数
        score += oldValue*2
        //记录合并的cell
        mergeCells.append((x,y))
    }
    
}






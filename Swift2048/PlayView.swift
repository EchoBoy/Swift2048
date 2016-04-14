//
//  PlayView.swift
//  Swift2048
//
//  Created by 李航 on 3/9/16.
//  Copyright © 2016 ThrEcho. All rights reserved.
//

import UIKit

class PlayView: UIView
{
    //cell之间的空白百分比
    let emptyPer = CGFloat(0.1)
    //维度
    let dimension:Int
    
    let cellSize:CGFloat
    
    let emptySize:CGFloat
    
    var cells:[[SingleCellView]]
    
    //用于动画view的标记
    let TmpMark = 1
    
    //缓存消息
    var tmpNewCells = [(Int,Int,Int)]()
    var tmpMergeCells = [(Int,Int)]()
    
    init(frame: CGRect, dimension:Int=4) {
        emptySize = (frame.width/CGFloat(dimension)) * emptyPer
        cellSize = (frame.width/CGFloat(dimension)) - 2*emptySize
        self.dimension = dimension
        cells = [[SingleCellView]]()
        
        super.init(frame: frame)
        
        backgroundColor = Colors.GameBackground
        
        self.layer.cornerRadius = 8
        
        //初始化cells
        for i in 0..<dimension {
            var tmp = [SingleCellView]()
            for j in 0..<dimension {
                let position = getCellRelativePosition(i, j)
                //加入白色背景view
                let backgroundView = UIView(frame: CGRectMake(position.x,position.y,cellSize,cellSize))
                backgroundView.backgroundColor = UIColor.whiteColor()
                self.addSubview(backgroundView)
                backgroundView.layer.cornerRadius = 8
                backgroundView.layer.masksToBounds = true
                
                
                let newCellView = SingleCellView(frame: CGRectMake(position.x,position.y,cellSize,cellSize))
                //设置为最上面
                self.addSubview(newCellView)
                tmp += [newCellView]
            }
            cells.append(tmp)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCellRelativePosition(x: Int, _ y: Int) -> CGPoint {
        let positionX = CGFloat(2*y+1)*emptySize + CGFloat(y)*cellSize
        let positionY = CGFloat(2*x+1)*emptySize + CGFloat(x)*cellSize
        return CGPointMake(positionX, positionY)
    }
    
    //更新视图接口,同时实现动画效果
    func newCell(x: Int,y:Int,newValue:Int) {
        let cell = cells[x][y]
        //改变cell的值
        cell.value = newValue
        
        cell.layer.setAffineTransform(CGAffineTransformMakeScale(0.1, 0.1))
        UIView.animateWithDuration(AnimateDurationTime.NEW,
            animations: {
                cell.layer.setAffineTransform(CGAffineTransformIdentity)
        })
    }
    
    //使用临时的view来达到动画效果,逻辑很不清晰,不完美,带改进-----------------
    func moveCell(oldX: Int, oldY: Int, newX: Int, newY: Int, isLast: Bool = false, isMerge: Bool = false) {
        let oldCell = cells[oldX][oldY]
        let newCell = cells[newX][newY]
        let oldPosition = getCellRelativePosition(oldX, oldY)
        let newPosition = getCellRelativePosition(newX, newY)
        
        //交换值
        let value = oldCell.value
        newCell.value = value
        oldCell.value = 0
        newCell.hidden = true
        oldCell.hidden = true
        
        //用于动画效果的临时view
        let tmpView = SingleCellView(frame: CGRectMake(oldPosition.x,oldPosition.y,cellSize,cellSize))
        tmpView.value = value
        tmpView.tag = TmpMark
        self.addSubview(tmpView)
        let tx = newPosition.x - oldPosition.x
        let ty = newPosition.y - oldPosition.y
        
        //合拼的一种特殊情况
        if isMerge {
            let tmpView = SingleCellView(frame: CGRectMake(newPosition.x,newPosition.y,cellSize,cellSize))
            tmpView.value = value
            tmpView.tag = TmpMark
            self.addSubview(tmpView)
        }
        
        UIView.animateWithDuration(AnimateDurationTime.MOVE,
            animations: {
                tmpView.layer.setAffineTransform(CGAffineTransformMakeTranslation(tx, ty))
            },
            completion: {
                (finished: Bool) in
                if isLast {
                    self.newAndMerge()
                }
        })
    }
    
    func mergeCell(x: Int, y:Int) {
        
        let cell = cells[x][y]
        //改变cell的值
        cell.value *= 2
    
        UIView.animateWithDuration(AnimateDurationTime.MERGE,
            animations: {
                cell.layer.setAffineTransform(CGAffineTransformMakeScale(1.3, 1.3))
            },
            completion: {
                (finished: Bool) in
                UIView.animateWithDuration(AnimateDurationTime.MERGE,
                    animations: {
                        cell.layer.setAffineTransform(CGAffineTransformIdentity)
                })
        })
    }
    
    func updateCells(newCells:[(Int,Int,Int)], moveCells:[(Int,Int,Int,Int)], mergeCells:[(Int,Int)]) {
        
        tmpNewCells = newCells
        tmpMergeCells = mergeCells
        
        for i in 0..<moveCells.count {
            
            let (oldx,oldy,newx,newy) = moveCells[i]
            //找到最后一次
            var isLast = false
            if i == moveCells.count - 1 {
                isLast = true
            }
            //是否是和平的特殊情况
            var ismerge = false
            for (x,y) in mergeCells {
                if x==newx && y==newy{
                    ismerge = true
                }
            }
            
            moveCell(oldx, oldY: oldy, newX: newx, newY: newy, isLast: isLast, isMerge: ismerge)
        }
        
        //如果是第一次,就直接new and merge
        if moveCells.isEmpty {
            newAndMerge()
        }
    }
    
    func newAndMerge() {
        //展示真实层
        for cell in cells {
            for onecell in cell {
                onecell.hidden = false
            }
        }
        //去掉动画层
        cleanTmpView()
        
        for (x,y,newValue) in tmpNewCells {
            newCell(x, y: y, newValue: newValue)
        }
        
        for (x,y) in tmpMergeCells {
            mergeCell(x, y: y)
        }
        
        tmpMergeCells.removeAll()
        tmpNewCells.removeAll()
    }
    
    //清除动画层
    func cleanTmpView() {
        for subview in self.subviews {
            if subview.tag == TmpMark {
                subview.removeFromSuperview()
            }
        }
    }
    
    func newGame() {
        for x in 0..<dimension {
            for y in 0..<dimension {
                cells[x][y].value = 0
            }
        }
    }
}

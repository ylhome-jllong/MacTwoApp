//
//  MainView.swift
//  MacTwoApp
//
//  Created by 江龙 on 2020/6/4.
//  Copyright © 2020 江龙. All rights reserved.
//

import Cocoa

class MainView: NSView {

    var physics: Physics?
    var nowTime = 0
    
    /// 用来绘制轨迹
    private var path = NSBezierPath()
    private var pathO = NSBezierPath()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // 设置白背景
        NSColor.white.setFill()
        dirtyRect.fill()
        
        // 绘制坐标
        self.coordinate()
        // 绘制轨迹
        //path.stroke()
        NSColor.red.setFill()
        // 绘制对象
        pathO.fill()
    }
    
    /// 绘制新轨迹并刷新
    func drawImage(){
        var flag = false
        if (nowTime < 1){return}
        pathO.removeAllPoints()
        for particle in physics!.particles{
            let point1 = convert(NSPoint(x: particle.history[nowTime-1].location.x, y: particle.history[nowTime-1].location.y))
            let point2 = convert(NSPoint(x: particle.history[nowTime].location.x, y: particle.history[nowTime].location.y))
            if (point1 != nil && point2 != nil){
                path.move(to: point1!)
                path.line(to: point2!)
                pathO.appendOval(in: NSMakeRect(point2!.x-5, point2!.y-5, 10, 10))
                flag = true
            }
        }
        if(flag){
            needsDisplay = true
        }
    }
    
    /// 重新绘制之前的图像
    func drawNewAllImage(){
        path.removeAllPoints()
        pathO.removeAllPoints()
        if(nowTime < 1){return}
        for i in 1...nowTime{
            for particle in physics!.particles{
                let point1 = convert(NSPoint(x: particle.history[i-1].location.x, y: particle.history[i-1].location.y))
                let point2 = convert(NSPoint(x: particle.history[i].location.x, y: particle.history[i].location.y))
                if (point1 != nil && point2 != nil)
                {
                    path.move(to: point1!)
                    path.line(to: point2!)
                }
            }
        }
        needsDisplay = true
    }
    
    /// 坐标转换
    private func convert(_ point: CGPoint)->CGPoint?{
        var newPoint = point
        // 移动到坐标原点
        newPoint.x += bounds.width/2
        newPoint.y += bounds.height/2
        // 计算后超范围
        if(newPoint.y > bounds.height || newPoint.y < 0 || newPoint.x > bounds.width || newPoint.x < 0){
            return nil
        }
        return newPoint
    }
    /// 绘制坐标系
    private func coordinate(){
        let coordinatePath = NSBezierPath()
        NSColor.gray.setStroke()
        coordinatePath.move(to: NSMakePoint(0,bounds.height/2))
        coordinatePath.line(to: NSMakePoint(bounds.width,bounds.height/2))
        coordinatePath.move(to: NSMakePoint(bounds.width/2,0))
        coordinatePath.line(to: NSMakePoint(bounds.width/2,bounds.height))
        coordinatePath.stroke()
    }
    
}

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
    var image: NSImage?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // 设置白背景
        NSColor.white.setFill()
        dirtyRect.fill()
        
        // 绘制坐标
        self.coordinate()
        // 绘制轨迹
        image?.draw(in: dirtyRect)
    }
    
    /// 绘制新轨迹并刷新
    func drawImage(){
        if (image != nil){
            let path = NSBezierPath()
            if (nowTime < 1){return}
            let point1 = convert(NSPoint(x: physics!.particle.history[nowTime-1].location.x, y: physics!.particle.history[nowTime-1].location.y))
            let point2 = convert(NSPoint(x: physics!.particle.history[nowTime].location.x, y: physics!.particle.history[nowTime].location.y))
            if (point1 != nil && point2 != nil){
                image?.lockFocus()
                NSColor.black.setStroke()
                path.lineWidth = 1
                path.move(to: point1!)
                path.line(to: point2!)
                path.stroke()
                image?.unlockFocus()
                needsDisplay = true
            }
        }
    }
    
    /// 重新绘制之前的图像
    func drawNewAllImage(){
        if (image != nil) {
            image?.lockFocus()
            NSColor.black.setStroke()
            let path = NSBezierPath()
            path.lineWidth = 1
            if(nowTime < 1){return}
            for i in 1...nowTime{
                let point1 = convert(NSPoint(x: physics!.particle.history[i-1].location.x, y: physics!.particle.history[i-1].location.y))
                let point2 = convert(NSPoint(x: physics!.particle.history[i].location.x, y: physics!.particle.history[i].location.y))
                if (point1 != nil && point2 != nil)
                {
                    path.move(to: point1!)
                    path.line(to: point2!)
                    path.stroke()
                }
            }
            image?.unlockFocus()
            needsDisplay = true
        }
    }
    
    /// 坐标转换
    private func convert(_ point: CGPoint)->CGPoint?{
        // 超出范围
        if(point.y > bounds.height || point.x > bounds.width){
            return nil
        }
        var newPoint = point
        // 翻转
        newPoint.y = abs(newPoint.y - bounds.height)
        // 移动到坐标原点
        newPoint.x += bounds.width/2
        newPoint.y -= bounds.height/2
        // 计算后超范围
        if(newPoint.y > bounds.height || newPoint.y < 0 || newPoint.x > bounds.width || newPoint.x < 0){
            return nil
        }
        return newPoint
    }
    /// 绘制坐标系
    private func coordinate(){
        let path = NSBezierPath()
        NSColor.gray.setStroke()
        path.move(to: NSMakePoint(0,bounds.height/2))
        path.line(to: NSMakePoint(bounds.width,bounds.height/2))
        path.move(to: NSMakePoint(bounds.width/2,0))
        path.line(to: NSMakePoint(bounds.width/2,bounds.height))
        path.stroke()
    }
    
}

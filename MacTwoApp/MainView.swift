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
    private var image: NSImage?
    
    /// 用来绘制轨迹
    private var path = NSBezierPath()
    /// 用来绘制质点
    private var pathO = NSBezierPath()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // 设置白背景
        NSColor.white.setFill()
        dirtyRect.fill()
        
        // 绘制坐标
        self.coordinate()
        
        // 画旧轨迹
        image?.draw(in: dirtyRect)
        
        // 绘制轨迹
        NSColor.black.setStroke()
        path.stroke()
        NSColor.red.setFill()
        // 绘制对象
        pathO.fill()
    }
    
    /// 绘制新轨迹并刷新
    func drawImage(){
        // 是否更新标志（提高效率）
        var flag = false
        // 提高稳定性
        if (nowTime < 1){return}
        if (nowTime >= physics!.particles[0].history.count){return}
        //  存档之前的轨迹
        if (nowTime % 100 == 0 ){
            self.drawOldImage()
            path.removeAllPoints()
        }
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
        var min = 1
        self.path.removeAllPoints()
        self.pathO.removeAllPoints()
        if(self.nowTime < 1){return}
        // 丢弃过去太多的轨迹保留最近的500步
        if( self.nowTime > 501 ){min = nowTime - 501 }
        for i in min...self.nowTime{
            for particle in self.physics!.particles{
                let point1 = self.convert(NSPoint(x: particle.history[i-1].location.x, y: particle.history[i-1].location.y))
                let point2 = self.convert(NSPoint(x: particle.history[i].location.x, y: particle.history[i].location.y))
                if (point1 != nil && point2 != nil)
                {
                    self.path.move(to: point1!)
                    self.path.line(to: point2!)
                }
            }
        }
        self.image = nil
        self.drawOldImage()
    }
    
    /// 将旧轨迹存图
    private func drawOldImage(){
        if (image == nil){image = NSImage(size: bounds.size)}
        image?.lockFocus()
        NSColor.black.setStroke()
        path.stroke()
        image?.unlockFocus()
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

//
//  Particle.swift
//  MacTwoApp
//
//  Created by 江龙 on 2020/6/4.
//  Copyright © 2020 江龙. All rights reserved.
//

import Cocoa

/// 质点类
class Particle {
    
    
    /// 历史记录数据结构
    struct HistoryData {
        /// 时间
        var time: Double
        /// 位置
        var location: Components
        /// 速度
        var velocity: Components
        /// 加速度
        var acceleration: Components
    }
    
    
    /// 时间
    private(set) var time: Double = 0
    /// 质量
    private(set) var massm: Double
    /// 位置
    private(set) var location: Components
    /// 速度
    private(set) var velocity: Components
    /// 加速度
    private(set) var acceleration: Components
    /// 外界环境 力
    var forces:[Components] = [Components]()
    /// 经历历史
    private(set) var history = [HistoryData]()
    
    
    init(massm: Double,location: Components,velocity: Components){
        self.massm = massm
        self.location = location
        self.velocity = velocity
        self.acceleration = Components(x:0 , y:0 ,z:0)
        history.append(HistoryData(time: 0, location: location, velocity: velocity, acceleration: acceleration))
    }
    
    /// 质点演进 step：时间步进
    public func evolution(step: Double){
        // 时间推移
        self.time += step
        self.computeAcceleration()
        self.computeVelocity(step)
        self.computeLocation(step)
        // 记录历史
        self.addHistory()
          
    }
    
    /// 计算这个时刻的加速度
    private func computeAcceleration() {
        // 合力
        var resultantForces = Components(x: 0, y: 0, z: 0)
        // 加度
        for force in forces{
            resultantForces.x += force.x
            resultantForces.y += force.y
            resultantForces.z += force.z
        }
        if (massm != 0){
            acceleration = Components(x: resultantForces.x/massm, y: resultantForces.y/massm, z: resultantForces.z/massm)
        }
        else{
            print("质量不可以为0")
        }
    }
    /// 计算这个时刻的速度
    private func computeVelocity(_ step: Double){
        velocity.x += acceleration.x * step
        velocity.y += acceleration.y * step
        velocity.z += acceleration.z * step
    }
    /// 计算这个时刻的位置
    private func computeLocation(_ step: Double){
        location.x += velocity.x * step
        location.y += velocity.y * step
        location.z += velocity.z * step
    }
    
    
    /// 加入历史
    private func addHistory(){
        let newData = HistoryData(time: self.time, location: self.location, velocity: self.velocity, acceleration: self.acceleration)
        // 如果出现资源竞争可使用主列队
        DispatchQueue.main.async {
            self.history.append(newData)
        }
        
    }

}

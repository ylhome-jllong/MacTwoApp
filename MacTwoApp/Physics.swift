//
//  Physics.swift
//  MacTwoApp
//
//  Created by 江龙 on 2020/6/3.
//  Copyright © 2020 江龙. All rights reserved.
//

import Cocoa

/// 坐标分量数据结构
struct Components {
    var x: Double
    var y: Double
    var z: Double
}


/// 物理规律实现
class Physics{
    
    /// 研究对象
    private(set) var particles = [Particle]()
    /// 委托代理
    var delegate: NotifyProtocol?
    
    let gcdQueue = DispatchQueue.init(label: "演进列队")
    
    /// 设置各物理参数
    func setParameter(){
        let particle = Particle(massm: 1, location: Components(x: 0, y: 0, z: 0), velocity: Components(x: 10, y: 0, z: 0))
        particle.forces.append(Components(x: 0, y: -10, z: 0))
        particles.append(particle)
        let particle1 = Particle(massm: 1, location: Components(x: 0, y: 0, z: 0), velocity: Components(x: -10, y: 0, z: 0))
        particle1.forces.append(Components(x: 0, y: -10, z: 0))
        particles.append(particle1)
        let particle2 = Particle(massm: 1, location: Components(x: 0, y: 0, z: 0), velocity: Components(x: -10, y: 0, z: 0))
        particle2.forces.append(Components(x: 0, y: 10, z: 0))
        particles.append(particle2)
        let particle3 = Particle(massm: 1, location: Components(x: 0, y: 0, z: 0), velocity: Components(x: 10, y: 0, z: 0))
        particle3.forces.append(Components(x: 0, y: 10, z: 0))
        particles.append(particle3)
    }
    
    
    /// 开始运行（异步运行）
    func run(){
        gcdQueue.async {
            for _ in 0...100{
                for particle in self.particles{
                    particle.evolution(step: 0.1)
                }
            }
            DispatchQueue.main.async {
                self.delegate?.complete()
            }
        }
        
    }
    /// 记录数据
    func stop(){
    }
    /// 存储数据
    func save(to path: URL){
        
    }

}

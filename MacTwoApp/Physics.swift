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
        let particle = Particle(massm: 1, location: Components(x: 50, y: 0, z: 0), velocity: Components(x: 0, y: 10, z: 0))
        particles.append(particle)
        let particle1 = Particle(massm: 1, location: Components(x: -50, y: 0, z: 0), velocity: Components(x: 0, y: -10, z: 0))
        particles.append(particle1)
        let particle2 = Particle(massm: 30, location: Components(x: 0, y: 50, z: 0), velocity: Components(x: -50, y: 0, z: 0))
        particles.append(particle2)
        let particle3 = Particle(massm: 30, location: Components(x: 0, y: -50, z: 0), velocity: Components(x: 50, y: 0, z: 0))
        particles.append(particle3)
    }
    
    
    /// 开始运行（异步运行）
    func run(){
        gcdQueue.async {
            for _ in 0...100{
                self.interreaction()
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
    /// 计算相互作用
    private func interreaction(){
        if(particles.count<2){return}
        for particle in particles {
            particle.forces.removeAll()
        }
        for i in 0..<particles.count{
            for j in i+1..<particles.count {
                let x = particles[i].location.x - particles[j].location.x
                let y = particles[i].location.y - particles[j].location.y
                let z = particles[i].location.z - particles[j].location.z
                let r = sqrt(x*x + y*y + z*z)
                if (r == 0) {break}
                let f = particles[i].massm * particles[j].massm / r*r
                let fx = f * x / r
                let fy = f * y / r
                let fz = f * z / r
                particles[i].forces.append(Components(x: -fx, y: -fy, z: -fz))
                particles[j].forces.append(Components(x: fx, y: fy, z: fz))
            }
        }
    }
}

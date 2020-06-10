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
    private(set) var particle = Particle()
    /// 委托代理
    var delegate: NotifyProtocol?
    
    let gcdQueue = DispatchQueue.init(label: "演进列队")
    
    
    /// 开始运行（异步运行）
    func run(){
        gcdQueue.async {
            for _ in 0...100{
                self.particle.evolution(step: 0.1)
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

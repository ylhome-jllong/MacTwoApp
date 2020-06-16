//
//  FileCtrl.swift
//  MacTwoApp
//
//  Created by 江龙 on 2020/6/16.
//  Copyright © 2020 江龙. All rights reserved.
//

import Cocoa

class FileCtrl: NSObject {
    var physics: Physics?
    
    /// 保存计算数据
    func save(to path: URL){
        let jsonEncoder = JSONEncoder()
        var allData = Data()
        for particle in physics!.particles{
            guard let data = try? jsonEncoder.encode(particle.history) else {
                print("数据转化失败")
                return
            }
            allData.append((particle.name + "\n").data(using: .utf8)! )
            allData.append(data)
            allData.append(("\n").data(using: .utf8)!)
        }
        guard  let _ = try? allData.write(to: path) else{
            print("保存失败")
            return
        }
    }
    /// 开启设置文件
    func openParameterFile(path: URL) -> [Particle]? {
        var particles = [Particle]()
        guard let data = try? Data(contentsOf: path) else {
            print("读取文件错误")
            return nil
        }
        guard var str = String(data: data, encoding: .utf8) else{
            print("文件转为字符串错误")
            return nil
        }
        var strDatas = [String]()
        while true {
            let index1 = str.firstIndex(of: "{")
            let index2 = str.firstIndex(of: "}")
            if (index1 == nil || index2 == nil){break}//已经分析完成
            let temp = str[index1! ... index2!]
            strDatas.append(String(temp))
            if (index2 == str.index(str.startIndex, offsetBy: str.count-1)){break}
            let index3 = str.index(index2!, offsetBy: 2)
            str = String(str[index3 ..< str.endIndex])
        }
        if( strDatas.count == 0 ){
            print("没有找到有效数据！")
            return nil
        }
        for strData in strDatas{
            
            // 解析name
            guard let range1 = strData.range(of: "name:") else {
                print("数据中没有找到“name”")
                return nil
            }
            let index1 = range1.upperBound
            guard let index2 = strData.firstIndex(of: ";") else{
                print(";错误")
                return nil
            }
            let name = strData[index1 ..< index2]
            
            
            // 解析 m
            guard let range2 = strData.range(of: "m:") else {
                print("数据中没有找到“m”")
                return nil
            }
            let index3 = range2.upperBound
            guard let index4 = strData[range2.upperBound...].firstIndex(of: ";") else{
                print(";错误")
                return nil
            }
            guard let m = Double(String(strData[index3 ..< index4])) else{
                print("数字转换错误")
                return nil
            }
            
            // 解析 v0
            guard let range3 = strData.range(of: "v0:") else {
                print("数据中没有找到“v0”")
                return nil
            }
            let index5 = range3.upperBound
            guard let index6 = strData[range3.upperBound...].firstIndex(of: ";") else{
                print(";错误")
                return nil
            }
            guard let v0 = toXYZ(String(strData[index5 ..< index6]))else{
                print("v0错误")
                return nil
            }
            
            // 解析r0
            guard let range4 = strData.range(of: "r0:") else {
                print("数据中没有找到“r0”")
                return nil
            }
            let index7 = range4.upperBound
            guard let index8 = strData[range4.upperBound...].firstIndex(of: ";") else{
                print(";错误")
                return nil
            }
            guard let r0 = toXYZ(String(strData[index7 ..< index8]))else{
                print("r0错误")
                return nil
            }
            particles.append(Particle(name: String(name), massm: m, location: r0, velocity: v0))
        }
        return particles
        
    }
    /// 转化为坐标
    private func toXYZ(_ strData: String)->Components?{
        guard  let r1 = strData.range(of: "(") else {
            return nil
        }
        guard let r2 = strData.range(of: ",") else{
            return nil
        }
        guard let x = Double(String(strData[r1.upperBound ..< r2.lowerBound ])) else {
            return nil
        }
        
        guard let r3 = strData[r2.upperBound...].range(of: ",") else{
            return nil
        }
        guard let y = Double(String(strData[r2.upperBound ..< r3.lowerBound ])) else {
            return nil
        }
        
        guard let r4 = strData[r3.upperBound...].range(of: ")") else{
            return nil
        }
        guard let z = Double(String(strData[r3.upperBound ..< r4.lowerBound ])) else {
            return nil
        }
        
        return Components(x: x, y: y, z: z)
    }
    

}

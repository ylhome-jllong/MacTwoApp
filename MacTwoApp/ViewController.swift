//
//  ViewController.swift
//  MacTwoApp
//
//  Created by 江龙 on 2020/6/3.
//  Copyright © 2020 江龙. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    /// 定时器状态
    var timerState = false
    /// 定时器
    private var gcdTimer: DispatchSourceTimer?
    /// 视图
    @IBOutlet var mainView: MainView!
    /// 文档控制
    private let fileCtrl = FileCtrl()
    
    
    
    
    
    let physics = Physics()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainView.physics = self.physics
        fileCtrl.physics = self.physics
        //mainView.image = NSImage(size: NSMakeSize(mainView.bounds.width, mainView.bounds.height))
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    /// 开始演进
    @IBAction func OnPlay(_ sender: Any) {
        if (gcdTimer != nil){
            gcdTimer?.cancel()
            gcdTimer = nil
            timerState = false
        }
        
        physics.delegate = self
        //physics.setParameter()
        physics.run()

        mainView.drawNewAllImage()
        gcdTimer = DispatchSource.makeTimerSource()
        gcdTimer?.schedule(deadline: .now(), repeating: 0.01)
        gcdTimer?.setEventHandler(handler: OnTimer)
    }
    @IBAction func OnSave(_ sender: Any){
        let savePanel = NSSavePanel()
        savePanel.title = "数据保存"
        savePanel.message = "将数据存储在……"
        savePanel.allowedFileTypes = ["txt"]
        
        savePanel.begin { (ret) in
            if(ret == NSApplication.ModalResponse.OK){
                self.fileCtrl.save(to: savePanel.url!)
            }
        }
        
    }
    @IBAction func OnOpen(_ sender: Any){
        let openPanel = NSOpenPanel()
        openPanel.title = "打开环境初始条件设置文件"
        openPanel.allowedFileTypes = ["txt","rtf"]
        // 可以选择文件
        openPanel.canChooseFiles = true
        // 不可以选择文件夹
        openPanel.canChooseDirectories = false
        // 可以多选
        openPanel.allowsMultipleSelection = false
        openPanel.begin { (ret) in
            if(ret == NSApplication.ModalResponse.OK){
                let l = self.fileCtrl.openParameterFile(path:openPanel.url!)
                self.physics.setParameter(l!)
            }
        }
        
    }
    
   
    /// 动画定时器回调
    func OnTimer(){
        if (physics.particles[0].history.count - mainView.nowTime < 30){
            physics.run()
        }
        DispatchQueue.main.async {
            self.mainView.nowTime += 1
            self.mainView.drawImage()
        }
    }
    /// 视图布局改变
    override func viewDidLayout() {
        gcdTimer?.suspend()
        mainView.drawNewAllImage()
        gcdTimer?.resume()
    }
}

/// 扩展信息回调协议
extension ViewController: NotifyProtocol{
    func complete() {
        if (timerState == false){
            gcdTimer?.resume()
            timerState = true
        }
    }
    
    
}


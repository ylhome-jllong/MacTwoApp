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
    /// 菜单显示模式
    struct MenuMode {
        var Open: Bool
        var New: Bool
    }
    private var menuMode = MenuMode(Open: true, New: false)
    
    
    let physics = Physics()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainView.physics = self.physics
        fileCtrl.physics = self.physics
        updateMenu()
        
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
                guard let particles = self.fileCtrl.openParameterFile(path:openPanel.url!) else {
                    self.msgPanel("配置文件错误")
                    return
                }
                if (particles.count == 0){
                    self.msgPanel("配置文件中没有找到任何粒子")
                    return
                    
                }
                self.physics.setParameter(particles)
                self.menuMode.New = true
                self.menuMode.Open  = false
                self.updateMenu()
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
    
    /// 信息弹窗
    private func msgPanel(_ log: String){
        let alert = NSAlert()
        alert.messageText = "警告框提示！！！"
        alert.informativeText = log
        // 显示图片
        // alert.icon =
        // 警告级别
        alert.alertStyle = .critical
        // 启动框体
        alert.beginSheetModal(for: self.view.window!) { (result) in
        }
    }
    
    /// 更新菜单
    private func updateMenu(){
        let mainMenu = NSApp.mainMenu
        let fileMenuItem = mainMenu?.item(withTitle: "File")
        // 要先设置父级NSMenu 的属性 autoenablesItems = false 然后再设置NSMenuItems 的 属性isEnabled 才有效
        fileMenuItem?.submenu?.autoenablesItems = false
        
        if(menuMode.New){
            fileMenuItem?.submenu?.item(withTitle: "New")?.isEnabled = true
        }else{
            fileMenuItem?.submenu?.item(withTitle: "New")?.isEnabled = false
        }
        
        if(menuMode.Open){
            fileMenuItem?.submenu?.item(withTitle: "Open...")?.isEnabled = true
        }else{
            fileMenuItem?.submenu?.item(withTitle: "Open...")?.isEnabled = false
        }

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


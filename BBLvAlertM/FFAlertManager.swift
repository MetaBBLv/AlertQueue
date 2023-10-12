//
//  FFAlertManager.swift
//  AlertQueue
//
//  Created by BBLv on 2021/04/02.
//

import UIKit

class FFAlertManager: AlertDataDrivenProtocol {
    
    static let sharedInstance: FFAlertManager = FFAlertManager()
    private init() {}
    
    /**数据*/
    var array: NSMutableArray = NSMutableArray()
    
    /**当前展示的数据*/
    var currentModel: FFAlertModel?

    /**程序被主动暂停（切换到后台）*/
    private var isPause: Bool = false
    
    /**展示是否已经开始了*/
    private var isBegin: Bool = false
    
    /**根据准备的数据开始逐步show出Alert*/
    func showAlertBegin() {
        isBegin = true
        if array.count > 0 {
            showAlertAccordingPriorityStatus { model in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNotificationShowAlert"), object: model)
            }
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNotificationPushWebView"), object: nil)
        }
    }
    
    /**单次Alert完成*/
    func showAlertFinish() {
        
        if array.count > 0 {
            showAlertBegin()
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNotificationPushWebView"), object: nil)
        }
    }
    
    /**Alert被迫暂停*/
    func showAlertPause() {
        guard isBegin else { return }
        isPause = true
    }
    
    /**Alert恢复*/
    func showAlertRestore() {
        if isPause {
            isPause = false
            //此处延迟0.5s展示Alert是为了提供用户关键动画，防止程序运行速度超过肉眼反应速度
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showAlertBegin()
            }
        }
    }
    
    /**根据优先级show出Alert*/
    func showAlertAccordingPriorityStatus(_ completion: @escaping(FFAlertModel) -> ()) {
        
        var om: FFAlertModel = FFAlertModel()
        
        for model in array {
            let m:FFAlertModel = model as! FFAlertModel
            if m.priority == .superlative {
                om = m
                break
            }
            if m.priority == .wait {
                om = m
            }
            else if m.priority == .normal {
                om = m
            }
        }
        completion(om)
        //单次数据保存
        dataCurrentShow(om)
    }
    
    /**判断是否出现了想定中需要中途退出的alert*/
    func wetherToTerminateTheAlertProcess(serialNumber: Int, complation: (Bool) -> ()) {
        
        //单纯为了展示默认返回false
        complation(false)
        
        /**此逻辑为我项目中特定要求，在某个编号的alert，终止掉后续操作，结束alert操作
        if serialNumber == 10001 || serialNumber == 10003 {
            dataDeletionForAll()
            complation(true)
        }
        else
        {
            complation(false)
        }
         */
    }
    
    /**检测当前展示的数据是否正在被展示*/
    func checkModelIsCurrent(_ data: FFAlertModel) -> Bool {
        if currentModel == data {
            return true
        }
        else
        {
            return false
        }
    }
    
    /**排除掉因为点击了某个Action，去到safari，此情况下清除掉当前正在缓存的临时model*/
    func deleteModelIsCurrentForTapACtion(serialNumber: Int) {
        if currentModel?.serialNumber == serialNumber {
            currentModel = nil
        }
    }
    
    //MARK: - AlertDataDrivenProtocol
    func dataLoading(_ data: FFAlertModel) {
        
        array.add(data)
    }
    
    func dataDeletionForExecutionComplete(serialNumber: Int) {
        for model in array {
            let m:FFAlertModel = model as! FFAlertModel
            if m.serialNumber == serialNumber {
                array.remove(model)
                break
            }
        }
    }
    
    func dataDeletionForAll() {
        //清理缓存数据
        array.removeAllObjects()
        //清理单条临时数据
        currentModel = nil
    }
    
    func dataCurrentShow(_ data: FFAlertModel) {
        currentModel = data
    }
}

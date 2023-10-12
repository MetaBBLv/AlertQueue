//
//  FFSplashViewController.swift
//  AlertQueue
//
//  Created by BBLv on 2021/01/29.
//

import UIKit

class FFSplashViewController: UIViewController {
    
    //fileprivate var splash: FFSplashView!
    
    fileprivate var dispatcher: FFDispatcher!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerOberver()
        loadSplash()
        dispatcherCenter()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - Private Methed
    
    /**注册通知*/
    private func registerOberver() {
        
        /**showAlert通知*/
        NotificationCenter.default.addObserver(self, selector: #selector(shwoAlert(_:)), name: NSNotification.Name(rawValue: "kNotificationShowAlert"), object: nil)
        /**弹出WebView通知*/
        NotificationCenter.default.addObserver(self, selector: #selector(pushWeb), name: NSNotification.Name(rawValue: "kNotificationPushWebView"), object: nil)
        /**程序进入后台*/
        NotificationCenter.default.addObserver(self, selector: #selector(appHasGoneBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        /**程序回到前台*/
        NotificationCenter.default.addObserver(self, selector: #selector(appHasGoneForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func shwoAlert(_ notify: NSNotification) {
        
        let object = notify.object as! FFAlertModel
        //showAlert之前检查此alert是否正在被展示，解决反复切换前后台产生的问题
        guard !FFAlertManager.sharedInstance.checkModelIsCurrent(object) else {
            return
        }
        self.initializerAlert(title: object.title, message: object.message, actionType: object.actionType, serialNumber: object.serialNumber)
    }
    
    @objc func pushWeb() {
        //执行页面在Alert期间阻塞的逻辑
    }
    
    @objc func appHasGoneBackground() {
        FFAlertManager.sharedInstance.showAlertPause()
    }
    
    @objc func appHasGoneForeground() {
        FFAlertManager.sharedInstance.showAlertRestore()
    }
    
    /**加载splash*/
    private func loadSplash() {
        
    }
    /**业务调度中心*/
    private func dispatcherCenter() {
        dispatcher = FFDispatcher()
        dispatcher.delegate = self

        let group = DispatchGroup()
        group.enter()
        self.dispatcher.appServiceStatusCheck {
            group.leave()
        }

        group.enter()
        self.dispatcher.bulletinCheck {
            group.leave()
        }
        
        group.enter()
        self.dispatcher.jailBreakCheck {
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            FFAlertManager.sharedInstance.showAlertBegin()
        }
    }

    /**序列化Alert*/
    private func initializerAlert(title: String? = "", message: String? = "", actionType: AlertActionType, serialNumber: Int, actionArray: Array<String>? = []) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actionType == AlertActionType.isOk {
            
            let actionOK = UIAlertAction(title: "OK", style: .default) { _ in
                // 将当前的Alert删除
                FFAlertManager.sharedInstance.dataDeletionForExecutionComplete(serialNumber: serialNumber)
                FFAlertManager.sharedInstance.wetherToTerminateTheAlertProcess(serialNumber: serialNumber) { isTermination in
                    if isTermination {
                        //终止程序，关闭SDK
                        self.splashDismiss(animate: false)
                    }
                    else
                    {
                        FFAlertManager.sharedInstance.showAlertFinish()
                    }
                }
                
            }
            alertVC.addAction(actionOK)
        }
        else if actionType == AlertActionType.isDetailAndOk
        {
            let actionCancel = UIAlertAction(title: "详细信息", style: .cancel) { _ in
                
                FFAlertManager.sharedInstance.wetherToTerminateTheAlertProcess(serialNumber: serialNumber) { isTermination in
                    if isTermination {
                        //终止程序，关闭SDK
                        self.splashDismiss(animate: false)
                    }
                    else
                    {
                        //清理掉当前正在展示的model，清楚单次临时缓存
                        FFAlertManager.sharedInstance.deleteModelIsCurrentForTapACtion(serialNumber: serialNumber)
                        //暂停程序，打开Safari
                        UIApplication.shared.open(URL(string: "https:www.baidu.com")!)
                    }
                }
            }
            
            let actionOK = UIAlertAction(title: "OK", style: .default) { _ in
                // 将当前的Alert删除
                FFAlertManager.sharedInstance.dataDeletionForExecutionComplete(serialNumber: serialNumber)
                FFAlertManager.sharedInstance.wetherToTerminateTheAlertProcess(serialNumber: serialNumber) { isTermination in
                    if isTermination {
                        //终止程序，关闭SDK
                        self.splashDismiss(animate: false)
                    }
                    else
                    {
                        FFAlertManager.sharedInstance.showAlertFinish()
                    }
                }
            }
            
            alertVC.addAction(actionCancel)
            alertVC.addAction(actionOK)
        }
        else
        {
            //TODO:多个Action情况，暂时预留
        }
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /**splash关闭，SDK退出*/
    private func splashDismiss(animate: Bool) {
        self.dismiss(animated: animate) {
            self.dispatcher.delegate = nil
        }
    }

}

//MARK: -FFDispatcherDelegate
extension FFSplashViewController: FFDispatcherDelegate {
    
    func dispatchDidServerStatusFail(_ title: String, _ message: String) {
        
        let model = FFAlertModel(title: title, message: message, priority: .superlative, actionType: .isOk, serialNumber: 10001)
        FFAlertManager.sharedInstance.dataLoading(model)

    }
    
    /**公告信息转发*/
    func dispatchDidBulletin(_ message: String) {
        
        let model = FFAlertModel(title: "", message: message, priority: .normal, actionType: .isDetailAndOk, serialNumber: 10002)
        FFAlertManager.sharedInstance.dataLoading(model)
        
    }
    
    func dispatchDidJailBreak(_ title: String, _ message: String) {
        let model = FFAlertModel(title: title, message: message, priority: .wait, actionType: .isOk, serialNumber: 10003)
        FFAlertManager.sharedInstance.dataLoading(model)
    }
    
}

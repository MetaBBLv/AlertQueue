//
//  FFDispatcher.swift
//  AlertQueue
//
//  Created by BBLv on 2021/01/20.
//

import UIKit
/**任务处理中心Delegate*/
protocol FFDispatcherDelegate {
    /**公告信息转发*/
    func dispatchDidBulletin(_ message: String)
    
    /**AppVersionCheck时serverStatus为false*/
    func dispatchDidServerStatusFail(_ title: String, _ message: String)
    
    /**越狱检测为真*/
    func dispatchDidJailBreak(_ title: String, _ message: String)
}

class FFDispatcher {
    
    /**任务处理中心Delegate*/
    var delegate: FFDispatcherDelegate? = nil


    //MARK: - Private Method
    /**越狱检测*/
    func jailBreakCheck(_ callback:@escaping () -> Void) {
        callback()
        if !FFJailBreak.isJailbroken {
            self.delegate?.dispatchDidJailBreak("越狱检测", "你有问题，还要打开我？")
        }
    }
    
    //MARK: - Public Method
    /**公告检测*/
    func bulletinCheck(_ callback:@escaping () -> Void){
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            callback()
            self.delegate?.dispatchDidBulletin("今天心情挺不错的，祝你使用过程无bug")
        }
    }
    
    /**AppVersionCheck */
    func appServiceStatusCheck(_ callback:@escaping ()-> Void) {

        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            callback()
            self.delegate?.dispatchDidServerStatusFail("系统维护", "由于系统维护，该服务目前不可用。 请过一段时间再使用。")
        }
    }
}




//
//  FFAlertModel.swift
//  AssociatedBanks
//
//  Created by D7Test on 2021/04/02.
//

import UIKit

enum AlertPriorityType: Int {
    /**最高级响应*/
    case superlative
    /**正常响应*/
    case normal
    /**等待响应*/
    case wait
}

enum AlertActionType {
    case isOk
    case isDetailAndOk
    case isCustom
}

class FFAlertModel: NSObject, NSCoding {
    
    var title: String = ""
    var message: String = ""
    var priority: AlertPriorityType = .normal
    var actionType: AlertActionType = .isOk
    var actionArray: Array<String> = []
    var serialNumber: Int = 10001
    
    init(title: String = "", message: String = "", priority: AlertPriorityType = .normal, actionType: AlertActionType = .isOk, serialNumber: Int = 10001, actionArray: Array<String> = []) {
        self.title = title
        self.message = message
        self.priority = priority
        self.actionType = actionType
        self.serialNumber = serialNumber
        self.actionArray = actionArray
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.message, forKey: "message")
        coder.encode(self.priority, forKey: "priority")
        coder.encode(self.actionType, forKey: "actionType")
        coder.encode(self.actionArray, forKey: "actionArray")
    }
    
    required init?(coder: NSCoder) {
        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
        self.message = coder.decodeObject(forKey: "message") as? String ?? ""
        self.priority = coder.decodeObject(forKey: "priority") as? AlertPriorityType ?? .normal
        self.actionType = coder.decodeObject(forKey: "actionType") as? AlertActionType ?? .isOk
        self.actionArray = coder.decodeObject(forKey: "actionArray") as? Array ?? []
    }
}

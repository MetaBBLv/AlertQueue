//
//  AlertDataDrivenProtocol.swift
//  AlertQueue
//
//  Created by BBLv on 2021/04/02.
//

import Foundation

protocol AlertDataDrivenProtocol {
    
    /**数据装载*/
    func dataLoading(_ data: FFAlertModel)
    
    /**数据删除（执行完成的数据）*/
    func dataDeletionForExecutionComplete(serialNumber: Int)
    
    /**数据删除*/
    func dataDeletionForAll()
    
    /**当前正在展示的数据*/
    func dataCurrentShow(_ data: FFAlertModel)
}

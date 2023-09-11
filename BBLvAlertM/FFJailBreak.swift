//
//  FFJailBreak.swift
//  AssociatedBanks
//
//  Created by D7Test on 2021/01/20.
//

import UIKit

/**越狱检测
 "/usr/libexec/sftp-server",
 "/usr/sbin/sshd"
 模拟器开发阶段暂时不进行检测
 */
class FFJailBreak {
    
    private static let pathArray: [String] = ["/Applications/Cydia.app",
                                              "/Applications/blackra1n.app",
                                              "/Applications/FakeCarrier.app",
                                              "/Applications/IntelliScreen.app",
                                              "/Applications/MxTube.app",
                                              "/Applications/RockApp.app",
                                              "/Applications/SBSettings.app",
                                              "/Applications/WinterBoard.app",
                                              "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                                              "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                                              "/private/var/lib/apt",
                                              "/private/var/lib/cydia",
                                              "/private/var/mobile/Library/SBSettings/Themes",
                                              "/private/var/stash",
                                              "/private/var/tmp/cydia.log",
                                              "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                                              "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                                              "/usr/bin/sshd",
                                              "/usr/libexec/sftp-server",
                                              "/usr/sbin/sshd"
    ]
    
    static var isJailbroken: Bool {
        
        for path in pathArray{
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
     
        return false
    }
}

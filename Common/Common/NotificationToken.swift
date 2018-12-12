//
//  NotificationToken.swift
//  Common
//
//  Created by GK on 2018/7/27.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import Foundation

final class NotificationToken: NSObject {
    let notificationCenter: NotificationCenter
    let token: Any
    
    init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }
    deinit {
        notificationCenter.removeObserver(token)
    }
}

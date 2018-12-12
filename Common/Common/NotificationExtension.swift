//
//  NotificationExtension.swift
//  Common
//
//  Created by GK on 2018/7/27.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import Foundation

extension NotificationCenter {
    func observe(name: NSNotification.Name?, object obj: Any?,
                 queue: OperationQueue?, using block: @escaping (Notification) -> ())
        -> NotificationToken
    {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }
}

//
//  Config.swift
//  SwiftDD
//
//  Created by GK on 2018/7/9.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import Foundation
import Profile

struct Config {
    
}

extension Config: ProfileConfig {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.01"
    static let userId = "123456789"
}

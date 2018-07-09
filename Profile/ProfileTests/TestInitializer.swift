//
//  TestInitializer.swift
//  Profile
//
//  Created by GK on 2018/7/9.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import Foundation
import Profile

class TestInitializer: NSObject {
    override init() {
        Profile.setup(with: MockConfig.self)
    }
}

private class MockConfig: ProfileConfig {
    static let appVersion = "1.0"
    static let userId = "1234"
}

//
//  ConfigType.swift
//  Profile
//
//  Created by GK on 2018/7/9.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import Foundation

public protocol ProfileConfig {
    static var userId: String { get }
    static var appVersion: String { get }
}
public func setup(with config: ProfileConfig.Type) {
    ConfigType.shared = ConfigType(config)
}
final class ConfigType {
    static fileprivate var shared: ConfigType?
    
    let userId: String
    let appVersion: String
    
    fileprivate init(_ config: ProfileConfig.Type ) {
        self.userId = config.userId
        self.appVersion = config.appVersion
    }

}
var Config: ConfigType { // swiftlint:disable:this variable_name
    if let config = ConfigType.shared {
        return config
    } else {
        fatalError("Please set the Config for \(Bundle(for: ConfigType.self))")
    }
}

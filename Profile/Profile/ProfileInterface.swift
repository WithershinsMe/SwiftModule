//
//  ProfileInterface.swift
//  Profile
//
//  Created by GK on 2018/7/9.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import Foundation

public func getProfileViewController() -> UIViewController {
    let vc = ProfileViewController()
    vc.view.backgroundColor = UIColor.red;
    return vc;
}

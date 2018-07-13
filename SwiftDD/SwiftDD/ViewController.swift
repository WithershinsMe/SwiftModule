//
//  ViewController.swift
//  SwiftDD
//
//  Created by GK on 2018/7/9.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import UIKit
import Profile

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let vc = Profile.getProfileViewController()
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }

}


//
//  CommonTests.swift
//  CommonTests
//
//  Created by GK on 2018/7/9.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import XCTest
@testable import Common
@testable import TestHelpers

class CommonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("common test")
        print(TestHelpers.testHelperShared())

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

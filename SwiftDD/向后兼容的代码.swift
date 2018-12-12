//
//  File.swift
//  SwiftDD
//
//  Created by GK on 2018/7/30.
//  Copyright © 2018年 com.gk. All rights reserved.
// https://www.swiftbysundell.com/posts/writing-backward-compatible-swift-code

import Foundation

//添加返回值

//假设用URLhandler来掌控各种资源的URL调用
//第一版
//class URLHandler {
//
//    @discardableResult   //告诉编译器可以抛弃Outcome的结果，
//    func handle(_ url: URL)  -> URLHandler.Outcome{  //第二版加入返回参数
//       // ...
//    }
//}
////第二版
//extension URLHandler {
//    enum Outcome {
//        case handled
//        case failed(Error)
//    }
//}

//更改枚举类型
//extension Naviagtor {
//    enum Destination {
//        case favorites
//        case bookList
//      //  case book(String)
//        case bookDetail(String)
//    }
//}
//extension Navigator.Destination {
//    //兼容api
//    static func book(_ book: Book) -> Navigator.Destination {
//        return .bookDetails(book.metadata)
//    }
//}
//// 更改函数参数  给新增加的参数赋初值
//
//func loadData(from url: URL,
//              then handler: @escaping (Result<Data>) -> Void) {
//    ...
//}
//func loadData(from url: URL,
//              timeout: TimeInterval = 10,
//              then handler: @escaping (Result<Data>) -> Void) {
//    ...
//}


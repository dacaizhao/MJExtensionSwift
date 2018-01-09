//
//  BeautyModel.swift
//  Whiteboard
//
//  Created by point on 2018/1/7.
//  Copyright © 2018年 point. All rights reserved.
//

import UIKit

class BeautyModel: NSObject {
    @objc var title: String = ""
    @objc var ct: String = ""
    @objc var beautyModelList:Array<BeautyModelList> = [BeautyModelList]()


    override func tmReplacedKey() -> [String : String] {
        return ["beautyModelList":"list"]
    }
    
    override func tmStatementKey() -> [String : String] {
        return ["beautyModelList":"ModelArr"]
    }
    
}



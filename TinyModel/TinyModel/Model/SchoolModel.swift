//
//  SchoolModel.swift
//  TinyModel
//
//  Created by point on 2017/10/25.
//  Copyright © 2017年 dacai. All rights reserved.
//

import UIKit

class SchoolModel: NSObject {
    @objc var schoolID: Int = 0
    @objc var schoolName: String = ""
  
    @objc var classModel:Array<ClassModel> = [ClassModel]()
    
    override func tmStatementKey() -> [String : String] {
        return ["classModela":"ModelArr"]
    }
    override func tmReplacedKey() -> [String : String] {
        return ["classModela":"luanxie"]
    }
}

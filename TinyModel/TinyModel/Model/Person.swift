//
//  Person.swift
//  TinyModel
//
//  Created by point on 2017/10/25.
//  Copyright © 2017年 dacai. All rights reserved.
//

import UIKit

class Person: Animal {
    @objc var coding: Array<String> = [String]()
    @objc var schoolModel: SchoolModel = SchoolModel()
    
    override func tmReplacedKey() -> [String : String] {
        return ["schoolModel":"school","coding":"code"]
    }
    
    override func tmStatementKey() -> [String : String] {
        return ["schoolModel":"AloneModel"]
    }
}

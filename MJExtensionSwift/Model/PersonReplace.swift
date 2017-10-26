//
//  PersonReplace.swift
//  TinyModel
//
//  Created by point on 2017/10/25.
//  Copyright © 2017年 dacai. All rights reserved.
//

import UIKit

class PersonReplace: NSObject {
@objc var coding: Array<String> = [String]()
    override func tmReplacedKey() -> [String : String] {
        return ["coding":"code"]
    }
}

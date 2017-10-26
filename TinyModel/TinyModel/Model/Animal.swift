//
//  Animal.swift
//  TinyModel
//
//  Created by point on 2017/10/25.
//  Copyright © 2017年 dacai. All rights reserved.
//

import UIKit

class Animal: NSObject {
    @objc var age: Int = 0
    @objc var name: String = ""
    @objc var reproduction: Bool = false
    @objc var weight: CGFloat = 0
    @objc var spouse: Array<String> = [String]()
  
}

//
//  StudentModel.swift
//  DCSwiftExtension
//
//  Created by point on 2017/1/8.
//  Copyright © 2017年 dacai. All rights reserved.
//

import UIKit

class StudentModel: PersonModel {

    var stuNo:Int = 0
    var height:NSNumber = 0
    var stuName:String = ""
    var hasGirlFriend:Bool = false
    var teacherName:NSArray = []
    var classModel = ClassModel()
    var qq:String = ""
    
    override func replacedKeyFromPropertyName() ->[String:String]{
        return ["qq":"replacedKey"]
    }
    
}

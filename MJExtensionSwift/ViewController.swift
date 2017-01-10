//
//  ViewController.swift
//  MJExtensionSwift
//
//  Created by point on 2017/1/10.
//  Copyright © 2017年 dacai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //先仔细阅读一下字典内部注释,就可以很快清晰MJExtensionSwift

        let dict = [
            "age":12,
            "name":"M了个J",
            "gender":"男",
            //***********************  注意:这3个属性StudentModel 并没写它继承于PersonModel
            "stuNo":1, //整型
            "height":174.55, //浮点型
            "stuName":"赵大财", //字符串
            "hasGirlFriend":true, //布尔
            "teacherName":["zhao","qian","sun","li"], //普通数组
            //***********************  注意:这里是5种基本类型
            "replacedKey":"qq:327532717",
            //***********************  注意:这里的key我会替换一下
            
            "classModel":[
                            "classID":10,
                            "className":"小码哥大神100期毕业典礼",
                            "personModel":[
                                           ["age":nil,"gender":"男","name":nil], //***** 注意:这里有nil值免崩溃
                                           ["age":12,"gender":"女","name":"zhaodacai2"],
                                           ["age":14,"gender":"鬼","name":"zhaodacai3"],
                                           ["age":13,"gender":"仙","name":"zhaodacai4"],//***** 注意:这是自定义的Model数组类型
                                          ]
            ]
            //***********************  注意:这是自定义的Model类型
            ] as [String : Any]
        
        
        //OK 搞起来吧
         let dacaiModel:StudentModel = StudentModel.dcObjectWithKeyValues(dict as NSDictionary)  as! StudentModel
        
        
        // 1:先看父级属性是否成功
        print("父级属性年龄:\(dacaiModel.age)","父级属性姓名:\(dacaiModel.name)","父级属性性别:\(dacaiModel.gender)")
        print("11111111111111111111111")
        
        
        // 2:在看5种基本数据类型
         print("学号Int:\(dacaiModel.stuNo)","身高NSNumber:\(dacaiModel.height)","名字String:\(dacaiModel.stuName)")
        //布尔型
        if dacaiModel.hasGirlFriend {
            print("Bool:有女朋友")
        }else{
            print("Bool:没有女朋友")
        }
        //基本数组
        print("NSArray:",dacaiModel.teacherName.count,dacaiModel.teacherName)
        print("222222222222222222222222")
        
        //3:我们看看替换key
        print("replacedKey替换为QQ:",dacaiModel.qq)
        print("333333333333333333333333")
        
        //4:我们看看自定义模型
         print("自定义班级ID:\(dacaiModel.classModel.classID)","自定义班级名称:\(dacaiModel.classModel.className)")
        print("444444444444444444444444")
        
        
        //5:看看自定义模型的 数组自定义模型
        var i = 0
        for model in dacaiModel.classModel.personModel as Array {  //注意第一个 nil会自动帮你智能补充
            if (i == 0 ){
            print("请注意观察这里的nil:","String姓名:\(model.name)","Int年龄:\(model.age)","NsNumber性别:\(model.gender)")
            }else {
             print("String姓名:\(model.name)","Int年龄:\(model.age)","NsNumber性别:\(model.gender)")
            }
           
            i = i + 1
        }
        print("444444444444444444444444")
        
    }
}


//
//  ViewController.swift
//  TinyModel
//
//  Created by point on 2017/10/25.
//  Copyright © 2017年 dacai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TinyModelDebug = true
        //已适配swift4.0 - TinyModel字典封印之术
        
        //demo0
        //最简单的模型 整形 浮点 字符串 布尔 数组
        //值得一提的是 swif数组已可变
        demo0()
        
        //demo1
        //支持父级属性的继承
        demo1()
        
        //demo2
        //模型数组
        //且修改数组 coding 增加c#
        //key 写错给予提示性
        demo2()
        
        
        //demo3
        //替换下标
        demo3()
        
        //demo4
        //模型嵌套模型且有空值的过滤
        demo4()
        
        
        //demo5
        //模型嵌套模型且有空值的过滤 含有数组
        demo5()
        
        
    }
    
}

extension ViewController {
    
    func demo5() {
        
        let dict = ["age":10,
                    "name":"旺财写代码",
                    "reproduction":true,
                    "weight":19.99,
                    "spouse":["zhao","qian","sun","li"],
                    "code":["java","php","swift","python"],
                    "school":["schoolID":"10000",
                              "schoolName":"cccc",
                              "luanxie":[
                                ["classID":"10001",
                                 "className":"11"],
                                ["classID":"10002",
                                 "className":"11"],
                                ["classID":"10003",
                                 "className":"11"],
                        ]
            ],
                    ] as [String : AnyObject]
        
        
        let model = Person.tmSpeelBreak(dict as Dictionary<String, AnyObject>)
        print(model.schoolModel.schoolName,model.coding,model.schoolModel.schoolID,"schoolNamenil-->",model.schoolModel.schoolName)
        
        for m in model.schoolModel.classModel {
            print(m.classID)
        }
    }
    
    func demo4() {
        let dict = ["age":10,
                    "name":"旺财写代码",
                    "reproduction":true,
                    "weight":19.99,
                    "spouse":["zhao","qian","sun","li"],
                    "code":["java","php","swift","python"],
                    "school":["schoolID":"10000",
                              "schoolName":nil
            ],
                    ] as [String : AnyObject]
        let model = Person.tmSpeelBreak(dict)
        print(model.schoolModel.schoolName,model.coding,model.schoolModel.schoolID,"schoolNamenil-->",model.schoolModel.schoolName)
    }
    
    func demo3() {
        let dict = ["age":10,
                    "name":"旺财写代码",
                    "reproduction":true,
                    "weight":19.99,
                    "spouse":["zhao","qian","sun","li"],
                    "code":["java","php","swift","python"],
                    ] as [String : Any]
        let model = PersonReplace.tmSpeelBreak(dict as Dictionary<String, AnyObject>)
        print(model.coding)
    }
    
    func demo2() {
        let arr = [
            ["age":10,
             "name":"旺财1",
             "reproduction":true,
             "weight":19.99,
             "spouse":["zhao","qian","sun","li"],
             "code":["java","php","swift","python"],
             ],
            ["age":10,
             "name":"旺财2",
             "reproduction":true,
             "weight":19.99,
             "spouse":["zhao","qian","sun","li"],
             "code":["java","php","swift","python"],
             ],
            ["age":10,
             "name":"旺财3",
             "reproduction":true,
             "weight":19.99,
             "spouse":["zhao","qian","sun","li"],
             "codecode":["java","php","swift","python"],
             ]
        ]
        let modelArr = Person.tmSpeelBreakModelArr(arr)
        for (index,model) in modelArr.enumerated() {
            let  p:Person = model as! Person
            if index == 0 {
                p.coding.append("c#")
            }
            print("循环列出-" , index,model.name , model.spouse,model.coding )
        }
    }
    
    func demo1() {
        let dict = ["age":10,
                    "name":"旺财写代码",
                    "reproduction":true,
                    "weight":19.99,
                    "spouse":["zhao","qian","sun","li"],
                    //"coding":["java","php","swift","python"],
            "code":["java","php","swift","python"],
            ] as [String : AnyObject]
        let model = Person.tmSpeelBreak(dict as Dictionary<String, AnyObject>)
        print(model.age,model.name,model.reproduction,model.weight,model.spouse,model.coding)
    }
    
    func demo0() {
        let dict = ["age":10,
                    "name":"旺财",
                    "reproduction":true,
                    "weight":19.99,
                    "spouse":["zhao","qian","sun","li"],
                    ] as [String : Any]
        let model = Animal.tmSpeelBreak(dict as Dictionary<String, AnyObject>)
        model.spouse.append("wang") //@objc var spouse: Array<String> = [] //请观察一下
        print(model.age,model.name,model.reproduction,model.weight,model.spouse)
    }
}

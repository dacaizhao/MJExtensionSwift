//
//  TinyModel.swift
//  TinyModel
//
//  Created by point on 2017/10/23.
//  Copyright © 2017年 dacai. All rights reserved.
//

import UIKit
var TinyModelDebug = false

enum TinyModelType : String {
    case Base = "Base"
    case ModelArr = "ModelArr"
    case Model = "Model"
}

extension NSObject{
    
    class func tmSpeelBreak(_ keyValues:Dictionary<String, AnyObject>) -> Self{
        let tyFormatModel = self.init()
        let properties = getProperties(self) //获取属性
        tyFormatModel.setValuesForProperties(properties, keyValues: keyValues)
        return tyFormatModel
    }
    
    class func tmSpeelBreakModelArr(_ array:Array<Any>) -> [AnyObject]{
        return tmObjectArrayWithKeyValuesArray(array , self)
    }
    
    private class func tmObjectArrayWithKeyValuesArray(_ array:Array<Any> , _ currentClass:AnyClass) -> [AnyObject]{
        var temp = Array<AnyObject>() //定义1个数组
        let properties = self.getProperties(currentClass) //获取当前类的属性
        
        for item in array {  //便利数组
            let keyValues = item as? NSDictionary //数组里面的字典
            if (keyValues != nil){
                let model = self.init()
                //为每个model赋值
                model.setValuesForProperties(properties, keyValues: keyValues! as! Dictionary<String, AnyObject>)
                temp.append(model)
            }
        }
        return temp
    }
    
    
    //获取属性
    private class func getProperties (_ typeClass : AnyClass) -> [TMProperty]? {
        
        guard let className  = NSString(cString: class_getName(typeClass), encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }  //获取类型
        
        if className.isEqual(to: "NSObject") {
            return nil
        }
        let my = self.init()
        let statementDict = my.tmStatementKey() //累的类型
        let replaceDic = my.tmReplacedKey() //替换的下标
        
        
        
        var propertiesArray = [TMProperty]()
        let tmSuperClass =  typeClass.superclass() as! NSObject.Type
        
        let superM = getProperties(tmSuperClass)
        if let _ = superM {
            propertiesArray += superM!
        }  //获取父累
        var count : UInt32 = 0
        let ivars = class_copyIvarList(typeClass, &count)!
        for i in 0..<count {
            let ivar = ivars[Int(i)]
            propertiesArray.append(TMProperty(ivar,statementDict, replaceDic))
        }
        free(ivars)
        return propertiesArray
    }
    
    
    
    //赋值
    private func setValuesForProperties(_ properties:[TMProperty]?,keyValues:Dictionary<String, AnyObject>){
        
        guard (properties != nil) else {
            return
        }
        var currentDict = keyValues
        for property in properties!{
            if property.tmModelType ==  .Model {
                guard let value = currentDict[property.tmPropertykey] else {
                    debugPrint("TinyModelDebug: " + property.tmPropertyName + "检测出空值")
                    return
                }
                let currentModel = property.typeClass as! NSObject.Type
                self.setValue(currentModel.tmSpeelBreak(value as! Dictionary<String, AnyObject>), forKey: property.tmPropertyName)
                currentDict = value as! [String : AnyObject]
                
            } else if (property.tmModelType ==  .ModelArr) {
                if property.typeClass  == nil {
                    debugPrint("TinyModelDebug: " + property.tmPropertyName + "key与你创建的类不一致")
                    return
                }
                let value = currentDict[property.tmPropertykey]
                let currentModel = property.typeClass as! NSObject.Type
                let currentArr = currentModel.tmSpeelBreakModelArr(value as! Array)
                self.setValue(currentArr, forKey: property.tmPropertyName)
                
            } else {
                guard let value = currentDict[property.tmPropertykey] else {
                    debugPrint("TinyModelDebug: " + property.tmPropertyName + "模型与字典的key不匹配")
                    return
                }
                let type = NSStringFromClass(object_getClass(value)!)
                if type != "NSNull" {
                    self.setValue(value, forKey: property.tmPropertyName)
                }else {
                    debugPrint("TinyModelDebug: " + property.tmPropertyName + "值为nil")
                }
                
            }
        }
    }
    
    
    //MARK: - DEBUG控制
    fileprivate func debugPrint(_ message:String)   {
        if TinyModelDebug {
            print(message)
        }
    }
    
    @objc func tmStatementKey() ->[String:String]{
        return ["":""]
    }
    
    @objc func tmReplacedKey() ->[String:String]{
        return ["":""]
    }
}


class TMProperty {   //每个元素属性
    var tmPropertyName:String! //名字
    var tmPropertykey:String!  //可能存重写
    var tmModelType:TinyModelType = .Base //当前属性的类型
    var typeClass:AnyClass? //当前类的名称
    init(_ tmProperty:objc_property_t ,_ dict:Dictionary<String, String> , _ rdict:Dictionary<String, String>){
        let name = ivar_getName(tmProperty)
        self.tmPropertyName = String(cString: name!)
        self.analysisTMModel(values: self.tmPropertyName,dict,rdict)
    }
    
    //判断是否是自定义类型
    private func analysisTMModel(values:String , _ dict:Dictionary<String, String>, _ rdict:Dictionary<String, String>)  {
        /*
         注意： beautyModelList 应该是类的类型
         */
        self.tmPropertykey =  self.tmPropertyName
        let keyStatement = dict[values] //类的申明
        let keyRepalce = rdict[values] //类的替换
        
        if (keyRepalce != nil) { //替换掉
            self.tmPropertykey =  keyRepalce!
        }
        
        if (keyStatement != nil) {
            let value = keyStatement!
            if value.contains("Model") {
                self.tmModelType = .Model
            }
            if value.contains("ModelArr") {
                self.tmModelType = .ModelArr
            }
            //生成类型
            let className = tmFristCapitalized(str: self.tmPropertyName)
            self.typeClass =  NSClassFromString(tmGetBundleName() + "." + className)
        }
    }
    
    //首字母大写
    fileprivate func tmFristCapitalized(str:String) -> String {
        var noNumber:String = ""
        var i = 0
        for char in str{
            if i == 0 {
                let str = String(char).uppercased()
                noNumber = str
            }else {
                noNumber += String(char)
            }
            i = i+1
        }
        return noNumber
    }
    
    //获取工程的名字
    fileprivate func tmGetBundleName() -> String{
        var bundlePath = Bundle.main.bundlePath
        bundlePath = bundlePath.components(separatedBy: "/").last!
        bundlePath = bundlePath.components(separatedBy: ".").first!
        return bundlePath
    }
    
    
    
}

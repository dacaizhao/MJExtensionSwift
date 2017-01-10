//
//  MJExtensionSwift.swift
//  MJExtensionSwift
//
//  Created by point on 2017/1/10.
//  Copyright © 2017年 dacai. All rights reserved.
//

import UIKit
enum DCSwiftExtensionType : NSString {
    case Int = "Int"
    case NSNumber = "NSNumber"
    case NSString = "NSString"
    case NSArray = "NSArray"
    case customClass = "CustomClass"
}

extension NSObject{
    
    class func dcObjectWithKeyValues(_ keyValues:NSDictionary) -> AnyObject{
        return dcObjectWithKeyValues(keyValues,self)
    }
    
    class func dcObjectArrayWithKeyValuesArray(_ array:NSArray) -> [AnyObject]{
        return dcObjectArrayWithKeyValuesArray(array, self)
    }
    
    
    fileprivate class func dcObjectWithKeyValues(_ keyValues:NSDictionary ,  _ currentClass:AnyClass ) -> AnyObject{
        let model = self.init()
        let properties = self.getProperties(typeClass: currentClass)
        model.setValuesForProperties(properties, keyValues: keyValues)
        return model
    }
    
    fileprivate class func dcObjectArrayWithKeyValuesArray(_ array:NSArray , _ currentClass:AnyClass) -> [AnyObject]{
        var temp = Array<AnyObject>()
        let properties = self.getProperties(typeClass: currentClass)
        for item in array{
            let keyValues = item as? NSDictionary
            if (keyValues != nil){
                let model = self.init()
                //为每个model赋值
                model.setValuesForProperties(properties, keyValues: keyValues!)
                temp.append(model)
            }
        }
        return temp
    }
    
    
    func setValuesForProperties(_ properties:[DCProperty]?,keyValues:NSDictionary){
        guard let _ = properties else{
            return
        }
        
        
        for property in properties!{
            if property.dcPropertyType.isCustomClass {
                let value = keyValues[property.key]
                let subClass = property.dcPropertyType.typeClass?.dcObjectWithKeyValues(value as! NSDictionary)
                self.setValue(subClass, forKey: property.dcPropertyName as String)
            }else {
                if property.dcPropertyType.isArray {
                    let value = keyValues[property.key]
                    let tempValue  = value as! [Any]
                    if !dcIsDict(things: tempValue) {
                        self.setValue(tempValue, forKey: property.dcPropertyName as String)
                    }else {
                        let type = dcGetBundleName() + "." + dcFristCapitalized(str: property.key as String)
                        let temp = NSClassFromString(type)?.dcObjectArrayWithKeyValuesArray(value as! NSArray)
                        self.setValue(temp, forKey: property.dcPropertyName as String)
                    }
                }else{
                    //var value:Any!
                    if (keyValues[property.key] as? String) == nil && property.dcPropertyType.code == DCSwiftExtensionType.NSString.rawValue {
                        let value = ""
                        self.setValue(value, forKey: property.dcPropertyName as String)
                    }else if (keyValues[property.key] as? String) != nil && property.dcPropertyType.code == DCSwiftExtensionType.NSString.rawValue {
                        let value = keyValues[property.key]
                        self.setValue(value, forKey: property.dcPropertyName as String)
                    }
                    
                    if (keyValues[property.key] as? NSNumber) == nil && property.dcPropertyType.code == DCSwiftExtensionType.NSNumber.rawValue {
                        let value = 0
                        self.setValue(value, forKey: property.dcPropertyName as String)
                    }else if (keyValues[property.key] as? NSNumber) != nil && property.dcPropertyType.code == DCSwiftExtensionType.NSNumber.rawValue {
                        let value = keyValues[property.key]
                        self.setValue(value, forKey: property.dcPropertyName as String)
                    }
                }
            }
        }
        
    }
    
    //获取类属性
    class func getProperties(typeClass:AnyClass) -> [DCProperty]? {
        guard let className  = NSString(cString: class_getName(typeClass), encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        if className.isEqual(to: "NSObject"){
            return nil
        }
        var propertiesArray = [DCProperty]()
        let dcSuperClass =  typeClass.superclass() as! NSObject.Type
        let superM = getProperties(typeClass: dcSuperClass)
        if let _ = superM{
            propertiesArray += superM!
        }
        
        var outCount:UInt32 = 0
        let properties = class_copyPropertyList(typeClass,&outCount)
        let replacedDic = self.init().replacedKeyFromPropertyName()
        for i in 0 ..< Int(outCount) {
            //let name = String(utf8String:  property_getName(properties?[i]))
            let property = DCProperty((properties?[i])!)
            if let key = replacedDic[property.dcPropertyName as String] {
                property.key = key as NSString
            }
            if property.dcPropertyType.isArray {
                property.dcPropertyType.arrayClass = NSClassFromString("NSArray")
            }
            propertiesArray.append(property)
        }
        return propertiesArray
    }
    
    func replacedKeyFromPropertyName() ->[String:String]{
        return ["":""]
    }
    
    class DCProperty{
        var dcPropertyName:NSString!
        var dcProperty:objc_property_t
        var dcPropertyType:DCType!
        var key:NSString
        
        
        init(_ dcProperty:objc_property_t){
            self.dcProperty = dcProperty
            self.dcPropertyName = NSString(cString: property_getName(dcProperty), encoding: String.Encoding.utf8.rawValue)
            key = self.dcPropertyName as NSString
            var  code: NSString = NSString(cString: property_getAttributes(dcProperty), encoding: String.Encoding.utf8.rawValue)!
            if code.contains(","){
                code = dcRemoveNumber(str: code as String) as NSString
                let arr = code.components(separatedBy: ",")
                let firstStr = arr[0]
                
                
                if firstStr == "Tq" || firstStr == "TB"{
                    code = DCSwiftExtensionType.NSNumber.rawValue
                }else if (firstStr == "T@\"NSNumber\"") {
                    code = DCSwiftExtensionType.NSNumber.rawValue
                }else if (firstStr == "T@\"NSString\"") {
                    code = DCSwiftExtensionType.NSString.rawValue
                }else if (firstStr == "T@\"NSArray\"") {
                    code = DCSwiftExtensionType.NSArray.rawValue
                }else if  code.contains(dcGetBundleName()){
                    let arr = firstStr.components(separatedBy: dcGetBundleName())
                    var firstStr:String = arr[1]
                    firstStr = String(firstStr.characters.filter { $0 != "\"" })
                    code = firstStr as NSString
                }
                self.dcPropertyType = DCType(code)
            }
        }
    }
    
    class DCType {
        //类名字
        var code:NSString
        //类的类型
        var typeClass:AnyClass?
        //数组里面放置的类型
        var arrayClass:AnyClass?
        //是否属于自定义类型
        var isCustomClass:Bool = false
        //是否是数组
        var isArray:Bool = false
        init(_ code:NSString){
            self.code = code
            
            if  self.code.hasPrefix("NS") {
                self.typeClass = NSClassFromString(self.code as String)
                if self.code == DCSwiftExtensionType.NSArray.rawValue {
                    isArray = true
                }
            }else {
                self.typeClass = dcGetClassWitnClassName(self.code as String)
                isCustomClass = true
            }
        }
    }
}

//获取工程的名字
fileprivate func dcGetBundleName() -> String{
    var bundlePath = Bundle.main.bundlePath
    bundlePath = bundlePath.components(separatedBy: "/").last!
    bundlePath = bundlePath.components(separatedBy: ".").first!
    return bundlePath
}

//通过类名返回一个AnyClass
fileprivate func dcGetClassWitnClassName(_ name:String) ->AnyClass?{
    let type = dcGetBundleName() + "." + name
    return NSClassFromString(type)
}

//移除所有数字
fileprivate func dcRemoveNumber(str:String) -> String {
    //在去掉剩下的数字
    var noNumber:String = ""
    for char in (str as String).characters{
        if char > "9" || char < "0"{
            noNumber += String(char)
        }
    }
    return noNumber
}

//首字母大写
fileprivate func dcFristCapitalized(str:String) -> String {
    var noNumber:String = ""
    var i = 0
    for char in (str as String).characters{
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

//判断是字典
fileprivate func dcIsDict (things:[Any]) -> Bool {
    for item in things.enumerated(){
        if item.offset == 0 {
            switch item.element {
            case let isDict as NSDictionary:
                let _ = isDict
                return true
            default:
                return false
            }
        }
    }
    return false
}

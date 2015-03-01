//
//  EveParsing.swift
//  client
//
//  Created by Tomasz Strejczek on 01/03/15.
//  Copyright (c) 2015 EveNucleus. All rights reserved.
//

import Foundation


protocol IResponseMapper {
    func setCachedUnti(date:NSDate)
    func setCurrentTime(date:NSDate)
    func nextRow()
    func setRowValue(name: String, value: String)
}

class ResponseMapper<T:NSObject>: IResponseMapper {
    
    var fields = Dictionary<String, MirrorType>()
    var result:EveResponse<T>
    
    init(res: EveResponse<T>) {
        result = res
        getProperties()
    }
    
    func setCachedUnti(date:NSDate) {
        result.cachedUntil = date
    }
    func setCurrentTime(date:NSDate) {
        result.currentTime = date
    }
    func nextRow() {
        result.rows.append(T())
    }
    func setRowValue(name: String, value: String) {
        var tp = fields[name]
        if tp == nil {return;}

        var row = result.rows.last!
        var val = row[name]
        
        if let v = val as? NSString {
            row[name] = value
            return
        }
        if let v = val as? NSNumber {
            row[name] = NSNumberFormatter().numberFromString(value)
            return
        }
    }
    
    
    func getProperties() {
        var t = T()
        
        let mirror = reflect(t)
        for index in 0 ..< mirror.count {
            let (childKey, childMirror) = mirror[index]
            if let ch = childMirror as MirrorType? {
                fields[childKey] = ch
            }
        }
    }
}


class EveParser: NSObject, NSXMLParserDelegate {
    
    var toset: IResponseMapper
    
    init(mapper: IResponseMapper) {
        toset = mapper
        super.init()
    }
    
    func Parse(data: String) -> Error? {
        var nsdata = data.dataUsingEncoding(NSUTF8StringEncoding)
        var parser = NSXMLParser(data: nsdata)
        parser.delegate = self
        if !parser.parse() {
            return Error(code: parser.parserError?.code ?? 0, domain: "EveParser::Parse", userInfo: ["Line":parser.lineNumber, "Column":parser.columnNumber, "Description":parser.parserError?.description])
        }

        return nil
    }
    
    
    var currentValue = NSMutableString()
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        currentValue = ""
        if elementName == "row" {
            toset.nextRow()
            let dict = attributeDict as NSDictionary!
            for elem in dict {
                var key = elem.key as NSMutableString
                var value = elem.value as NSMutableString
                toset.setRowValue(key, value:value)
            }
        }
    }
    
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        switch(elementName) {
        case "currentTime":
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var val = dateFormatter.dateFromString(currentValue)
            if val != nil {
                toset.setCurrentTime(val!)
            }
            break;
        case "cachedUntil":
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var val = dateFormatter.dateFromString(currentValue)
            if val != nil {
                toset.setCachedUnti(val!)
            }
            break;
        default:
            break;
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        currentValue.appendString(string)
    }
}

public class EveResponse<T:NSObject>: NSObject {
    public var currentTime = NSDate()
    public var cachedUntil = NSDate()
    public var rows = Array<T>()
    
    public override init() {
        super.init()
    }
    
    public func Parse(data: String) -> Error? {
        var mapper = ResponseMapper<T>(res: self)
        var p = EveParser(mapper: mapper)
        return p.Parse(data)
    }
}

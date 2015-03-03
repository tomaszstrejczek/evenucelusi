//
//  EveApi.swift
//  client
//
//  Created by Tomasz Strejczek on 01/03/15.
//  Copyright (c) 2015 EveNucleus. All rights reserved.
//

import Foundation


public class EveCharacter: NSObject {
    public var name: NSString
    public var characterID: UInt64
    public var corporationName: NSString
    public var corporationID: UInt64
    public var allianceID: UInt64
    public var allianceName: NSString
    public var factionID: UInt64
    public var factionName: NSString
    
    public override init() {
        name = ""
        characterID = 0
        corporationName = ""
        corporationID = 0
        allianceID = 0
        allianceName = ""
        factionID = 0
        factionName = ""
    }
}

public class EveApi: IEveApi {
    let baseurl=NSURL(string:"https://api.eveonline.com/")
    
    public func GetCharacters(key: UInt64, vcode: String) -> FailableOf<EveResponse<EveCharacter>> {
        var funcurl = "/account/Characters.xml.aspx?keyID=\(key)&vCode=\(vcode)"
        
        
        var url = NSURL(string: funcurl, relativeToURL:baseurl)
        
        let session = NSURLSession.sharedSession()

        let request = NSMutableURLRequest(URL: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        
        var rs: FailableOf<EveResponse<EveCharacter>>?
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response:NSURLResponse!,
            error: NSError!) -> Void in
            
            if let rsp = response as NSHTTPURLResponse? {
                if (rsp.statusCode == 200) {
                    var t = EveResponse<EveCharacter>()
                    var data = NSString(data: data, encoding: NSUTF8StringEncoding)!
                    var result = t.Parse(data as String)
                    if !result.failed {
                        rs = FailableOf<EveResponse<EveCharacter>>(t)
                    }
                    else {
                        rs = FailableOf<EveResponse<EveCharacter>>(result.error!)
                    }
                }
                else {
                    var err = Error(code: rsp.statusCode, domain: "EveApi::GetCharacters", userInfo: ["Description":"Invalid return code \(rsp.statusCode)"])
                    rs = FailableOf<EveResponse<EveCharacter>>(err)
                }
            }
            else {
                var err = Error(code: error.code, domain: "EveApi::GetCharacters", userInfo: ["Description":error.description])
                rs = FailableOf<EveResponse<EveCharacter>>(err)
            }
            
        })
        
        dataTask.resume()
        while(dataTask.state == NSURLSessionTaskState.Running) {
            sleep(2)
        }
        
        return rs!
    }
    
    public func CheckKey(key: UInt64, vcode: String) -> FailableOf<Bool> {
        var result = GetCharacters(key, vcode: vcode)
        if !result.failed {
            return FailableOf<Bool>(true)
        }
        return FailableOf<Bool>(result.error!)
    }
    
}

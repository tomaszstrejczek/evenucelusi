// Playground - noun: a place where people can play

import UIKit
import XCPlayground
import client


XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)


var key=4107075
var vcode="R27d16Sq1v1yrO8ViWBGdhS8uFftxiUONcPMH8m9vzbaxy6NoOGIwsMpuk0Vra2N"

var baseurl=NSURL(string:"https://api.eveonline.com/")
var funcurl = "/account/Characters.xml.aspx?keyID=\(key)&vCode=\(vcode)"


var url = NSURL(string: funcurl, relativeToURL:baseurl)

let session = NSURLSession.sharedSession()

print("test")

let request = NSMutableURLRequest(URL: url!)
request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
request.HTTPMethod = "POST"

let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response:NSURLResponse!,
    error: NSError!) -> Void in
    
    print("called")
    if let rsp = response as NSHTTPURLResponse? {
        if (rsp.statusCode == 200) {
            print("req ok")
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
    }
    else {
        print("Invalid request: \(error)")
    }
    
    print(response)
})

//dataTask.resume()


var data = "<?xml version='1.0' encoding='UTF-8'?>\r\n<eveapi version=\"2\">\r\n  <currentTime>2015-02-28 21:02:51</currentTime>\r\n  <result>\r\n    <rowset name=\"characters\" key=\"characterID\" columns=\"name,characterID,corporationName,corporationID,allianceID,allianceName,factionID,factionName\">\r\n      <row name=\"a99990 Pappotte\" characterID=\"93860977\" corporationName=\"My Random Corporation\" corporationID=\"98325162\" allianceID=\"0\" allianceName=\"\" factionID=\"0\" factionName=\"\" />\r\n      <row name=\"Justine Mati\" characterID=\"95304127\" corporationName=\"My Random Corporation\" corporationID=\"98325162\" allianceID=\"0\" allianceName=\"\" factionID=\"0\" factionName=\"\" />\r\n      <row name=\"stryju\" characterID=\"1681153044\" corporationName=\"Brave Newbies Inc.\" corporationID=\"98169165\" allianceID=\"99003214\" allianceName=\"Brave Collective\" factionID=\"0\" factionName=\"\" />\r\n    </rowset>\r\n  </result>\r\n  <cachedUntil>2015-02-28 21:13:00</cachedUntil>\r\n</eveapi>"

var t = EveResponse<EveCharacter>()
t.Parse(data)
println(t.currentTime)
t.cachedUntil
t.rows.count
t.rows


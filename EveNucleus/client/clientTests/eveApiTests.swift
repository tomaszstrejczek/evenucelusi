//
//  eveApiTests.swift
//  client
//
//  Created by Tomasz Strejczek on 01/03/15.
//  Copyright (c) 2015 EveNucleus. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class eveApiTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testEveCharacterParsing() {
        var data = "<?xml version='1.0' encoding='UTF-8'?>\r\n<eveapi version=\"2\">\r\n  <currentTime>2015-02-28 21:02:51</currentTime>\r\n  <result>\r\n    <rowset name=\"characters\" key=\"characterID\" columns=\"name,characterID,corporationName,corporationID,allianceID,allianceName,factionID,factionName\">\r\n      <row name=\"a99990 Pappotte\" characterID=\"93860977\" corporationName=\"My Random Corporation\" corporationID=\"98325162\" allianceID=\"0\" allianceName=\"\" factionID=\"0\" factionName=\"\" />\r\n      <row name=\"Justine Mati\" characterID=\"95304127\" corporationName=\"My Random Corporation\" corporationID=\"98325162\" allianceID=\"0\" allianceName=\"\" factionID=\"0\" factionName=\"\" />\r\n      <row name=\"stryju\" characterID=\"1681153044\" corporationName=\"Brave Newbies Inc.\" corporationID=\"98169165\" allianceID=\"99003214\" allianceName=\"Brave Collective\" factionID=\"0\" factionName=\"\" />\r\n    </rowset>\r\n  </result>\r\n  <cachedUntil>2015-02-28 21:13:00</cachedUntil>\r\n</eveapi>"
        
        var t = EveResponse<EveCharacter>()
        var err = t.Parse(data)
        
        XCTAssert(!err.failed)
        
        var cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        XCTAssertEqual(2015, cal!.component(NSCalendarUnit.CalendarUnitYear, fromDate: t.cachedUntil))
        XCTAssertEqual(2, cal!.component(NSCalendarUnit.CalendarUnitMonth, fromDate: t.cachedUntil))
        XCTAssertEqual(28, cal!.component(NSCalendarUnit.CalendarUnitDay, fromDate: t.cachedUntil))
        XCTAssertEqual(21, cal!.component(NSCalendarUnit.CalendarUnitHour, fromDate: t.cachedUntil))
        XCTAssertEqual(13, cal!.component(NSCalendarUnit.CalendarUnitMinute, fromDate: t.cachedUntil))
        XCTAssertEqual(0, cal!.component(NSCalendarUnit.CalendarUnitSecond, fromDate: t.cachedUntil))

        XCTAssertEqual(2015, cal!.component(NSCalendarUnit.CalendarUnitYear, fromDate: t.currentTime))
        XCTAssertEqual(2, cal!.component(NSCalendarUnit.CalendarUnitMonth, fromDate: t.currentTime))
        XCTAssertEqual(28, cal!.component(NSCalendarUnit.CalendarUnitDay, fromDate: t.currentTime))
        XCTAssertEqual(21, cal!.component(NSCalendarUnit.CalendarUnitHour, fromDate: t.currentTime))
        XCTAssertEqual(2, cal!.component(NSCalendarUnit.CalendarUnitMinute, fromDate: t.currentTime))
        XCTAssertEqual(51, cal!.component(NSCalendarUnit.CalendarUnitSecond, fromDate: t.currentTime))
        
        XCTAssertEqual(3, t.rows.count)
        
        var dict = Utils.toDictionary(t.rows) { ($0.name, $0) }
        XCTAssertNotNil(dict["a99990 Pappotte"])
        var s = dict["a99990 Pappotte"]!
        XCTAssertEqual(UInt64(93860977), s.characterID)
        XCTAssertEqual("My Random Corporation", s.corporationName)
        XCTAssertEqual(UInt64(98325162), s.corporationID)
        XCTAssertEqual("", s.allianceName)
        XCTAssertEqual(UInt64(0), s.allianceID)
        XCTAssertEqual(UInt64(0), s.factionID)
        XCTAssertEqual("", s.factionName)
        
        XCTAssertNotNil(dict["stryju"])
        s = dict["stryju"]!
        XCTAssertEqual(UInt64(1681153044), s.characterID)
        XCTAssertEqual("Brave Newbies Inc.", s.corporationName)
        XCTAssertEqual(UInt64(98169165), s.corporationID)
        XCTAssertEqual("Brave Collective", s.allianceName)
        XCTAssertEqual(UInt64(99003214), s.allianceID)
        XCTAssertEqual(UInt64(0), s.factionID)
        XCTAssertEqual("", s.factionName)
        
        
        XCTAssertNotNil(dict["Justine Mati"])
        s = dict["Justine Mati"]!
        XCTAssertEqual(UInt64(95304127), s.characterID)
        XCTAssertEqual("My Random Corporation", s.corporationName)
        XCTAssertEqual(UInt64(98325162), s.corporationID)
        XCTAssertEqual(UInt64(0), s.allianceID)
        XCTAssertEqual("", s.allianceName)
        XCTAssertEqual(UInt64(0), s.factionID)
        XCTAssertEqual("", s.factionName)

        XCTAssertNil(dict["test"])
    }
    
    func testEveCharacterWithError() {
        var data = "<?xml version='1.0' encoding='UTF-8'?>\r\n<eveapi version=\"2\">)"
        
        var t = EveResponse<EveCharacter>()
        var err = t.Parse(data)
        
        XCTAssert(err.failed)
        var line = err.error!.userInfo["Line"] as Int
        XCTAssertEqual(Int(2), line)
    }
    
    func testGetCharacters() {
        var key=UInt64(4107075)
        var vcode="R27d16Sq1v1yrO8ViWBGdhS8uFftxiUONcPMH8m9vzbaxy6NoOGIwsMpuk0Vra2N"
        var api = EveApi()

        var t = api.GetCharacters(key, vcode: vcode)
        XCTAssert(!t.failed)
        
        XCTAssertEqual(3, t.value!.rows.count)
        
        var dict = Utils.toDictionary(t.value!.rows) { ($0.name, $0) }
        XCTAssertNotNil(dict["a99990 Pappotte"])
        var s = dict["a99990 Pappotte"]!
        XCTAssertEqual(UInt64(93860977), s.characterID)
        XCTAssertEqual("My Random Corporation", s.corporationName)
        XCTAssertEqual(UInt64(98325162), s.corporationID)
        XCTAssertEqual("", s.allianceName)
        XCTAssertEqual(UInt64(0), s.allianceID)
        XCTAssertEqual(UInt64(0), s.factionID)
        XCTAssertEqual("", s.factionName)
        
        XCTAssertNotNil(dict["stryju"])
        s = dict["stryju"]!
        XCTAssertEqual(UInt64(1681153044), s.characterID)
        XCTAssertEqual("Brave Newbies Inc.", s.corporationName)
        XCTAssertEqual(UInt64(98169165), s.corporationID)
        XCTAssertEqual("Brave Collective", s.allianceName)
        XCTAssertEqual(UInt64(99003214), s.allianceID)
        XCTAssertEqual(UInt64(0), s.factionID)
        XCTAssertEqual("", s.factionName)
        
        
        XCTAssertNotNil(dict["Justine Mati"])
        s = dict["Justine Mati"]!
        XCTAssertEqual(UInt64(95304127), s.characterID)
        XCTAssertEqual("My Random Corporation", s.corporationName)
        XCTAssertEqual(UInt64(98325162), s.corporationID)
        XCTAssertEqual(UInt64(0), s.allianceID)
        XCTAssertEqual("", s.allianceName)
        XCTAssertEqual(UInt64(0), s.factionID)
        XCTAssertEqual("", s.factionName)
    }
    
}

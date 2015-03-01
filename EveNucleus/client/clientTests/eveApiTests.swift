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
        t.Parse(data)
        
        var cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        
        XCTAssert(2 == cal!.component(NSCalendarUnit.CalendarUnitMonth, fromDate: t.cachedUntil))
        
    }
}

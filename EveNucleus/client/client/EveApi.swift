//
//  EveApi.swift
//  client
//
//  Created by Tomasz Strejczek on 01/03/15.
//  Copyright (c) 2015 EveNucleus. All rights reserved.
//

import Foundation


public class EveCharacter: NSObject {
    var name: NSString
    var characterID: UInt64
    var corporationName: NSString
    var corporationID: UInt64
    var allianceID: UInt64
    var allianceName: NSString
    var factionID: UInt64
    var factionName: NSString
    
    override init() {
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

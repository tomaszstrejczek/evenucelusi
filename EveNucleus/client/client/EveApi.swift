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

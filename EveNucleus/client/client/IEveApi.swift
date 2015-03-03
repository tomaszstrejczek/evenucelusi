//
//  IEveApi.swift
//  client
//
//  Created by Tomasz Strejczek on 01/03/15.
//  Copyright (c) 2015 EveNucleus. All rights reserved.
//

import Foundation

public protocol IEveApi {
    func GetCharacters(key: UInt64, vcode: String) -> FailableOf<EveResponse<EveCharacter>>
    func CheckKey(key: UInt64, vcode: String) -> FailableOf<Bool>
}


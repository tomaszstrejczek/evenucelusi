//
//  IEveApi.swift
//  EveNucleus
//
//  Created by Tomasz Strejczek on 28/02/15.
//  Copyright (c) 2015 EveNucleus. All rights reserved.
//

import Foundation

protocol IEveApi {
    func CheckKey(key: UInt64, vcode: String) -> Bool
}


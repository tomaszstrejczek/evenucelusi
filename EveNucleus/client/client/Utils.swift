//
//  Utils.swift
//  client
//
//  Created by Tomasz Strejczek on 01/03/15.
//  Copyright (c) 2015 EveNucleus. All rights reserved.
//

import Foundation

public struct Utils {
    public static func toDictionary<E, K, V>(
        array:       [E],
        transformer: (element: E) -> (key: K, value: V)?)
        -> Dictionary<K, V>
    {
        return array.reduce([:]) {
            (var dict, e) in
            if let (key, value) = transformer(element: e)
            {
                dict[key] = value
            }
            return dict
        }
    }

}
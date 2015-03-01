//
//  Extensions.swift
//  client
//
//  Created by Tomasz Strejczek on 01/03/15.
//  Copyright (c) 2015 EveNucleus. All rights reserved.
//

import Foundation

extension String {
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        
        return stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
}

extension NSObject {
    subscript(key: String) -> NSObject? {
        get {
            return self.valueForKeyPath(key) as? NSObject
        }
        set(newValue) {
            self.setValue(newValue, forKeyPath: key)
        }
    }
    func keyPathsForValuesAffectingValueForKey(key: String!) -> NSSet! {
        return nil
    }
    func automaticallyNotifiesObserversForKey(key: String!) -> Bool {
        return true
    }
    func addObserver(observer: NSObject!, forKeyPath keyPath: String!) {
        self.addObserver(observer, forKeyPath: keyPath, options: nil, context: nil)
    }
}

//
//  File.swift
//  client
//
//  Created by Tomasz Strejczek on 01/03/15.
//  Copyright (c) 2015 EveNucleus. All rights reserved.
//

import Foundation

/**
* Creates a new type that is used to represent error information in Swift.
*
* This is a new Swift-specific error type used to return error information. The primary usage of this object is to
* return it as a `Failable` or `FailableOf<T>` from function that could fail.
*
* Example:
*    `func readContentsOfFileAtPath(path: String) -> Failable<String>`
*/
public struct Error {
    public typealias ErrorInfoDictionary = Dictionary<String, Any>
    
    /// The error code used to differentiate between various error states.
    public let code: Int
    
    /// A string that is used to group errors into related error buckets.
    public let domain: String
    
    /// A place to store any custom information that needs to be passed along with the error instance.
    public let userInfo: ErrorInfoDictionary
    
    /// Initializes a new `Error` instance.
    public init(code: Int, domain: String, userInfo: ErrorInfoDictionary?) {
        self.code = code
        self.domain = domain
        if let info = userInfo {
            self.userInfo = info
        }
        else {
            self.userInfo = [String:Any]()
        }
    }
}

/**
* A `Failable` should be returned from functions that need to return success or failure information but has no other
* meaning information to return. Functions that need to also return a value on success should use `FailableOf<T>`.
*/
public enum Failable {
    case Success
    case Failure(Error)
    
    init() {
        self = .Success
    }
    
    init(_ error: Error) {
        self = .Failure(error)
    }
    
    public var failed: Bool {
        switch self {
        case .Failure(let error):
            return true
            
        default:
            return false
        }
    }
    
    public var error: Error? {
        switch self {
        case .Failure(let error):
            return error
            
        default:
            return nil
        }
    }
}

/**
* A `FailableOf<T>` should be returned from functions that need to return success or failure information and some
* corresponding data back upon a successful function call.
*/
public enum FailableOf<T> {
    case Success(FailableValueWrapper<T>)
    case Failure(Error)
    
    public init(_ value: T) {
        self = .Success(FailableValueWrapper(value))
    }
    
    public init(_ error: Error) {
        self = .Failure(error)
    }
    
    public var failed: Bool {
        switch self {
        case .Failure(let error):
            return true
            
        default:
            return false
        }
    }
    
    public var error: Error? {
        switch self {
        case .Failure(let error):
            return error
            
        default:
            return nil
        }
    }
    
    public var value: T? {
        switch self {
        case .Success(let wrapper):
            return wrapper.value
            
        default:
            return nil
        }
    }
}

/// This is a workaround-wrapper class for a bug in the Swift compiler. DO NOT USE THIS CLASS!!
public class FailableValueWrapper<T> {
    public let value: T
    public init(_ value: T) { self.value = value }
}



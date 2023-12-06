//
//  Observable.swift
//  PrestoDriver
//
//  Created by Alex Nagy on 02/09/2021.
//

import Foundation

/// Observable class
///```
///Act as an observer of the value of given type. 
///```
class Observable<T> {
    var value: T? {
        didSet {
            listner?(value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listner: ((T?)->())?
    
    func bind(_ listner: @escaping (T?)->()){
        listner(value)
        self.listner = listner
    }
}

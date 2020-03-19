//
//  Preference.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 5/25/19.
//

import Foundation

open class PreferenceStore {
    
    public func fetch <T:Codable> (_ key:String, defaultValue:T? = nil) -> T? {
        
        guard let storedValue = UserDefaults.standard.value(forKey: key)  else {return defaultValue}
        return storedValue as? T
    }
    
    
    public func fetch <T:Codable> (_ key:String, type: T.Type,  defaultValue:T? = nil) -> T? {
        
        guard let storedValue = UserDefaults.standard.value(forKey: key)  else {return defaultValue}
        let data = storedValue as? Data
        return data?.transform(type: type) as? T
    }
    
    public func save <T:Codable> (key:String, value:T?) {
    
        switch value {
        
        
        case (let safeValue) where isSavable(value: safeValue) :
            UserDefaults.standard.set(safeValue, forKey: key)
        
        case .some(let safeValue):
            do {
                let safeEncodedValue = try JSONEncoder().encode(safeValue)
                UserDefaults.standard.set(safeEncodedValue, forKey: key)
            } catch (_){}
        
        case .none:
            UserDefaults.standard.removeObject(forKey: key)
            
        }
    }
    
    func isSavable (value:Any?) -> Bool {
      
        return (value is String ||
                value is Bool ||
                value is Int ||
                value is Double ||
                value is Date ||
                value is Data)
    }
    
    public func clean (_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

public extension PreferenceStore {
   public subscript <T:Codable> (key:String) -> T? {
        get {
            let value:T? = fetch(key)
            return value
        }
        set (newValue) {
            save(key: key, value: newValue)
        }
    }
}

open class SessionStore {
    
    public typealias T = Any
    
    private static var data:[String:T] = [:]
    
    static func storedData() -> [String:T] {
        return data
    }
    public func fetch (_ key:String, defaultValue:T? = nil) -> T? {
        return SessionStore.data[key] ?? defaultValue
    }
    
    public func save (key:String, value:T?) {
        SessionStore.data[key] = value
    }
    
}

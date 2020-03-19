//
//  Transforming.swift
//  ABCoreComponent
//
//  Created by Ganesh Reddiar on 5/24/19.
//

import Foundation

public protocol DataTransforming {
    
    func transform <T:Codable> (type: T.Type)  -> T?
}

extension Data: DataTransforming  {
    
    public func transform <T:Codable> (type: T.Type)  -> T? {
        do {
           let decodedOutput = try  JSONDecoder().decode(type, from: self)
            return decodedOutput
        } catch (_) {
            return nil
        }
    }
    
    
}

public protocol CodableTransform { }

public extension CodableTransform where Self: Encodable {
    
    func transformToData () -> Data? {
        do {
            let data = try JSONEncoder().encode(self)
            return data
        } catch (_) {
        }
        return nil
    }
}

public extension CodableTransform where Self: Decodable {
    func transformFromData (_ data:Data?) -> Self? {
        
        guard let safeData = data else {return nil}
        do {
            let decodedOutput = try JSONDecoder().decode(Self.self, from:safeData)
            return decodedOutput
        } catch (_) {
            return nil
        }
    }
}

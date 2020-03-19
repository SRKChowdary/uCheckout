//
//  JSONFileReader.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 5/25/19.
//

import Foundation

open class JSONFileReader {
    public init() {}
    
    public func read(file path: String?) -> Data? {
        guard let safePath = path else {return nil}
        do {
            let fileURL = URL(fileURLWithPath: safePath)
            let fileData = try Data (contentsOf: fileURL, options: .mappedIfSafe)
            return fileData
            
        } catch (let error) {
            return nil
        }
    }
    
    public func fetch<T:Codable> (file path:String?, type:T.Type) -> T? {
        let transformedData:T? = read(file: path)?.transform(type: type)
        return transformedData
    }
}



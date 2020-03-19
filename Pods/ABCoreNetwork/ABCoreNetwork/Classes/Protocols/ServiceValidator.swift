//
//  ServiceValidator.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/9/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation

public typealias Validator<T> = (T) -> (Result<T>)


protocol ServiceValidator {
    
    func serviceValidatorURLResponse () ->  Validator<URLResponse>
    func serviceValidatorData<T> () ->  Validator<T>
    
}

extension ServiceValidator {
    
    func serviceValidatorURLResponse () ->  Validator<URLResponse> {
        
        let closure:Validator<URLResponse> = {value in
            
            let code = ((value as? HTTPURLResponse)?.statusCode ?? -1)
            guard code <= 201 else {return Result.failure(ServiceError.networkError(code))}
            return Result.success(value)
        }
        return closure
    }
    
    func serviceValidatorData<T> () ->  Validator<T> {
        return { value in
            return Result.success(value)
        }
    }

    
}


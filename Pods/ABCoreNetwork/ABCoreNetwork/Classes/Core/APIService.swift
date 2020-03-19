//
//  APIService.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/9/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation
import ABCoreComponent

open class APIService <T:Codable> {
    
    //Informational Properties
    public private(set) var nameType: String?
    var progress = APIServiceStatus.ready

    //Request properties
    var method = APIMethod.GET
    var request: URLRequest?
    var session = APISessionDefault.shared

    var responseHandler: ResponseHandler = {(_, _, _ ) in return}
    
    //Validation
    var httpResponseValidator :Validator<URLResponse>?
    var outputValidator :Validator<T>?
    
    //Delegate
    var observable : APIObservable?
    var authenticationSession: AuthenticationSession?
    public init (named: String? ) {
        self.nameType = named
        configure()
    }
    
    public init (request: URLRequest?) {
        self.request = request
        configure()
    }
    
    func configure () {
        httpResponseValidator = serviceValidatorURLResponse()
        outputValidator = serviceValidatorData()
    }
    
    @discardableResult
    open func add (request: URLRequest?) -> APIService {
        self.request = request
        return self

    }
   
    @discardableResult
    open func addRequest (headers: [String:String]) -> APIService {
        headers.forEach {
            self.request?.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        return self
    }
    
    @discardableResult
    open func named(_ name:String) -> APIService {
        self.nameType = name
        return self
    }
    
    @discardableResult
    open func inSession(_ session:URLSession) -> APIService {
        self.session = session
        return self
    }
    
   
    @discardableResult
    open func add(method:APIMethod) -> APIService  {
        self.method = method
        self.request?.httpMethod = method.rawValue
        return self
    }
    
    @discardableResult
    open func add(method:APIMethod, data:Encodable?) -> APIService  {
        self.add(method: method)
        self.add(data: data)
        return self
    }
    
    @discardableResult
    open func add(data:Encodable?) -> APIService  {
        guard let encodedData  = try? Post().toData(data) else {return self}
        request?.httpBody = encodedData
        return self
    }
    
   
    
    @discardableResult
    open func authorize (session:AuthenticationSession?) -> APIService {
        self.authenticationSession = session
        return self
    }
    
    @discardableResult
    open func then (validateURLResponse: @escaping Validator<URLResponse>) -> APIService  {
        self.httpResponseValidator = validateURLResponse
        return self
    }
   

    @discardableResult
    open func then (validateResponse: @escaping Validator<T>) -> APIService  {
        self.outputValidator = validateResponse
        return self
    }
    
    func decode (data:Data) -> Result<T> {
        do {
            let output = try JSONDecoder().decode(T.self, from: data)
            return Result.success(output)
            
        } catch (let error) {
            return Result.failure(error)
        }
    }
    
    @discardableResult
    open func then(finished:@escaping ResultBlock<T>) -> APIService {
        self.responseHandler = remoteServiceHandler (finished: finished)
        return self
        
    }
        
    open func start ()  {
        
        progress = .running
        if let authenticationSession = authenticationSession {
            authenticationSession.requestAuthorization {
                authenticationSession.authorized (service:self)
                self.resume()
            }
            return
        }
        resume()
    }
    
    private func resume  () {
        if let request = self.request {
            self.session.dataTask(with: request, completionHandler: self.responseHandler).resume()
        }
    }
    
    open func hasValid(data: Data?, response: URLResponse?) -> Result<T>? {
        
        guard let safeData = data else { return nil}
        var finalResult = decode(data: safeData)
        
        finalResult.handle (success:{value in
            
            if let validatedResult = self.outputValidator?(value),
                let error = validatedResult.outFailure() {
                finalResult = Result.failure(error)
            }
            
        }, failed:{ _ in
            //already handled
        })
        return finalResult
    }
    
  
}

// MARK: RequestHandler
extension APIService {
    
    typealias RemoteAPICompletetionBlk = ((Data?, URLResponse?, Error?) -> Void)
    
    func remoteServiceHandler (finished:@escaping ResultBlock<T>)  -> RemoteAPICompletetionBlk  {
        
        let block: RemoteAPICompletetionBlk = { (data, response, error) in
            
            var success = true
            var finalResult = Result<T>.failure(ServiceError.invalidJSON)
            
            if let errorResult = self.has(error: error) {
                success = false
                finalResult = errorResult
            }
            else if let validDecodedResult = self.hasValid(data: data, response: response) {
                finalResult = validDecodedResult
            }
            
            else if let validResponseResult = self.hasValid(response: response) {
                finalResult =  validResponseResult
            }
           
            self.progress = .finished
            finished(finalResult)
            self.observable?.emit(service: self, result: finalResult)

        }
        
        return block
    }
    
    func has(error:Error?) -> Result<T>? {
        guard let safeError = error else {return nil}
        return Result.failure(safeError)
    }
    
    func hasValid (response: URLResponse?) -> Result<T>? {
        
        guard
            let safeResponse = response,
            let safeURLResponse = safeResponse as? HTTPURLResponse,
            safeURLResponse.statusCode > 201
        else {return nil}
        
        let networkError = ServiceError.networkError(safeURLResponse.statusCode)
        return Result.failure(networkError)
    }
    
    open func isStale (cache time:TimeInterval) -> Bool {
        let name = self.nameType ?? self.request?.url?.absoluteString
        guard
            let safeName = name,
            let savedDate:Date = Store.preference [safeName]
            else {return true}
            let timePassed = Date().timeIntervalSince(savedDate)
            return timePassed > time
    }
    
    open func saveLastUpdated(date: Date) {
        if let safeName = self.nameType {
            Store.preference [safeName] = date
        }
    }
}

extension APIService:Equatable {
    
    public static func == (lhs: APIService, rhs: APIService) -> Bool {
        
        if let lhsName = lhs.nameType, let rhsName = rhs.nameType {
            return lhsName == rhsName
        }
        
        guard let lhsURL = lhs.request?.url?.absoluteString ,
            let rhsURL = rhs.request?.url?.absoluteString else {
                return false
        }
        return lhsURL == rhsURL
    }
}


extension APIService:ServiceValidator {}



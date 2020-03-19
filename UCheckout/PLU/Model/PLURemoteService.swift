//
//  PLURemoteService.swift
//  UCheckout
//
//  Created by i2i innovation on 26/08/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import ABCoreNetwork
import ABAuthenticator
import ABCoreComponent





struct PLUModelRequest: Codable, CodableTransform {
    var upcType: String!
    var barcode: String!
    
    
}





class PLURemoteService {
    //"https://retail-api.azure-api.net/scanandgodevjs/itemlookup?upc_type=\(upcType)&scan_code=\(barcode)&storeid=9718"
    
    //var config: CheckoutConfiguration? -> Later to be added
    
    lazy var api =  APIService <ItemLookUpModel>(
        named: "API-URL") // to be added
    
    
    func run (coa input: PLUModelRequest?, completed: @escaping ResultBlock<ItemLookUpModel>) {
        
        guard let safeInput = input else {return}
        buildAPI (input: safeInput)
        
        api.then(finished: completed)
        api.start()
    }
    
    func buildDataValidator () -> Validator<ItemLookUpModel> {
        
        let dataValidator: Validator<ItemLookUpModel> = {
            (itemLookUpModel) -> (Result<ItemLookUpModel>) in
            //parsing of data to be done after result
            
            if let ack = itemLookUpModel.ack {
                 if ack == "0" {
                     return Result.success(itemLookUpModel)
                  }
                 else{
                     return Result.success(itemLookUpModel)
                }
            }
            else {
                // have to change to Failure
                return Result.success( itemLookUpModel )
            }
            
           
 
            
           
        }
        
        return dataValidator
    }
    
    
    
    func buildAPI (input: PLUModelRequest) {
        
        api = APIService <ItemLookUpModel>(
            named:"ItemLookUp")
        api.inSession(APISessionDefault.shared)
        api.add(request: buildRequest(upcType: input.upcType, barcode: input.barcode))
        var headers: [String:String] = ["Content-Type":"application/json"]
        headers["Ocp-Apim-Subscription-Key"] = ConfigurationManager.manager.ocpSubscriptionkey
        
        api.addRequest(headers: headers)
        api.add(method: .GET)
        api.then(validateResponse: buildDataValidator())
        
    }
    
    func buildRequest (upcType : String  , barcode : String   ) -> URLRequest? {
        
        var request  = ABRequest (
            host: "retail-api.azure-api.net",// to be added
            path: "/scanandgodevjs/itemlookup?upc_type=\(upcType)&scan_code=\(barcode)&storeid=9718"
            ).make()
        request?.acceptJSON()
        return request
    }
    
}

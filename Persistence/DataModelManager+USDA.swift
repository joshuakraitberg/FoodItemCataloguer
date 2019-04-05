//
//  DataModelManager+NdbSearchPackage.swift
//  Assign4
//
//  Created by josh on 2018-11-28.
//  Copyright © 2018 SICT. All rights reserved.
//


import CoreData

extension DataModelManager {
    
    // Fetch one, by its unique object identifier
    func ndbSearchPackage_GetByName(_ name: String!) -> String! {
        
        // Create a request object (and configure it if necessary)
        let request = UsdaApiRequest()

         let key = "UsdaApiIsReady_\(name!)"
        
        // Send the request, and write a completion method to pass to the request
        request.sendRequest(toUrlPath: "&max=25&q=\(name!)", completion: {
            
            (result: NdbSearchPackage) in
            
            // Save the result in the manager property
            self.ndbSearchPackage = result
            
            // Post a notification
            NotificationCenter.default.post(name: Notification.Name(key), object: nil)
        })
        
        return key
    }
    
}

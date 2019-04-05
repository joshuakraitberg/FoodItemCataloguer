//
//  UsdaApiRequest.swift
//  Assign4
//
//  Created by josh on 2018-11-28.
//  Copyright © 2018 SICT. All rights reserved.
//

import Foundation


class UsdaApiRequest: WebApiRequest {
    
    static let HOST_URL = "https://api.nal.usda.gov"
    static let API_KEY = "udmy8U3UQ8dG1nYTDiYx9pdIdUFKlOWSnQr3EZlE"
    static let BASE_URL = "\(HOST_URL)/ndb/search/?api_key=\(API_KEY)"
    
    convenience init() {
        self.init(UsdaApiRequest.BASE_URL)
    }

}

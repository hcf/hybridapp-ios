//
//  ShareScriptMessage.swift
//  Fagdag
//
//  Created by Hans-Chr Fjeldberg on 27/08/15.
//  Copyright (c) 2015 BEKK. All rights reserved.
//

import Foundation

class ShareScriptMessage {
    
    let serviceType: String
    let object: NSDictionary?
    
    init(serviceType: String, object: NSDictionary) {
        self.serviceType = serviceType
        self.object = object
    }
    
}

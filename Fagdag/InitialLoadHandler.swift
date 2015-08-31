//
//  InitialLoadHandler.swift
//  Fagdag
//
//  Created by Hans-Chr Fjeldberg on 31/08/15.
//  Copyright (c) 2015 BEKK. All rights reserved.
//

import Foundation
import WebKit

class InitialLoadMessageHandler : NSObject, WKScriptMessageHandler {
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        println("Received initial load message from webview: \(message)")
        
        if let object = message.body as? NSDictionary {
            
            NSNotificationCenter.defaultCenter().postNotificationName("initialLoad", object: object)
            
        }
        
    }
    
}

//
//  FacebookScriptMessageHandler.swift
//  Fagdag
//
//  Created by Hans-Chr Fjeldberg on 20/08/15.
//  Copyright (c) 2015 BEKK. All rights reserved.
//

import Foundation
import WebKit
import Social

class FacebookScriptMessageHandler : NSObject, WKScriptMessageHandler {
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        println("Received message from webview: \(message)")
        
        if let object = message.body as? NSDictionary {
            
            let shareMessage = ShareScriptMessage(serviceType: SLServiceTypeFacebook, object: object)
            
            NSNotificationCenter.defaultCenter().postNotificationName("share", object: shareMessage)
            
        }

    }

}
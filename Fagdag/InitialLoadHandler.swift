import Foundation
import WebKit

class InitialLoadMessageHandler : NSObject, WKScriptMessageHandler {
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        
        if let object = message.body as? NSDictionary {
            NSNotificationCenter.defaultCenter().postNotificationName("initialLoad", object: object)
        }
    }
    
}

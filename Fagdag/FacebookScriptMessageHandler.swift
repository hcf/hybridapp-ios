import Foundation
import WebKit
import Social

class FacebookScriptMessageHandler : NSObject, WKScriptMessageHandler {
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let object = message.body as? NSDictionary {
            
            let shareMessage = ShareScriptMessage(serviceType: SLServiceTypeFacebook, object: object)
            
            NSNotificationCenter.defaultCenter().postNotificationName("share", object: shareMessage)
        }
    }

}

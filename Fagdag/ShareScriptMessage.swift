import Foundation

class ShareScriptMessage {
    
    let serviceType: String
    let object: NSDictionary?
    
    init(serviceType: String, object: NSDictionary) {
        self.serviceType = serviceType
        self.object = object
    }
    
}

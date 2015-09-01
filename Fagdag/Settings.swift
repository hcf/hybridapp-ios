import Foundation

class Settings {
    
    static func rootUrl() -> NSURL? {
        return sharedInstance.rootUrl()
    }
    
    private static let sharedInstance = Settings()
    
    private let config: NSDictionary?;
    
    private init() {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")!
        config = NSDictionary(contentsOfFile: path)
    }
    
    private func rootUrl() -> NSURL? {
        if let c = config {
            if let urlString = c["RootUrl"] as? String {
                return NSURL(string: urlString)
            }
        }
        return nil
    }
    
}
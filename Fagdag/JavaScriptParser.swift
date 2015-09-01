import Foundation

class JavaScriptParser {
    
    static func parse(filename: String) -> String? {
    
        let fileExtension = filename.pathExtension
        let name = filename.stringByDeletingPathExtension
        
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource(name, ofType: fileExtension)
        
        var error: NSError?;
                
        if let source = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: &error) {            
            return source
        } else {
            println("Could not load javascript file \(filename).js: \(error)")
            return nil
        }
    }
    
}

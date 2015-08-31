//
//  JavaScriptParser.swift
//  Fagdag
//
//  Created by Hans-Chr Fjeldberg on 18/08/15.
//  Copyright (c) 2015 BEKK. All rights reserved.
//

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

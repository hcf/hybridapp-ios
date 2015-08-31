//
//  Settings.swift
//  Fagdag
//
//  Created by Hans-Chr Fjeldberg on 14/08/15.
//  Copyright (c) 2015 BEKK. All rights reserved.
//

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
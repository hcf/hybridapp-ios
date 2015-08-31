//
//  Navigation.swift
//  Fagdag
//
//  Created by Hans-Chr Fjeldberg on 11/08/15.
//  Copyright (c) 2015 BEKK. All rights reserved.
//

import WebKit

class Navigation: NSObject, WKNavigationDelegate {
    
    var delegate: WKProgressActionDelegate!
    
    init(delegate: WKProgressActionDelegate) {
        self.delegate = delegate
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        println("Fnis")
        
        delegate.webViewDidFinishLoading()
    }
    
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        println("What to do with \(navigationAction.request.URL), current url: \(webView.URL)");
        
        if !urlWeCanHandle(navigationAction.request.URL) {
            decisionHandler(.Cancel)
            return
        }
        
        if let currentUrl = webView.URL {
            if let newUrl = navigationAction.request.URL {
                if (newUrl != currentUrl) {
                    
                    notifyViewController(newUrl)
                    
                    decisionHandler(.Cancel)
                }
            }
        }
        
        // Unhandled, have to allow
        decisionHandler(.Allow)
    }
    
    private func urlWeCanHandle(url: NSURL?) -> Bool {
        if let actualUrl = url {
            
            if let rootUrl = Settings.rootUrl() {
                return Settings.rootUrl()?.host == actualUrl.host
            }
        }
        
        return false
    }
    
    private func notifyViewController(url: NSURL) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("navigatingToSubpage", object: url)
        
    }
    
}

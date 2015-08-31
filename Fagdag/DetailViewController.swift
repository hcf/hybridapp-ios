//
//  DetailViewController.swift
//  Fagdag
//
//  Created by Hans-Chr Fjeldberg on 26/06/15.
//  Copyright (c) 2015 BEKK. All rights reserved.
//

import UIKit
import WebKit
import Social

class DetailViewController: UIViewController, WKProgressActionDelegate {
    
    var webView: WKWebView!
    @IBOutlet weak var backButtonView: UIButton!
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    var currentPage: NSURL?
    
    var navigation: Navigation!
    var configuration: WKWebViewConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation = Navigation(delegate: self)
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        self.webView.navigationDelegate = navigation
        
        self.view.insertSubview(self.webView, belowSubview: backButtonView)
                
        if let url = currentPage {
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        addNotificationObservers()
    }
    
    override func viewDidDisappear(animated: Bool) {
        removeNotificationObservers()
    }
    
    @IBAction func pop() {
        println("Popping view controller from back button")
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Notifications
    
    private func addNotificationObservers() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "share:",
            name: "share",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "initialLoad:",
            name: "initialLoad",
            object: nil)
    }
    
    private func removeNotificationObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    dynamic private func share(notification: NSNotification) {
     
        println("Showing share sheet")
        
        if let shareMessage = notification.object as? ShareScriptMessage {
            
            if SLComposeViewController.isAvailableForServiceType(shareMessage.serviceType) {
                
                let socialController = SLComposeViewController(forServiceType: shareMessage.serviceType)
                
                socialController.completionHandler = { (result: SLComposeViewControllerResult) -> Void in
                    socialController.dismissViewControllerAnimated(true, completion: nil)
                    
                    switch(result) {
                    case SLComposeViewControllerResult.Cancelled:
                        println("Cancelled")
                    default:
                        println("Default")
                    }
                    
                }
                
                if let urlString = shareMessage.object?["url"] as? String {
                    if let url = NSURL(string: urlString) {
                        
                        println("Sharing url \(url)")
                        
                        socialController.addURL(url)
                    }
                }
                
                presentViewController(socialController, animated: true, completion: nil)

                
            } else {
                println("You do not have an \(shareMessage.serviceType) account, please configure!")
            }
            
        } else {
            println("Invalid share message, not doing anything!")
        }
    }
    
    dynamic private func initialLoad(notification: NSNotification) {
        println("Initial load, stopping progress indicator");
        
        progressIndicator.stopAnimating()
    }
    
    func webViewDidFinishLoading() {
        progressIndicator.stopAnimating()
    }
    
    
}

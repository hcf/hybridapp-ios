import UIKit
import WebKit

class IndexPageViewController: UIViewController, WKProgressActionDelegate {
    
    static var token: dispatch_once_t = 0

    var webView: WKWebView!
    
    var currentSubpage: NSURL?
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    var navigation: Navigation!
    var configuration: WKWebViewConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        
        let userContentController = WKUserContentController()
        configuration = WKWebViewConfiguration()
        navigation = Navigation(delegate: self)
        
        addUserScripts(userContentController);
        addScriptMessageHandlers(userContentController);
        
        configuration.userContentController = userContentController
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        self.webView.navigationDelegate = navigation
        
        self.view.insertSubview(self.webView, belowSubview: progressIndicator)
        
        if let url = Settings.rootUrl() {
            let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10)
            
            webView.loadRequest(request)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        addNotificationObservers()
    }
    
    override func viewDidDisappear(animated: Bool) {
        removeNotificationObservers()
    }
    
    // MARK: - User scripts
    
    private func addUserScripts(userContentController: WKUserContentController) {
        if let hideSource = JavaScriptParser.parse("hide.js") {
            let userScript = WKUserScript(source: hideSource, injectionTime: WKUserScriptInjectionTime.AtDocumentStart, forMainFrameOnly: true)
            
            userContentController.addUserScript(userScript)
        }
        
        if let sharingSource = JavaScriptParser.parse("sharing.js") {
            userContentController.addUserScript(WKUserScript(source: sharingSource, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: true))
        }
        
        if let initialLoadSource = JavaScriptParser.parse("initial-load.js") {
            userContentController.addUserScript(WKUserScript(source: initialLoadSource, injectionTime: WKUserScriptInjectionTime.AtDocumentStart, forMainFrameOnly: true))
        }
    }
    
    private func addScriptMessageHandlers(userContentController: WKUserContentController) {
        let initialLoadHandler = InitialLoadMessageHandler()
        
        userContentController.addScriptMessageHandler(initialLoadHandler, name: "initialLoad")
        
        let facebookHandler = FacebookScriptMessageHandler()
        
        userContentController.addScriptMessageHandler(facebookHandler, name: "shareUsingFacebook")
    }
    
        
    // MARK: - Button actions
    
    // MARK: - Notifications
    
    private func addNotificationObservers() {
        
        dispatch_once(&IndexPageViewController.token) {
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: "nagivatingToSubpage:",
                name: "navigatingToSubpage",
                object: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "initialLoad:",
            name: "initialLoad",
            object: nil)
    }
    
    private func removeNotificationObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "initialLoad", object: nil)
    }
    
    dynamic private func nagivatingToSubpage(notification: NSNotification) {
        
        if let url = notification.object as? NSURL {
            
            currentSubpage = url
            
            performSegueWithIdentifier("showSubpage", sender: self)
            
            return
        }
        
        println("Invalid data, not doing anything")
    }
    
    dynamic private func initialLoad(notification: NSNotification) {
        println("Initial load, stopping progress indicator");
        
        progressIndicator.stopAnimating()
    }
    
    func webViewDidFinishLoading() {
        progressIndicator.stopAnimating()
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSubpage" {
            
            if let indexPageViewController = sender as? IndexPageViewController {
                
                if let subpageViewController = segue.destinationViewController as? SubpageViewController {
                    subpageViewController.currentPage = indexPageViewController.currentSubpage
                    subpageViewController.configuration = indexPageViewController.configuration
                }
            }
            
            
        }
    }
}


import UIKit
import WebKit

class IndexPageViewController: UIViewController, WKProgressActionDelegate {

    var webView: WKWebView!
    
    var currentSubpage: NSURL?
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    var navigation: Navigation!
    var configuration: WKWebViewConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        
        addNotificationObservers();
        
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
            let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataDontLoad, timeoutInterval: 10)
            
            webView.loadRequest(request)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "nagivatingToSubpage:",
            name: "navigatingToSubpage",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "initialLoad:",
            name: "initialLoad",
            object: nil)
    }
    
    dynamic private func nagivatingToSubpage(notification: NSNotification) {
        println("Navigating to sub page from master view controller to: \(notification.object)");
        
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
                
                if let detailViewController = segue.destinationViewController as? DetailViewController {
                    detailViewController.currentPage = indexPageViewController.currentSubpage
                    detailViewController.configuration = indexPageViewController.configuration
                }
            }
            
            
        }
    }
}


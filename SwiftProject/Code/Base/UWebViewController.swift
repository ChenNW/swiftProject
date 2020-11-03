//
//  UWebViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/2.
//

import WebKit

class UWebViewController: UBaseViewController {

    var request: URLRequest!
    lazy var webView: WKWebView = {
       let wkWeb = WKWebView()
        wkWeb.allowsBackForwardNavigationGestures = true
        wkWeb.navigationDelegate = self
        wkWeb.uiDelegate = self
        return wkWeb
    }()
    
    lazy var myProgressView:UIProgressView = {
        let gressView = UIProgressView()
        gressView.trackImage = UIImage.init(named: "nav_bg")
        gressView.progressTintColor = .white
        return gressView
    }()
    
    convenience init(url: String) {
        self.init()
        self.request = URLRequest(url: URL(string: url)!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(request)
    }
    override func configUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        view.addSubview(myProgressView)
        myProgressView.snp.makeConstraints{
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        self.isShowRightItem = true
    }
    

    
    override func rightButtonClick() {
        webView.reload()
    }
    override func leftButtonClick() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
   
}

extension UWebViewController: WKNavigationDelegate,WKUIDelegate{
    
    override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            myProgressView.isHidden = webView.estimatedProgress >= 1
            myProgressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        myProgressView.setProgress(0.0, animated: false)
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
    
}

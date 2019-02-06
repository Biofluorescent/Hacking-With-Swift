//
//  ViewController.swift
//  Project31
//
//  Created by Tanner Quesenberry on 2/5/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var addressBar: UITextField!
    @IBOutlet var stackView: UIStackView!
    weak var activeWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }

    
    func setDefaultTitle(){
        title = "Multibrowser"
    }

    
    @objc func addWebView(){
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        //DO NOT USE .addSubview for for UIStackView
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    //Highlight currently selected view
    func selectWebView(_ webview: WKWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        
        activeWebView = webview
        webview.layer.borderWidth = 3
        updateUI(for: webview)
    }
    
    //Active view page title
    func updateUI(for webview: WKWebView) {
        title = webview.title
        addressBar.text = webview.url?.absoluteString ?? ""
    }
    
    //When webview changes pages
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == activeWebView {
            updateUI(for: webView)
        }
    }
    
    
    //Delegate method. User pressed return on keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Route to website if webview active
        if let webView = activeWebView, let address = addressBar.text {
            if let url = URL(string: address) {
                webView.load(URLRequest(url: url))
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    //Change stacking based on hozintal size class
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        }else {
            stackView.axis = .horizontal
        }
    }
    
    
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer){
        if let selectedWebView = recognizer.view as? WKWebView {
            selectWebView(selectedWebView)
        }
    }
    
    
    //Allows our gesture recognizers to trigger alongside built-in ones
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @objc func deleteWebView(){
        //safely unwrap
        if let webView = activeWebView {
            if let index = stackView.arrangedSubviews.index(of: webView) {
                //found current webview, remove it from stack view
                stackView.removeArrangedSubview(webView)
                
                //Also remove from view hierarchy. Important! Stops memory leak.
                webView.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0 {
                    setDefaultTitle()
                }else {
                    var currentIndex = Int(index)
                    
                    //Go back one if that was last web view in stack
                    if currentIndex == stackView.arrangedSubviews.count {
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }
                    
                    //find web view at the new index and select it
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                        selectWebView(newSelectedWebView)
                    }
                    
                }
            }
        }
        
    }
    
}


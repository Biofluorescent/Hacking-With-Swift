//
//  ActionViewController.swift
//  Extension
//
//  Created by Tanner Quesenberry on 1/15/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyBoard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
        //context controls interaction with parent app. Conditional downcast
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            // Obtain first attachment
            if let itemProvider = inputItem.attachments?.first {
                //ask provider for item. async closure. Accepts 2 params: dict from provider and errors that occured
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [unowned self] (dict, error) in
                    let itemDictionary = dict as! NSDictionary
                    let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary

                    self.pageTitle = javaScriptValues["title"] as! String
                    self.pageURL = javaScriptValues["URL"] as! String
                    
                    DispatchQueue.main.async {
                        self.title = self.pageTitle
                    }
                }
            }
        }
    
    }

    @IBAction func done() {
        //New object to host our items
        let item = NSExtensionItem()
        //Dict to hold value of our script
        let argument: NSDictionary = ["customJavaScript": script.text]
        //Put argument into another dict
        let webdictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        //Wrap big dictionary inside NSItemProvider object with a type identifier
        let customJavaScript = NSItemProvider(item: webdictionary, typeIdentifier: kUTTypePropertyList as String)
        ////Place that NSItemProvider into our NSEXtensionItem as its attachment
        item.attachments = [customJavaScript]
        
        //Call complete request, returning our NSExtensionItem
        extensionContext!.completeRequest(returningItems: [item])

    }
    
    
    @objc func adjustForKeyBoard(notification: Notification){
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = UIEdgeInsets.zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}

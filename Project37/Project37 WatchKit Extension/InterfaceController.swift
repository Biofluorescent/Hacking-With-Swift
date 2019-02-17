//
//  InterfaceController.swift
//  Project37 WatchKit Extension
//
//  Created by Tanner Quesenberry on 2/14/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var welcomText: WKInterfaceLabel!
    @IBOutlet var hideButton: WKInterfaceButton!
    
    @IBAction func hideWelcomeText() {
        welcomText.setHidden(true)
        hideButton.setHidden(true)
    }
    
    //Whenever watch receives a message from your phone it taps your wrist
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        WKInterfaceDevice().play(.click)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }

}

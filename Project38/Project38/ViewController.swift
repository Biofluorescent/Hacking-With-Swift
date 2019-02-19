//
//  ViewController.swift
//  Project38
//
//  Created by Tanner Quesenberry on 2/18/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Create container
        container = NSPersistentContainer(name: "Project38")
        //Load saved database if exists or create one
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        //Perform network request in background
        performSelector(inBackground: #selector(fetchCommits), with: nil)
    }

    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occured while saving: \(error)")
            }
        }
    }

    
    //Downloads the URL into a String object then converts to array of object using SwiftyJSON
    @objc func fetchCommits() {
        if let data = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100")!) {
            //give data to SwiftyJSON to parse
            let jsonCommits = JSON(parseJSON: data)
            
            //read the commits back out
            let jsonCommitArray = jsonCommits.arrayValue
            
            print("Received \(jsonCommitArray.count) new commits.")
            
            DispatchQueue.main.async { [unowned self] in
                for jsonCommit in jsonCommitArray {
                    //Create Commit object inside managed object context
                    let commit = Commit(context: self.container.viewContext)
                    //Configure object using JSON data
                    self.configure(commit: commit, usingJSON: jsonCommit)
                }
                
                self.saveContext()
            }
        }
    }
    
    
    //Configures Commit object from json using SwiftyJSON
    func configure(commit: Commit, usingJSON json: JSON) {
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["html_url"].stringValue
        
        let formatter = ISO8601DateFormatter()
        commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()
    }
    
    
}


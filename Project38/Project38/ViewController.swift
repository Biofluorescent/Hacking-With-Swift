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
    var commits = [Commit]()
    var commitPredicate: NSPredicate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))

        //Create container
        container = NSPersistentContainer(name: "Project38")
        //Load saved database if exists or create one
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        //Perform network request in background
        performSelector(inBackground: #selector(fetchCommits), with: nil)
        
        loadSavedData()
    }

    
    func loadSavedData() {
        let request = Commit.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = commitPredicate
        
        do {
            commits = try container.viewContext.fetch(request)
            print("Got \(commits.count) commits")
            tableView.reloadData()
        } catch {
            //Show user something useful here in production apps
            print("Fetch failed")
        }
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

    
    @objc func changeFilter() {
        let ac = UIAlertController(title: "Filter commits...", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Show only fixes", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'") //[c] means case-insensitive
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Show only recent", style: .default) { [unowned self] _ in
            let twelveHoursAgo = Date().addingTimeInterval(-43200)
            self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo as NSDate)
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Show all commits", style: .default) { [unowned self] _ in
            self.commitPredicate = nil
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
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
                self.loadSavedData()
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
    
    
    // MARK: - TableView Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
        
        let commit = commits[indexPath.row]
        cell.textLabel!.text = commit.message
        cell.detailTextLabel!.text = commit.date.description
        
        return cell
    }
}


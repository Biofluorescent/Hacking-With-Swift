//
//  ViewController.swift
//  Project33
//
//  Created by Tanner Quesenberry on 4/11/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UITableViewController {

    static var isDirty = true
    var whistles = [Whistle]()
    
    //MARK: - Loading views
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "What's that Whistle?"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Clear table view selection if there is one
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if ViewController.isDirty {
            loadWhistles()
        }
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.attributedText = makeAttributedString(title: whistles[indexPath.row].genre, subtitle: whistles[indexPath.row].comments)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.whistles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ResultsViewController()
        vc.whistle = whistles[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Tableview helper functions
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
        
        if subtitle.count > 0 {
            let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes)
            titleString.append(subtitleString)
        }
        
        return titleString
    }
    
    //MARK: - Whistles
    
    @objc func addWhistle() {
        let vc = RecordWhistleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func loadWhistles() {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Whistles", predicate: pred)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["genre", "comments"]
        operation.resultsLimit = 50
        
        var newWhistles = [Whistle]()
        
        //For every record that is downloaded
        operation.recordFetchedBlock = { record in
            let whistle = Whistle()
            whistle.recordID =  record.recordID
            whistle.genre = record["genre"]
            whistle.comments = record["comments"]
            newWhistles.append(whistle)
        }
        
        //When all records have been downloaded
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    ViewController.isDirty = false
                    self.whistles = newWhistles
                    self.tableView.reloadData()
                }else {
                    let ac = UIAlertController(title: "Fetch Failed", message: "There was a problem fetching the list of whistles; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
}


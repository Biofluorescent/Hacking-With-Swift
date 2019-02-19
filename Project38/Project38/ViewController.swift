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

}


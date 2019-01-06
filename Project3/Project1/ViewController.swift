//
//  ViewController.swift
//  Project1
//
//  Created by Tanner Quesenberry on 1/3/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
        
    }

    //MARK: - Tableview functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Try loading view controller as typecase as DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // Set image
            vc.selectedImage = pictures[indexPath.row]
            // Push onto nav controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


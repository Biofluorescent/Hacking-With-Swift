//
//  ViewController.swift
//  Project10
//
//  Created by Tanner Quesenberry on 1/9/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people.")
            }
        }
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        //Allow picture cropping
        picker.allowsEditing =  true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        
        //Unique identifier for image
        let imageName = UUID().uuidString
        //Path where image is to be saved.
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        //Convert UIImage to Data object and save it.
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        //New person object for image
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        save()
        dismiss(animated: true)
    }
    
    //Path to apps document directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    //MARK: - Collection Data Source Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Need to typecast as PersonCell to access its properties
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        
        //Set name label for person
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        //Create UIImage from filename
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        //Change look of image view borders using CALayer
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    //When a cell is tapped on.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            person.name = newName.text!
            
            self.collectionView?.reloadData()
            self.save()
        })
        
        present(ac, animated: true)
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }else {
            print("Failed to save people.")
        }
    }
}


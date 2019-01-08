//
//  ViewController.swift
//  Project5
//
//  Created by Tanner Quesenberry on 1/7/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // Find path to start.txt, load file contents, split contents into array
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt"){
            if let startWords = try? String(contentsOfFile: startWordsPath){
                allWords = startWords.components(separatedBy: "\n")
            }
        }else {
            allWords = ["silkworm"]
        }

        startGame()
    }

    //MARK: - Word check functions
    
    func isPossible(word: String) -> Bool{
        var tempWord = title!.lowercased()
        
        for letter in word {
            if let pos = tempWord.range(of: String(letter)){
                tempWord.remove(at: pos.lowerBound)
            }else {
                return false
            }
        }
        return true
    }
    
    
    func isOriginal(word: String) -> Bool{
        return !usedWords.contains(word)
    }
    
    
    func isReal(word: String) -> Bool {
        // Text checker, range to check, place of misspelling found
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        //NSNotFound means no misspelled word found
        return misspelledRange.location == NSNotFound
    }
    
    
    //MARK: - Game functions
    
    func submit(answer: String){
        let lowerAnswer = answer.lowercased()
        let errorTitle : String
        let errorMessage : String
        
        // Check user answer
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isReal(word: lowerAnswer){
                    usedWords.insert(answer, at: 0)
                    
                    // Load accepted answer to top of tableview
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                }else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up, you know!"
                }
            }else{
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        }else {
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'"
        }
        
        //Error message display is bad answer given
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // Trailing closure sytax.
        //                      declares self and ac to be captured as unowned references inside the closure.
        //                      Closure can use them but wont create a strong reference cycle
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}


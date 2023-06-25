//
//  HighScoreViewController.swift
//  Assignment2
//
//  Created by vinay bayyapunedi on 25/04/23.
//

import Foundation
import UIKit

// This struct is used to hold a name and score value so it can be stored in a secure array later

struct GameScore: Codable {
    
    var name:String
    var score:Int
    
}

let KEY_HIGH_SCORE = "highScore"

class HighScoreViewController: UIViewController {
    
    @IBOutlet weak var highScoreTable: UITableView!
    
    //An array called highScore of the type GameScore is created
    
    var highScore:[GameScore] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // This function is used to encode the data from the updatedHighScoreFromArray that is appened at the end of every game in line 283 in the GameViewController
        writeHighScores()
        
        
        // The data from the updatedHighScoreArray is decoded and stored in the highScore array of type GameScore
        self.highScore = readHighScores() // we have the decoded high scores in the form of an arrray
        
        // The highScore array is sorted and is shown in the TableView
        highScore.sort {$0.score > $1.score}
        
        
        // This is another array in the DataStore that stores the sorted scores so that it can be used to obtain the highest score. REFER TO LINE 39 IN GAMEVIEW CONTROLLER FOR CONTEXT
        DataStore.shared.sortedFinalHighScores = highScore
        
    }
    
    // This function is used an action for the "Home" button to take the user back to the home screen from the high score screen
    
    @IBAction func returnToMainPage(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }

}

func writeHighScores() {
    
    let defaults = UserDefaults.standard
    
    defaults.set(try? PropertyListEncoder().encode(DataStore.shared.updatedHighScoreFromGame), forKey: KEY_HIGH_SCORE)
    
}

func readHighScores() -> [GameScore] {
    
    let defaults = UserDefaults.standard
    
    if let savedArrayData = defaults.value(forKey: KEY_HIGH_SCORE) as?  Data {
        if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData) {
            return array
        }
        else {
            return []
        }
    }
    else {
        return []
    }
    
}

// These are extensions for the TableView that are essential

extension HighScoreViewController:UITableViewDelegate {
    
}

extension HighScoreViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return highScore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let score = highScore[indexPath.row]
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = "Score: \(score.score)"
        return cell
    }
}

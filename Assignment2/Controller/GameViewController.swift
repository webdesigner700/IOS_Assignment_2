//
//  GameViewController.swift
//  Assignment2
//
//  Created by vinay bayyapunedi on 25/04/23.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    var name:String? // This is an optional string that will get a value from the setting view controller (used on line 33)
    var remainingTime = 60 // this is a placeholder value for the remaining time which will get a value from the setting view controller (used on line 34)
    var timer = Timer() // this is a timer object of the Timer() class which used to implement a timer for the game
    var scoreCount = 0 // this is used to update the score when the user pops a bubble in the game
    var maxBubbles = 30// this is a placeholer value for the mac number of bubbles which will get a value from the setting view controller
    
    var bubbleCount = 0 // this is used to hold the value for the number os bubbles currently being shown on the screen
    
    var previousBubble = 0 // this is used in the bubblePressed function to update the score
    
    var bubblesArray = [Bubble]() // this array is used to store all the current bubbles that are generated and shown on the screen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name // The name label shows the name of the user that is obtained from the setting view controller
        remainingTimeLabel.text = String(remainingTime) // the remaining time label shows the amount of time the user can play the game for
        scoreLabel.text = String(scoreCount) // the score label represents the value scoreCount which increases in value as more and more bubbles are popped on the screen
        
        // This sortedFinalHighScore is an array of sorted high scores that is appeneded on line 37 in the HighScoreViewController
        // This array exists so that i can extract the first element from the array which is the highest score (since the array is sorted) and print it in the highScore Label.
        if (DataStore.shared.sortedFinalHighScores.count > 0) {
            highScoreLabel.text = String(DataStore.shared.sortedFinalHighScores[0].score)
        }
        else {
            highScoreLabel.text = "0"
        }
        
        // the timer object defined on line 20 is coded to act as a timer that starts from the value of "remaining time" and stops when it reaches 0
        // the self.counting() function is used to decrease the value of remaining time and keep updating it in the remianing time label
        // the self.generateBubbles() is used to generate new bubbles on the screen as long as the value of remaining time is not 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.counting()
            self.generateBubbles()
        }
    }
    
    // Comment the code
    func counting() {
        
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        
        
        //When the value of remaining time becomes 0, the game ends and the gameOver function will run
        if (remainingTime == 0) {
            self.gameOver()
        }
    }
    
    
    // This function is used to geenrate a single bubble and is used in a while loop to generate multiple bubbles in the generateBubbles function on line 105
    func generateBubble()-> Bool {
        
        
        //an object of the type Bubble is created
        let bubble = Bubble()
        
        // this function is used to check whether the newly generated bubble is overlapping with existing bubbles on the screen. If the bubble is overlapping with another bubble, the generateBubble function will return false in the generateBubbles function in line 120.
        if (overlapped(bubble: bubble)) { // if a bubble overlaps another bubble, it wont be formed
            return false
        }
        
        
        bubble.animation()
        
        //The background color of each new bubble generated is set based on probability basis. On line 21 in the Bubble file, a switch case is used to determine the background color of each bubble. A random value between 1 and 100 is chosen for a variable called "probability" and it is passed into the switvh case. Depending on what value "probability" is, the background color value of the bubble is set.
        
        //Depending on the background color of the bubble, a tag value is defined so that the score can be updated easily in the bubbleTapped function (REFER TO LINE 171
        
        if (bubble.backgroundColor == .red) {
            bubble.tag = 1
        }
        else if (bubble.backgroundColor == .orange) {
            bubble.tag = 2
        }
        else if (bubble.backgroundColor == .green) {
            bubble.tag = 3
        }
        else if (bubble.backgroundColor == .blue) {
            bubble.tag = 4
        }
        else if (bubble.backgroundColor == .black) {
            bubble.tag = 5
        }
        
        // the bubble is added to the view on the game screen
        self.view.addSubview(bubble)
        
        //A target fucntion is added which runs when a bubble (a UI Button) is pressed on.
        bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
        
        // the newly generated bubble is appended to the array of all bubbles
        bubblesArray.append(bubble)
        
        
        // Since the generation of a new bubble is successful, teh function returns true
        return true
        
    }
    
    func generateBubbles() {
        
        // If the bubbleCount (count of existing bubbles on the screen) is the same as max number of bubbles allowed, a random set of bubbles are removed from the screen in the if clause.
        
        if (bubbleCount == maxBubbles) {
            
            // the bubblesToBeRemoved value will be random and it is always between 1 and the max number of bubbles allowed
            let bubblesToBeRemoved = Int.random(in: 1...maxBubbles)
            
            // the removeBubbles function removes the "bubblesToBeRemoved" amount of bubbles from the screen (REFER TO LINE 249 FOR CONTEXT)
            removeBubbles(bubblesToBeRemoved: bubblesToBeRemoved)
        }
        
        // While there are less that max number of bubbles on the screen, a new bubble will keep getting generated
        while (bubbleCount < maxBubbles) {
            
             if (generateBubble()) {
                 
                 // If a new bubble is generated succcessfully, the bubbleCount (no of bubbles on the screen at the moment) will be increased by 1
                bubbleCount += 1
            }
        }
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        
        // This is the target function that gets run for every bubble (UI Button) when it is pressed on
        
        // The bubble that is pressed on ("sender" in this case) will flash before disappearing and gets removed from the superview
        
        sender.flash()
        sender.removeFromSuperview()
        
        
        // the bubbleCount (no of bubbles on the screen at the moment) decreases by 1 since a bubble is removed from the screen
        bubbleCount -= 1
        
        
        // This while loop is used to loop over every element in the bubbleArray and find the bubble that the target function is being run on. Since this bubble is removed from the screen, it is also removed from the array of bubbles on the screen
        var i = 0
        
        while (i < bubblesArray.count) {
            
            if (bubblesArray[i] == sender) {
                bubblesArray.remove(at: i)
            }
            i += 1
        }
        
        // (REFER TO LINE 85 FOR CONTEXT). Depending on the tag (which represents the background color of the bubble) of the bubble being pressed on, the scoreCount value is updated.
        if (sender.tag == 1) {
            
            if (previousBubble == 1) {
                scoreCount += Int(1 * 1.5)
            }
            else {
                scoreCount += 1
            }
            scoreLabel.text = String(scoreCount)
            
        }
        else if (sender.tag == 2) {

            if (previousBubble == 2) {
                scoreCount += Int(2 * 1.5)
            }
            else {
                scoreCount += 2
            }
            scoreLabel.text = String(scoreCount)
        }
        else if (sender.tag == 3) {
            
            if (previousBubble == 3) {
                scoreCount += Int(5 * 1.5)
            }
            else {
                scoreCount += 5
            }
            scoreLabel.text = String(scoreCount)
        }
        else if (sender.tag == 4) {
            
            if (previousBubble == 4) {
                scoreCount += Int(8 * 1.5)
            }
            else {
                scoreCount += 8
            }
            scoreLabel.text = String(scoreCount)
        }
        else if (sender.tag == 5) {
            
            if (previousBubble == 5) {
                scoreCount += Int(10 * 1.5)
            }
            else {
                scoreCount += 10
            }
            scoreLabel.text = String(scoreCount)
        }
        
       // The previousBubble value is used to store the tag value of the previous bubble being removed. It is used to check whether a bubble of the same color is being popped consecutiely. If so, the scoreCount is multiplied by 1.5. The if clause that is used to do this is on line 172, 183, 193, 203 and 213.
        
        previousBubble = sender.tag
        
    }
    
    // This function is used to check whether a newly created bubble in the generateBubble fucntion is overlapping with any existing bubbles on the screen.
    
    func overlapped(bubble: Bubble) -> Bool {
        
        var intersected = false
        
        for bubbles in bubblesArray {
            
            // the x,y posisiton of the parameter bubble is checked with all the x,y coordinates of existing bubbles in the bubble Array. If the parameter bubble intersects with any bubble, a "true" value is returned by the function
            
            if (bubble.frame.intersects(bubbles.frame)) {
                intersected = true
            }
        }
        
        return intersected
        
    }
    
    // This function is used to remove a random set of bubbles when the number of bubbles on the screen si equal to the max number of bubbles allowed on the screen (REFER TO LINE 130 FOR CONTEXT)
    
    func removeBubbles(bubblesToBeRemoved: Int) {
        
        
        // The index at which the bubble will be removed from the bubblesArray. This value starts at the final element of the bubbles array
        var index = bubblesArray.count - 1
        
        // the loopCounter is equal to the bubblesToBeRemoved value, so that the while loop will run as many times as "loop counter" and remove a single bubble from the array each time
        var loopCounter = bubblesToBeRemoved
        
        while (loopCounter > 0) {
            
            // the bubble at the end of the array is removed from the superview and the array respectivelty in lines 261 and 262
            bubblesArray[index].removeFromSuperview()
            bubblesArray.remove(at: index)
            
            // the index, loop counter is decreased by 1 and also the bubbleCount is decreased by 1 since a bubble is remvoed.
            index -= 1
            loopCounter -= 1
            bubbleCount -= 1
        }
    }
    
    // This function runs after the timer runs out and the value of "remaining time" becomes 0
    
    func gameOver() {
        
        // A gameScore value is created (GameScore is a struct created on line 11 in the HighScoreViewController used to hold the values of name and score of every game instance that happens.
        
        // The gameScore value on lien 279 gets the value of name from the name Label and the score from the score Label.
        
        let gameScore = GameScore(name: self.nameLabel.text ?? "", score: Int(self.scoreLabel.text ?? "") ?? 0)
        
        //updatedHighScroeFromGame is an array of the type GameScroe that get appended with a value of a new gameScore after each game runs.
        
        DataStore.shared.updatedHighScoreFromGame.append(gameScore)
        
        // The timer is invalidated since the game has ended and the name and score is stored securely in an aray in a DataStore
        timer.invalidate()
        
        // Lines from 290 to 292 are used to segue from the GameView to HighScoreView once the game ahs ended
        
        let vc = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
        self.navigationController?.pushViewController(vc, animated: true)
        vc.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
}

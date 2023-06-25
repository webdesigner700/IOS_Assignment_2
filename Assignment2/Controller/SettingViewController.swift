//
//  SettingViewController.swift
//  Assignment2
//
//  Created by vinay bayyapunedi on 25/04/23.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var bubbleSlider: UISlider!
    
    @IBOutlet weak var bubbleLabel: UILabel!
    
    @IBOutlet weak var gameTimeLabel: UILabel!
    
    @IBOutlet weak var gameButton: UIButton!
    
    
    @IBAction func timeChanged(_ sender: UISlider) { // this function is connected to the slider that is used to change the time of the game
        
        let gameTime = Int(sender.value) // when the slider value changes, it is being stored in gameTime
        gameTimeLabel.text = String(gameTime) // the label right below the time slider displays the new time value
    }
    
    
    @IBAction func bubbleChanged(_ sender: UISlider) { // this function is connected to the slider that is used to change the max number of bubbles to be displayed on the screen
        
        let noOfBubbles = Int(sender.value) // when the slider value changes, it is being stored in noBubbles
        bubbleLabel.text = String(noOfBubbles) // the label right below the bubble slider displays the new max bubbles value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // this function is used to prepare the UI for a segue from the game setting screen to the game view screen
        if segue.identifier == "goToGame" { // This is used to identify the storyboard screen the segue is supposed to happen to
            let VC = segue.destination as! GameViewController // the destination of the segue is being stored in the value VC
            //This value VC is being used to send data from the settingViewController to the GameViewController
            VC.name = nameTextField.text! // the name entered in the name text feild is being sent to the gameViewController
            VC.remainingTime = Int(timeSlider.value) // the remaining time value from the time slider is being sent to the gameViewController
            VC.maxBubbles = Int(bubbleSlider.value) // the max number of bubbles value from the bubble slider is being sent to the gameviewController
        }
    }


}

//
//  Data Score.swift
//  Assignment2
//
//  Created by vinay bayyapunedi on 28/04/23.
//

import Foundation

class DataStore {
    
    var name: String = ""
    var score: String = "0"
    
    var updatedHighScoreFromGame:[GameScore] = []
    
    var sortedFinalHighScores:[GameScore] = []
    
    static let shared  = DataStore()

}

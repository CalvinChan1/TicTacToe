//
//  ViewController.swift
//  TicTacToe
//
//  Created by Calvin Chan on 2015-11-06.
//  Copyright (c) 2015 Lucy&Calvin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions
    
    //
    var xTurn = true
    
    var numberOfTurns = 0
    
    
    var x: [Int] = []
    var y: [Int] = []

    @IBOutlet weak var button1: UIButton!

    @IBOutlet weak var button2: UIButton!
    
    // Action activates when button is clicked
    @IBAction func tappedButton(sender: AnyObject) {
        
        // current button
        let buttonTapped : UIButton = sender as! UIButton
        
        // tag of current button
        let tagTapped = buttonTapped.tag
        
        
        
        if (buttonTapped.titleLabel?.text != "X" && buttonTapped.titleLabel?.text != "O") {
            if (xTurn) {
                buttonTapped.setTitle("X", forState: UIControlState.Normal)
                x.append(tagTapped)
                xTurn = false
                print(tagTapped)
            }
            else {
                buttonTapped.setTitle("O", forState: UIControlState.Normal)
                y.append(tagTapped)
                xTurn = true
                print(tagTapped)
            }
        }

        var wintypes = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
        
        
        // checkWinner
        if (numberOfTurns >= 5) {
            // check
            // for each array in wintypes, check the first elem
            // with each sorted list. If it exists then check the rest of the list to see if all 3 numbers match
            // if all three numbers match, then print("\(player) wins!) and end the game
            // else move on to the rest of the array if it doesnt
            
            
            // y just went
            if (xTurn) {
                y.sortInPlace()
                
                
            }
            // x just went
            else {
                x.sortInPlace()
                
                
            }
        }
        
    }
  /*
    1 2 3
    4 5 6
    7 6 9
    
    /*
    if( buttonTapped.titleLabel?.text == "X" ) {
    buttonTapped.setTitle("O", forState: UIControlState.Normal)
    } else {
    buttonTapped.setTitle("X", forState: UIControlState.Normal)
    }
    */
    
    
    
    (1, 1) (2, 1) (3, 1)
    (1, 2) (2, 2) (3, 2)
    (1, 3) (2, 3) (3, 3) */
}

    
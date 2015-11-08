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
    
    // TicTacToe Logic
    
    var xTurn = false
    
    var numberOfTurns = 0
    
    // checks for the winner
    func checkWinner() {
        if (numberOfTurns >= 5) {
            
        }
    }
    
    @IBAction func tappedButton(sender: AnyObject) {
        
        let buttonTapped : UIButton = sender as UIButton
        
        let tagTapped = buttonTapped.tag
        
        if (buttonTapped.titleLabel?.text != "O" || buttonTapped.titleLabel?.text != "X") {
            numberOfTurns += 1
            if (xTurn) {
                buttonTapped.setTitle("X", forState: UIControlState.Normal)
                xTurn = false
                
            }
            else {
                buttonTapped.setTitle("O", forState: UIControlState.Normal)
                xTurn = true
            }
        }
    }
    
  /*
    
    
    if ( buttonTapped.titleLabel?.text == "X" ) {
    buttonTapped.setTitle("O", forState: UIControlState.Normal)
    }
    else {
    buttonTapped.setTitle("X", forState: UIControlState.Normal)
    }
    
    

    1 2 3
    4 5 6
    7 6 9
    
    
    (1, 1) (2, 1) (3, 1)
    (1, 2) (2, 2) (3, 2)
    (1, 3) (2, 3) (3, 3) */
}









    
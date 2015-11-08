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

    @IBOutlet weak var button1: UIButton!

    @IBOutlet weak var button2: UIButton!
    
    // Action activates when button is clicked
    @IBAction func tappedButton(sender: AnyObject) {
        
        // current button
        let buttonTapped : UIButton = sender as! UIButton
        
        // tag of current button
        let tagTapped = buttonTapped.tag
        
        
        /*
        if( buttonTapped.titleLabel?.text == "X" ) {
            buttonTapped.setTitle("O", forState: UIControlState.Normal)
        } else {
            buttonTapped.setTitle("X", forState: UIControlState.Normal)
        }
        */
        
        if (buttonTapped.titleLabel?.text != "X" && buttonTapped.titleLabel?.text != "O") {
            if (xTurn) {
                buttonTapped.setTitle("X", forState: UIControlState.Normal)
                xTurn = false
            }
            else {
                buttonTapped.setTitle("O", forState: UIControlState.Normal)
                xTurn = true
            }
        }
        
        /*
        // checkWinner
        if (numberOfTurns >= 5) {
            // check
        }
        */
        
    }
  /*
    1 2 3
    4 5 6
    7 6 9
    
    
    (1, 1) (2, 1) (3, 1)
    (1, 2) (2, 2) (3, 2)
    (1, 3) (2, 3) (3, 3) */
}

    
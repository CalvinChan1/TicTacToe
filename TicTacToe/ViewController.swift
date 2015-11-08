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
    var turn = 1 // x = 0, y = 1
    //
    var xTurn = false
    
    var numberOfTurns = 8;

    @IBOutlet weak var button1: UIButton!

    @IBOutlet weak var button2: UIButton!
    
    @IBAction func tappedButton(sender: AnyObject) {
        
        let buttonTapped : UIButton = sender as! UIButton
        
        let tagTapped = buttonTapped.tag
        
        if( buttonTapped.titleLabel?.text == "X" ) {
            buttonTapped.setTitle("O", forState: UIControlState.Normal)
        } else {
            buttonTapped.setTitle("X", forState: UIControlState.Normal)
        }
        
        
        
        
        
    }
  /*
    1 2 3
    4 5 6
    7 6 9
    
    
    (1, 1) (2, 1) (3, 1)
    (1, 2) (2, 2) (3, 2)
    (1, 3) (2, 3) (3, 3) */
}

    
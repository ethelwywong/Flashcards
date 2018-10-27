//
//  ViewController.swift
//  Flashcards
//
//  Created by Ethel Wong on 10/13/18.
//  Copyright © 2018 Ethel Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        //card.clipsToBounds = true
        card.layer.shadowOpacity = 0.2
        frontLabel.layer.cornerRadius = 20.0
        backLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        
        btnOptionOne.layer.cornerRadius = 5.0
        btnOptionOne.layer.borderWidth = 1.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0, green: 0.805817306, blue: 0.877905786, alpha: 1)
        btnOptionTwo.layer.cornerRadius = 5.0
        btnOptionTwo.layer.borderWidth = 1.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0, green: 0.805817306, blue: 0.877905786, alpha: 1)
        btnOptionThree.layer.cornerRadius = 5.0
        btnOptionThree.layer.borderWidth = 1.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0, green: 0.805817306, blue: 0.877905786, alpha: 1)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        if frontLabel.isHidden//if answer is already shown
        {
            frontLabel.isHidden = false//go back to question
        }
        else//if question is showing
        {
            frontLabel.isHidden = true//show answer
        }
    }
    
    func updateFlashcard(question: String, answer: String){
        frontLabel.text = question
        backLabel.text = answer
        
    }
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        btnOptionOne.isHidden = true
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        btnOptionThree.isHidden = true
    }
    
    
}


//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Ethel Wong on 10/27/18.
//  Copyright © 2018 Ethel Wong. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var extraAnswerTwoTextField: UITextField!
    @IBOutlet weak var extraAnswerOneTextField: UITextField!
    
    var initialQuestion: String?
    var initialAnswer: String?
    //var initialExtraAnswerOne: String?
    //var initialExtraAnswerTwo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
        //extraAnswerOneTextField.text = initialExtraAnswerOne
        //extraAnswerTwoTextField.text = initialExtraAnswerTwo

        // Do any additional setup after loading the view.
    }
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        let questionText = questionTextField.text
        
        let answerText = answerTextField.text
        
        let extraAnswerOneText = extraAnswerOneTextField.text
        
        let extraAnswerTwoText = extraAnswerTwoTextField.text
        
        if (questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty){
            let alert = UIAlertController(title: "Missing String", message: "You need to enter a question or answer", preferredStyle: UIAlertController.Style .alert)
            present(alert, animated: true)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
        }
        else {
            var isExisting = false
            if initialQuestion != nil{
                isExisting = true
            }
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, extraAnswerOne: extraAnswerOneText!, extraAnswerTwo: extraAnswerTwoText!, isExisting: isExisting)
            dismiss(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

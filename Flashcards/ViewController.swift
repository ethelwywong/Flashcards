//
//  ViewController.swift
//  Flashcards
//
//  Created by Ethel Wong on 10/13/18.
//  Copyright © 2018 Ethel Wong. All rights reserved.
//

import UIKit

struct Flashcard{
    var question: String
    var answer: String
    var extraAnswerOne: String
    var extraAnswerTwo: String
}

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    var correctAnswerButton: UIButton!
    
    
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
        
        
        readSavedFlashcards()
        
        if flashcards.count == 0{
            updateFlashcard(question: "How many continents are there?", answer: "Seven", extraAnswerOne: "Four", extraAnswerTwo: "Ten", isExisting: false)
        }
        else{
            updateLabels()
            updateNextPrevButtons()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        card.alpha = 0.0
        btnOptionOne.alpha = 0.0
        btnOptionTwo.alpha = 0.0
        btnOptionThree.alpha = 0.0
        
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionOne.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionTwo.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionThree.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
            self.btnOptionOne.alpha = 1.0
            self.btnOptionTwo.alpha = 1.0
            self.btnOptionThree.alpha = 1.0
            
            self.card.transform = CGAffineTransform.identity
            self.btnOptionOne.transform = CGAffineTransform.identity
            self.btnOptionTwo.transform = CGAffineTransform.identity
            self.btnOptionThree.transform = CGAffineTransform.identity
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }
        
        
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard(){
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.frontLabel.isHidden//if answer is already shown
            {
                self.frontLabel.isHidden = false//go back to question
            }
            else//if question is showing
            {
                self.frontLabel.isHidden = true//show answer
            }
        })
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String, extraAnswerTwo: String, isExisting: Bool){
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne, extraAnswerTwo: extraAnswerTwo)
        //frontLabel.text = flashcard.question
        //backLabel.text = flashcard.answer
        if isExisting{
            print(currentIndex)
            flashcards[currentIndex] = flashcard
        }
        else{
            flashcards.append(flashcard)
            print("added new flashcard")
            currentIndex = flashcards.count-1
            print("now have \(flashcards.count) flashcards")
            print("Current index is \(currentIndex)")
        }
        
        
        btnOptionOne.setTitle(extraAnswerOne, for: .normal)
        btnOptionTwo.setTitle(answer, for: .normal)
        btnOptionThree.setTitle(extraAnswerTwo, for: .normal)
        
        updateNextPrevButtons()
        updateLabels()
        
        saveAllFlashcardsToDisk()
    }
    func updateNextPrevButtons(){
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        }
        else{
            nextButton.isEnabled = true
        }
        if currentIndex == 0{
            prevButton.isEnabled = false
        }
        else{
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        //new
        btnOptionOne.isHidden = false
        btnOptionOne.isEnabled = true
        btnOptionTwo.isHidden = false
        btnOptionTwo.isEnabled = true
        btnOptionThree.isHidden = false
        btnOptionThree.isEnabled = true
        
        
        //update buttons
        let buttons = [btnOptionOne, btnOptionTwo, btnOptionThree].shuffled()
        let answers = [currentFlashcard.answer, currentFlashcard.extraAnswerOne, currentFlashcard.extraAnswerTwo].shuffled()
        
        for(button, answer) in zip(buttons, answers){
            button?.setTitle(answer, for:.normal)
            
            if answer == currentFlashcard.answer {
                correctAnswerButton = button
            }
        }
    }
    
    func saveAllFlashcardsToDisk(){
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer, "extraAnswerOne": card.extraAnswerOne, "extraAnswerTwo": card.extraAnswerTwo]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("flashcards saved to userdefaults")
    }
    
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let savedCards = dictionaryArray.map {dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswerOne: dictionary["extraAnswerOne"]!, extraAnswerTwo: dictionary["extraAnswerTwo"]!)
            }
            
            flashcards.append(contentsOf: savedCards)
        }
//        for i in 0...flashcards.count-1{
//            print(flashcards[i].question, flashcards[i].answer, flashcards[i].extraAnswerOne, flashcards[i].extraAnswerTwo)
        //}
    }
    
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        if btnOptionOne == correctAnswerButton{
            flipFlashcard()
        }
        else{
            frontLabel.isHidden = false
            btnOptionOne.isEnabled = false
            //new
            btnOptionOne.isHidden = true
        }
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        if btnOptionTwo == correctAnswerButton{
            flipFlashcard()
        }
        else{
            frontLabel.isHidden = false
            btnOptionTwo.isEnabled = false
            //new
            btnOptionTwo.isHidden = true
        }
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        if btnOptionThree == correctAnswerButton{
            flipFlashcard()
        }
        else{
            frontLabel.isHidden = false
            btnOptionThree.isEnabled = false
            //new
            btnOptionThree.isHidden = true
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        updateNextPrevButtons()
        animatePCardOut()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        updateNextPrevButtons()
        animateCardOut()
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        present(alert, animated: true)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
    }
    func deleteCurrentFlashcard(){
        flashcards.remove(at: currentIndex)
        
        if currentIndex > flashcards.count - 1{
            currentIndex = flashcards.count - 1
        }
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    func animateCardOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            //new
            self.frontLabel.isHidden = false
            self.updateLabels()
            self.animateCardIn()
        })
    }
    func animateCardIn(){
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    func animatePCardOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        }, completion: { finished in
            //new
            self.frontLabel.isHidden = false
            self.updateLabels()
            self.animatePCardIn()
        })
    }
    func animatePCardIn(){
        card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
}


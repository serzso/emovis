//
//  GameController.swift
//  Movies
//
//  Created by Serényi  Zsófia on 2018. 07. 09..
//  Copyright © 2018. Serényi  Zsófia. All rights reserved.
//

import UIKit
import Foundation

class GameController: UIViewController, UITextFieldDelegate {
    
    let colorProvider = BackgroundColorProvider()
    
    let soundProvider = PlaySoundViewController()
    
    var tenKeys = originalKeys.randomTenElement()
    
    var userPointCounter = 0
    
    
    // Outlets
    
        // 1. UILabel
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    
        // 2. UITextField
    
    @IBOutlet weak var userAnswer: UITextField!
    
        // 3. UIButton
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonLabel: UIButton!
    @IBOutlet weak var startOverButton: UIButton!
    
    
    // ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let firstRandomMovieNumber = random(tenKeys.count)
        emojiLabel.text = tenKeys[firstRandomMovieNumber] as? String
        tenKeys.remove(at: firstRandomMovieNumber)
        userAnswer.placeholder = "Type in your answer"
        
        
        responseLabel.text = nil
        answerLabel.text = nil
        nextButtonLabel.setTitle("Skip", for: .normal)
        startOverButton.isEnabled = false
        startOverButton.setTitle(nil, for: .normal)
        
        userAnswer.autocorrectionType = .no
        self.hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Actions
    
    // 1. Check
    
    @IBAction func check() {
        self.view.endEditing(true)
        nextButtonLabel.setTitle("Next", for: .normal)
        
        checkButton.setTitle(nil, for: .normal)
        
        guard let currentMovie = emojiLabel.text else {
            return
        }
        
        guard let userResponse = userAnswer.text else {
            return
        }
        
        let movie = movies[currentMovie]
        answerLabel.text = movie
        
        if movie?.uppercased() == userResponse.uppercased() {
            responseLabel.text = "Correct ✔️"
            answerLabel.text = "+10"
            userPointCounter += 10
            showAnswerButton.isEnabled = false
            view.backgroundColor = goodAnswerColor
            soundProvider.playSoundEffect(for: "goodAnswer")
        } else {
            responseLabel.text = "Wrong ✖️"
            view.backgroundColor = wrongAnswerColor
            soundProvider.playSoundEffect(for: "wrongAnswer")
        }
    }
    
    
    // 2. Show answer
    
    @IBAction func showAnswer() {
        showAnswerButton.isEnabled = false
        nextButtonLabel.setTitle("Next", for: .normal)
        checkButton.setTitle(nil, for: .normal)
        
        guard let currentMovie = emojiLabel.text else {
            return
        }
        
        let movie = movies[currentMovie]
        answerLabel.text = movie
        
        soundProvider.playSoundEffect(for: "showAnswer")
    }
    

    // 3. Next movie
    
    @IBAction func nextMovie() {
        view.backgroundColor = colorProvider.randomColor()
        userAnswer.backgroundColor = .white
        responseLabel.text = nil
        userAnswer.text = nil
        nextButtonLabel.setTitle("Skip", for: .normal)
        checkButton.setTitle("Check", for: .normal)
        showAnswerButton.isEnabled = true
        
        let randomMovieNumber = random(tenKeys.count)
        emojiLabel.text = tenKeys[randomMovieNumber] as? String
        tenKeys.remove(at: randomMovieNumber)
        
        let randomTextNumber = random(text.count)
        textLabel.text = text[randomTextNumber]
        
        answerLabel.text = nil
        
        if tenKeys.count == 0 {
            textLabel.text = nil
            emojiLabel.text = nil
            
            emojiLabel.text = "Your result: \(userPointCounter)/100"
            emojiLabel.textColor = .white
            
            if userPointCounter <= 50 {
                soundProvider.playSoundEffect(for: "pointUnder50")
            } else {
                soundProvider.playSoundEffect(for: "pointOver50")
            }
        
            checkButton.setTitle(nil, for: .normal)
            textLabel.text = "Game Over"
            userAnswer.removeFromSuperview()
            nextButton.isEnabled = false
            nextButton.setTitle(nil, for: .normal)
            showAnswerButton.setTitle(nil, for: .normal)
            
            startOverButtonAppear()
        }
    }
    
    
    // 4. Start over
    
    
    @IBAction func startOver() {
        self.dismiss(animated: true)
    }
    
    
    // Helper methodes

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userAnswer.resignFirstResponder()
        check()
        return true
    }
    
    func startOverButtonAppear() {
        startOverButton.isEnabled = true
        startOverButton.setTitle("Start Over", for: .normal)
    }
}




extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}






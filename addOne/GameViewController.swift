//
//  GameViewController.swift
//  addOne
//
//  Created by Mac on 29/11/2020.
//

import UIKit
import SpriteKit
import GameplayKit

class creditsController: UIViewController{
    @IBOutlet weak var menuButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let attrString = NSAttributedString(
            string: "Play!",
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: -2.0,
            ]
        )
    
        menuButton?.titleLabel?.attributedText = attrString
        menuButton?.titleLabel?.text = "menu"
        
    }
}

class mainMenuController: UIViewController {
    @IBOutlet weak var playButton:UIButton?
    @IBOutlet weak var creditsButton:UIButton?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let attrString = NSAttributedString(
            string: "Play!",
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: -2.0,
            ]
        )
        
        playButton?.titleLabel?.attributedText = attrString
        creditsButton?.titleLabel?.attributedText = attrString
        

    }
    
}

class GameViewController: UIViewController {

    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var timeLabel:UILabel?
    @IBOutlet weak var numberLabel:UILabel?
    @IBOutlet weak var inputField:UITextField?
    @IBOutlet weak var extraTimeLabel:UILabel?
    @IBOutlet weak var highscoreLabel:UILabel?
    @IBOutlet weak var infoText:UILabel?
    @IBOutlet weak var menuButton:UIButton?
    
    
    var score = 0
    var timer:Timer?
    var seconds = 15
    var extraTime = ""
    var highScore = UserDefaults.standard.integer(forKey: "HS")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updateHighScoreLabel()
        updateScoreLabel()
        updateNumberLabel()
        updateTimeLabel()
        updateExtraTimeLabel()
        
        let attrString = NSAttributedString(
            string: "Score",
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.strokeWidth: -2.0,
            ]
        )
        scoreLabel?.attributedText = attrString
        scoreLabel?.text = "Score"
        timeLabel?.attributedText = attrString
        timeLabel?.text = "Time"
        infoText?.attributedText = attrString
        infoText?.text = "Add 1 to each of the digits. So, 1357 becomes 2468."
        menuButton?.titleLabel?.attributedText = attrString
        menuButton?.titleLabel?.text = "menu"
        
    }
    
    
    
    func animateExtraTimeLabel() {
        UIView.animate(withDuration: 1) {
            self.extraTimeLabel?.alpha = 0
            self.extraTimeLabel?.center.y = 50
        }
    }
    
    func setHighScore(currentScore: Int) {
        highScore = UserDefaults.standard.integer(forKey: "HS")
        
        if currentScore > highScore {
            UserDefaults.standard.set(currentScore, forKey: "HS")
            highScore = UserDefaults.standard.integer(forKey: "HS")
        }
    }
    
    func updateHighScoreLabel() {
        highscoreLabel?.text = "Best: " + String(highScore)
    }
    
    func updateExtraTimeLabel(){
        extraTimeLabel?.text = extraTime
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = String(score)
    }
    
    func updateTimeLabel() {

        let min = (seconds / 60) % 60
        let sec = seconds % 60

        timeLabel?.text = String(format: "%02d", min) + ":" + String(format: "%02d", sec)
    }
    
    func updateNumberLabel() {
        numberLabel?.text = String.randomNumber(length: 4)
    }
    
    func finishGame()
    {
        timer?.invalidate()
        timer = nil
        
        setHighScore(currentScore: score)
        updateHighScoreLabel()
        
        let alert = UIAlertController(title: "Time's Up!", message: "Your time is up! You got a score of \(score) points. Awesome!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK, start new game", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
        score = 0
        seconds = 10
                
        updateTimeLabel()
        updateScoreLabel()
        updateNumberLabel()
    }
    
    @IBAction func inputFieldDidChange()
    {
        guard let numberText = numberLabel?.text, let inputText = inputField?.text else {
            return
        }
        
        guard inputText.count == 4 else {
            return
        }
    
        var isCorrect = true

        for n in 0..<4
        {
            var input = inputText.integer(at: n)
            let number = numberText.integer(at: n)
        
            if input == 0 {
                input = 10
            }
            
            if input != number + 1 {
                isCorrect = false
                break
            }
        }
        
        if isCorrect {
            score += 1
            
            self.extraTimeLabel?.text = ""
            self.extraTimeLabel?.alpha = 1
            self.extraTimeLabel?.center.y = 100
            
            if score < 5{
                seconds += 5
                extraTime = "+ 5s"
                animateExtraTimeLabel()
            }else if score >= 5 && score <= 9{
                seconds += 4
                extraTime = "+ 4s"
                animateExtraTimeLabel()
            }else if score >= 10 && score <= 14{
                seconds += 3
                extraTime = "+ 3s"
                animateExtraTimeLabel()
            }else if score >= 15{
                seconds += 2
                extraTime = "+ 2s"
                animateExtraTimeLabel()
            }
            
            
        } else {
            score -= 1
        }
        
        updateScoreLabel()
        updateExtraTimeLabel()
        updateNumberLabel()
        updateHighScoreLabel()
        inputField?.text = ""

        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.seconds == 0 {
                        self.finishGame()
                    } else if self.seconds <= 60 {
                        self.seconds -= 1
                        self.updateTimeLabel()
                    }
            }
        }
    }
}

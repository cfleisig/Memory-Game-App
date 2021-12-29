//
//  ViewController.swift
//  Fleisig_Clara_memoryGame
//
//  Created by Clara Fleisig on 2017-11-22.
//  Copyright © 2017 Clara Fleisig. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    //Variables are declared here:
    //Holds all card buttons to allow looping through all card buttons
    var buttonsArray:  [UIButton] = []
    //Holds a card button for compare function
    var cardButtonHolder: [UIButton] = []
    //Holds a card Image/flag for compare function
    var cardImageHolder = #imageLiteral(resourceName: "cardBack")
    //Holds number of times card Buttons are pressed for compare function
    var clickCount = 0
    //Holds boolean which is used to determine whether it is playerOne's turn or playerTwo's turn in playerVsPlayerMode
    var playerOneTurn = true
    //Holds the player's name from startScreenViewController
    var playerName = String()
    //Holds score for playerTwo in playerVsPlayerMode, which is a decimal because that is what is returned by the pow func
    var playerTwoScore : Decimal = 0
    //Holds number of consecutive matches made by a player in playerVsPlayerMode to facilitate exponential scoring
    var matchesInARow = 0
    //Holds the number of matches that have been made
    var matchesMade = 0
    //Holds the random number of the element that is appended from sortedDeck into shuffleDeck in shuffleRoutine()
    var randomlyGeneratedNumber = 0
    //Holds score count in timedMode, regularMode, and for player 1 in playerVsPlayerMode, which is a decimal because that is what is returned by the pow func
    var score : Decimal = 0
    //Holds the number of seconds left on the timer
    var seconds = 60
    //Holds a shuffled version of the card image
    var shuffledDeck: [UIImage] = []
    //Holds the card images
    var sortedDeck: [UIImage] = [#imageLiteral(resourceName: "bulgaria"), #imageLiteral(resourceName: "bulgaria"), #imageLiteral(resourceName: "gabon"), #imageLiteral(resourceName: "gabon"), #imageLiteral(resourceName: "hungary"), #imageLiteral(resourceName: "hungary"), #imageLiteral(resourceName: "german"), #imageLiteral(resourceName: "german"), #imageLiteral(resourceName: "netherlands"), #imageLiteral(resourceName: "netherlands"), #imageLiteral(resourceName: "luxembourg"), #imageLiteral(resourceName: "luxembourg"), #imageLiteral(resourceName: "yemen"), #imageLiteral(resourceName: "yemen"), #imageLiteral(resourceName: "sierraLeone"), #imageLiteral(resourceName: "sierraLeone")]
    //Holds Timer() function
    var timer = Timer()
    //Holds the limit of the randomlyGenereatedNumber so will be an element in sortedDeck
    var upperLimit: UInt32 = 16
    
    //Declared as true when their mode button has been pressed to keep track of what mode player is playing in
    var playerVsPlayerMode = false
    var regularMode = false
    var timedMode = false
    
    //These are the outlets that allow code to reference these elements
    //Outelets of labels where score timers and messages are shown
    @IBOutlet weak var littleLabel: UILabel!
    @IBOutlet weak var littleLabelTwo: UILabel!
    @IBOutlet weak var bigLabel: UILabel!
    
    //Outlet of button that resets game
    @IBOutlet weak var newGameButton: UIButton!
    
    //Outlet of button that shows the flags of all of the cards
    @IBOutlet weak var revealAllButton: UIButton!
    
    //Outlets of buttons that determine what gameMode/scoring type the player will play
    @IBOutlet weak var playerVsPlayerModeButton: UIButton!
    @IBOutlet weak var regularModeButton: UIButton!
    @IBOutlet weak var timerModeButton: UIButton!
    
    //Outlets of buttons that represent cards
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var button12: UIButton!
    @IBOutlet weak var button13: UIButton!
    @IBOutlet weak var button14: UIButton!
    @IBOutlet weak var button15: UIButton!
    @IBOutlet weak var button16: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //This array holds my buttons and is declared here because I need it to be able to execute connectingButtonsAndImages
        buttonsArray = [button1, button2, button3, button4, button5, button6, button7, button8, button9, button10, button11, button12, button13, button14, button15, button16]
        
        //Disable these buttons to avoid user from pressing them and thereby breaking the code and forces them to press the newGameButton
        disableCardButtons()
        playerVsPlayerModeButton.isEnabled = false
        regularModeButton.isEnabled = false
        revealAllButton.isEnabled = false
        timerModeButton.isEnabled = false
        
        //Displays a welcome message
        bigLabel.text = "Welcome \(playerName)"
        
        //Gives initial instructions
        littleLabel.text = "Press 'New Game' then select your desired mode"
        
        //Hides label because their are no messages or timers that need to be displayed on it yet
        littleLabelTwo.isHidden = true
    }
    
    
    //Executes code when new game button is pressed
    @IBAction func newGamePressed(_ sender: Any) {
        //Resets each element to the way it waw when app was originally openned
        matchesMade = 0
        clickCount = 0
        score = 0
        playerTwoScore = 0
        timer.invalidate()
    
        //Ensures user MUST press a game mode
        newGameButton.isEnabled = false
        revealAllButton.isEnabled = false
        regularModeButton.isEnabled = true
        timerModeButton.isEnabled = true
        playerVsPlayerModeButton.isEnabled = true
        disableCardButtons()
        
        //Ensures previous mode is pressed so only one gameMode is played at once
        regularMode = false
        timedMode = false
        playerVsPlayerMode = false
        
        //Hides labels because their are no messages or timers that need to be displayed yet
        bigLabel.isHidden = true
        littleLabel.isHidden = true
        littleLabelTwo.isHidden = true
        
        //Ensures timer begins from 60 if used again
        seconds = 60
        
        //Resets all cardButtons to cardBack image (flips them back over)
        for index in 0...15 {
            buttonsArray[index].setBackgroundImage(#imageLiteral(resourceName: "cardBack"), for: .normal)
        }
        
        //Ensures that if cardButtonHolder was not emptied (because reveal all was pressed when clickCount was odd, or timmer ended when clickCount was odd) it is now empty
        if cardButtonHolder.count >= 1{
            cardButtonHolder.remove(at: 0)
        }
    }
    
    //Executes code when reveal all button is pressed
    @IBAction func revealAllPressed(_ sender: Any) {
        //Stops user from pressing card buttons and thereby breaking code
        disableUserInteracctionCardButtons()
        
        //Disable buttons so user cannot press reveal all again
        revealAllButton.isEnabled = false
        
        //"You Both Lose" is displayed in the bigLabel when playerVsPlayerMode is true
        if playerVsPlayerMode {
            bigLabel.text = "You Both Lose!"
            bigLabel.isHidden = false
        //"You Lose" is displayed in the bigLabel when playerVsPlayerMode is not true
        } else {
            timer.invalidate()
            bigLabel.text = "You Lose!"
            bigLabel.isHidden = false
        }

        //Assigns all the flags in shuffledDeck to the approprate cardButton
        for index in 0...15 {
            buttonsArray[index].setBackgroundImage(shuffledDeck[index], for: .normal)
        }
    }
    
    //Executes code when regular mode button is pressed
    @IBAction func regularModePressed(_ sender: Any) {
        //Calls aModePressed which diesables and enables the appropriate buttons and shuffles the cards
        aModePressed()
        //Boolean allows it to be detemind that regular mode is being played
        regularMode = true
    }
    
    //Executes code when player vs. player mode button is pressed
    @IBAction func playerVsPlayerModePressed(_ sender: Any) {
        //Calls aModePressed which diesables and enables the appropriate buttons and shuffles the cards
        aModePressed()
        //Boolean allows it to be detemind that player vs. player mode is being played
        playerVsPlayerMode = true
        //States player one gets the first turn
        playerOneTurn = true
        
        //Tells users scores and which player's turn it is
        bigLabel.text =  "Player One's Turn"
        littleLabel.text = "Player Two: 0 pts."
        littleLabelTwo.text = "Player One: 0 pts."
        
        //Reveals all the labels so the users can see scores and which player's turn it is
        bigLabel.isHidden = false
        littleLabelTwo.isHidden = false
        littleLabel.isHidden = false
    }
    
    //Executes code when timer mode button is pressed
    @IBAction func timerModePressed(_ sender: Any) {
        //Calls aModePressed which diesables and enables the appropriate buttons and shuffles the cards
        aModePressed()
        //Boolean allows it to be detemind that timer mode is being played
        timedMode = true
        //Initiates times
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.clock), userInfo: nil, repeats: true)
    }
    
    //Every button will display its assigned image from shuffledDeck and calls the comparing function using its button and assinged image for shuffledDeck as input
    @IBAction func button1Pressed(_ sender: Any) {
        button1.setBackgroundImage(shuffledDeck[0], for: .normal)
        comparing(shuffledDeck[0], button1)
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        button2.setBackgroundImage(shuffledDeck[1], for: .normal)
        comparing(shuffledDeck[1], button2)
    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        button3.setBackgroundImage(shuffledDeck[2], for: .normal)
        comparing(shuffledDeck[2], button3)
    }
    
    @IBAction func button4Pressed(_ sender: Any) {
        button4.setBackgroundImage(shuffledDeck[3], for: .normal)
        comparing(shuffledDeck[3], button4)
    }
    
    @IBAction func button5Pressed(_ sender: Any) {
        button5.setBackgroundImage(shuffledDeck[4], for: .normal)
        comparing(shuffledDeck[4], button5)
    }
    
    @IBAction func button6Pressed(_ sender: Any) {
        button6.setBackgroundImage(shuffledDeck[5], for: .normal)
        comparing(shuffledDeck[5], button6)
    }
    
    @IBAction func button7Pressed(_ sender: Any) {
        button7.setBackgroundImage(shuffledDeck[6], for: .normal)
        comparing(shuffledDeck[6], button7)
    }
    
    @IBAction func button8Pressed(_ sender: Any) {
        button8.setBackgroundImage(shuffledDeck[7], for: .normal)
        comparing(shuffledDeck[7], button8)
    }
    
    @IBAction func button9Pressed(_ sender: Any) {
        button9.setBackgroundImage(shuffledDeck[8], for: .normal)
        comparing(shuffledDeck[8], button9)
    }
    
    @IBAction func button10Pressed(_ sender: Any) {
        button10.setBackgroundImage(shuffledDeck[9], for: .normal)
        comparing(shuffledDeck[9], button10)
    }
    
    @IBAction func button11Pressed(_ sender: Any) {
        button11.setBackgroundImage(shuffledDeck[10], for: .normal)
        comparing(shuffledDeck[10], button11)
    }

    @IBAction func button12Pressed(_ sender: Any) {
        button12.setBackgroundImage(shuffledDeck[11], for: .normal)
        comparing(shuffledDeck[11], button12)
    }
    
    @IBAction func button13Pressed(_ sender: Any) {
        button13.setBackgroundImage(shuffledDeck[12], for: .normal)
        comparing(shuffledDeck[12], button13)
    }
    
    @IBAction func button14Pressed(_ sender: Any) {
        button14.setBackgroundImage(shuffledDeck[13], for: .normal)
        comparing(shuffledDeck[13], button14)
    }
    
    @IBAction func button15Pressed(_ sender: Any) {
        button15.setBackgroundImage(shuffledDeck[14], for: .normal)
        comparing(shuffledDeck[14], button15)
    }
    
    @IBAction func button16Pressed(_ sender: Any) {
        button16.setBackgroundImage(shuffledDeck[15], for: .normal)
        comparing(shuffledDeck[15], button16)
    }
    
    //Called to initiate timer
    @objc func clock() {
        //decreases seconds by 1
        seconds -= 1
        
        //Displays number of seconds on timer
        littleLabel.text = "\(seconds) seconds"
        littleLabel.isHidden = false
        
        //What happens when timer hits 0
        if seconds == 0{
            //Display text You Lose
            bigLabel.text = "You Lose!"
            bigLabel.isHidden = false
            //Stops user from interacting with card buttons
            disableUserInteracctionCardButtons()
            //Stops timer
            timer.invalidate()
        }
    }
    
    //Called when modes are pressed
    func aModePressed() {
        //Puts cards in a random order into shuffledDeck array
        shuffleRoutine()
        
        //Disables mode button so user cannot change mode halfway through a game
        regularModeButton.isEnabled = false
        timerModeButton.isEnabled = false
        playerVsPlayerModeButton.isEnabled = false
        
        //Enables all buttons except for modeButtons to allow user all possible options
        newGameButton.isEnabled = true
        revealAllButton.isEnabled = true
            //enables every cardButton
        for index in 0...15 {
            buttonsArray[index].isEnabled = true
        }
            //enables the user to interabt with every cardButton
        for index in 0...15 {
            buttonsArray[index].isUserInteractionEnabled = true
        }
    }
    
    //Called every time a card is pressed
    func comparing (_ cardImage: UIImage, _ cardButton: UIButton) {
        //adds one to clikcCount to determine if this is the first button pressed in a pair or the second
        clickCount += 1
        
        //when clicks are uneven/when it is the first card of a pair that has been pressed
        if clickCount % 2 == 1{
            //stops user form double clicking the button
            cardButton.isUserInteractionEnabled = false
            //saves the button and image to compare(image) and change(button) later
            cardButtonHolder.append(cardButton)
            cardImageHolder = cardImage
        
        //when clicks are even/when it is the second card of a pair that has been pressed
        }else{
            //When the uneven card image(the image of the first card pressed of the pair) and the even card image (the second card pressed of the pair) are the same
            if cardImageHolder == cardImage {
                //add one to matches made to be able to tell when all cards have been matched
                matchesMade += 1
                //stops user from interaction with the even card button
                cardButton.isUserInteractionEnabled = false
                //see each functions for explanations
                vsMatch()
                scoringForRegularMode()
                scoringForTimedMode()
                scoringForPlayerVsPlayerMode()
            
            //When the odd card image(the image of the first card pressed of the pair) and the even card image (the second card pressed of the pair) are not the same
            } else {
                //Waits .5 seconds before code executes to allow user to see the even card(the second card pressed of the pair)
                delay(0.5){
                    //See function itself for further explanation
                    self.vsNoMatch()
                    //sets both odd and even card images to cardBack/flips them back
                    cardButton.setBackgroundImage(#imageLiteral(resourceName: "cardBack"), for: .normal)
                    self.cardButtonHolder[0].setBackgroundImage(#imageLiteral(resourceName: "cardBack"), for: .normal)
                    cardButton.isUserInteractionEnabled = true
                    self.cardButtonHolder[0].isUserInteractionEnabled = true
                }
            }
            //Waits .6 seconds before code executes to allow code above to execute first
            delay(0.6) {
                //Removes odd card image(the image of the first card pressed of the pair) from cardButtonHolder to allow next pair of cards pressed to use comparing funtion
                self.cardButtonHolder.remove(at: 0)
            }
        }
    }
    
    //Delays code being executed by a specified amount of seconds and is called in the comparing function
    func delay(_ delay:Double, closure:@escaping ()->()){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    //Called when new game pressed and in viewDidLoad
    func disableCardButtons() {
        //disables every cardButton
        for index in 0...15 {
            buttonsArray[index].isEnabled = false
        }
    }
    
    //Called when reveal all pressed and in clock func
    func disableUserInteracctionCardButtons() {
        //disables userInteraction of every cardButton
        for index in 0...15 {
            buttonsArray[index].isUserInteractionEnabled = false
        }
    }
    
    //called in comparing to score at the end of a regular mode game
    func scoringForRegularMode() {
        //code only executes when all cards have been matched and it is plaing in regular mode
        if regularMode && matchesMade == 8{
            //Score is determind by how many clicks it takes the user to finish the game
            switch clickCount {
            //As the clickCount increases the score halves
            case 16...20:
                score = pow(2,12)
            case 21...25:
                score = pow(2,11)
            case 26...30:
                score = pow(2,10)
            case 31...35:
                score = pow(2,9)
            case 36...40:
                score = pow(2,8)
            case 41...45:
                score = pow(2,7)
            case 46...50:
                score = pow(2,6)
            case 51...55:
                score = pow(2,5)
            case 56...60:
                score = pow(2,4)
            case 61...65:
                score = pow(2,3)
            case 66...70:
                score = pow(2,2)
            case 71...75:
                score = pow(2,1)
            case 76...80:
                score = pow(2,0)
            default:
                score = 0
            }
            
        //Score is displayed
        littleLabel.text = "Score: \(score) pts."
        littleLabel.isHidden = false
        
        //Message "Game Over!" is displayed
        bigLabel.text = "Game Over!"
        bigLabel.isHidden = false
        }
    }
    
    //called in comparing to determine the winner of a player vs. player mode game
    func scoringForPlayerVsPlayerMode() {
        //code only executes when all cards have been matched and it is player vs. player mode
        if playerVsPlayerMode && matchesMade == 8{
            //when player one's score is greater than player two's score display "Player One Wins!"
            if score > playerTwoScore {
                bigLabel.text = "Player One Wins!"
            //when player two's score is greater than player two's score display "Player Two Wins!"
            } else if score < playerTwoScore {
                    bigLabel.text = "Player Two Wins!"
            //when player one's score is the same as player two's score display "It was a Tie!"
            } else {
                bigLabel.text = "It was a Tie!"
            }
        }
    }
    
    //called in comparing to score at the end of a timer mode game
    func scoringForTimedMode() {
        //code only executes when all cards have been matched and it is playing in timer mode
        if timedMode && matchesMade == 8{
            //timer stops
            timer.invalidate()
            //Score is determind by how many seconds it takes the user to finish the game
            switch seconds {
            //As seconds increases the score halves
            case 56...60:
                score = pow(2,11)
            case 51...55:
                score = pow(2,10)
            case 46...50:
                score = pow(2,9)
            case 41...45:
                score = pow(2,8)
            case 36...40:
                score = pow(2,7)
            case 31...35:
                score = pow(2,6)
            case 26...30:
                score = pow(2,5)
            case 21...25:
                score = pow(2,4)
            case 16...20:
                score = pow(2,3)
            case 11...15:
                score = pow(2,2)
            case 6...10:
                score = pow(2,1)
            case 0...5:
                score = pow(2,0)
            default:
                score = 0
            }
            
            //Score is displayed
            littleLabelTwo.isHidden = false
            littleLabelTwo.text = "Score: \(score) pts."
            
            //Message "Game Over!" is displayed
            bigLabel.text = "You Won!"
            bigLabel.isHidden = false
        }
    }
    
    //called in aMode function and puts the elements of sortedDeck in a random order into shuffledDeck
    func shuffleRoutine() {
        //Ensures that shuffledDeck is empty
        shuffledDeck.removeAll()
        
        //Does this for each of the sixteen cards
        for _ in 1...16 {
            //randomlyGeneratedNumber becomes a random number between 0 and the numberOfElements -1 left in sortedDeck
            randomlyGeneratedNumber = Int(arc4random_uniform(upperLimit))
            //adds a random element from sortedDeck to shuffledDeck
            shuffledDeck.append(sortedDeck[randomlyGeneratedNumber])
            //removes the element that was just added to shuffledDeck
            sortedDeck.remove(at: randomlyGeneratedNumber)
            //upperLimit is decreased by 1 because the number of elements in sortedDeck has now decreased by one
            upperLimit -= 1
        }
        
        //resets upperLimit and sortedDeck so functions can be executed again
        sortedDeck = [#imageLiteral(resourceName: "bulgaria"), #imageLiteral(resourceName: "bulgaria"), #imageLiteral(resourceName: "gabon"), #imageLiteral(resourceName: "gabon"), #imageLiteral(resourceName: "hungary"), #imageLiteral(resourceName: "hungary"), #imageLiteral(resourceName: "german"), #imageLiteral(resourceName: "german"), #imageLiteral(resourceName: "netherlands"), #imageLiteral(resourceName: "netherlands"), #imageLiteral(resourceName: "luxembourg"), #imageLiteral(resourceName: "luxembourg"), #imageLiteral(resourceName: "yemen"), #imageLiteral(resourceName: "yemen"), #imageLiteral(resourceName: "sierraLeone"), #imageLiteral(resourceName: "sierraLeone")]
        upperLimit = 16
    }
    
    //called in comparing function and adds points to player who makes a match in player vs. player mode
    func vsMatch(){
        //Code only executes when in player vs. player mode
        if playerVsPlayerMode{
            //when it is player one's turn
            if playerOneTurn{
                //2^matchesInARow is added to player one's score
                score += pow(Decimal(2),matchesInARow)
                //display's new score
                littleLabelTwo.text = "Player One: \(score) pts."
            
            //when it is player twol's turn
            } else {
                //2^matchesInARow is added to player two's score
                playerTwoScore += pow(Decimal(2),matchesInARow)
                //display's new score
                littleLabel.text = "Player Two: \(playerTwoScore) pts."
            }
            
            //Increases number of matches in a row by one
            matchesInARow += 1
        }
    }
    
    //called in comparing function and switchs who's turn it is when no match is made in player vs. player mode
    func vsNoMatch(){
        //Code only executes when in player vs. player mode
        if playerVsPlayerMode{
            //resets matches to 0 because if this code is being executed a match has not been made
            matchesInARow = 0
            //if playerOneTurn is false it becomes true and if playerOneTurn is true it becomes false(turn is switched)
            playerOneTurn = !playerOneTurn
            
            //displays who's turn it is
            if playerOneTurn{
                bigLabel.text =  "Player One's Turn"
            } else {
                bigLabel.text =  "Player Two's Turn"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

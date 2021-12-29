//
//  startScreenViewControlerViewController.swift
//  Fleisig_Clara_memoryGame
//
//  Created by Clara Fleisig on 2017-12-03.
//  Copyright © 2017 Clara Fleisig. All rights reserved.
//

import UIKit

class startScreenViewControlerViewController: UIViewController {
    
    //Outlet of text field where user writes their name
    @IBOutlet weak var nameTextField: UITextField!
    
    //Executes code when start button is press
    @IBAction func startGameButton(_ sender: Any) {
        //Code will only execute when textfield contains text
        if nameTextField.text != ""{
            //Segue is performed
            performSegue(withIdentifier: "main to game", sender: self)
        }
    }
    
    //called to segue to ViewController.swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //specifies destination
        let playerNameEntered = segue.destination as! ViewController
        //puts string of text from stringTextField into a variable calld "playerName" in ViewController.swift
        playerNameEntered.playerName = nameTextField.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

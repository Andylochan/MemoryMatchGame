//
//  ViewController.swift
//  MemoryMatch
//
//  Created by Andy Lochan on 4/20/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

// I also custom made a AppIcon, Splash screen, and Card desgin for the game in Sketch.
// I allowed 30 moves (60 clicks) since anything else was a bit too hard. 10 mistakes allowed

import UIKit

class ViewController: UIViewController {
    
    let brain = MMmodel();
    var currentButton: UIButton? = nil;  //First Card Picked
    var prevButton: UIButton? = nil;     //Second Card Picked
    var currentTag: Int = 0;             //Assign value to card 1
    var previousTag: Int = 0;            //Assign value to card 2
    var flipped: Bool = false;           //Bool for card face
    var stat: Int = 0;                   //Flag for comparison
    
    @IBOutlet weak var lblMovesMade: UILabel! //Keep track of moves made
    @IBOutlet weak var lblMovesLeft: UILabel! //Keep track of moves left
    //Instead of a hidden label, I used a popup UI alert
    
    @IBAction func btnClick(_ sender: UIButton) {
        
         /* Example Code from Video
         var newLabel: String;
         var image: UIImage;
        
         if let label = sender.titleLabel!.text
         {
         print(label);
         newLabel = label;
         }
         else {newLabel = ""}
         
         if newLabel != ""
         {
         image = (UIImage( named: "pikachu.jpg") as UIImage?)!;
         newLabel = "";
         }
         else
         {
         image = UIImage();
         //newLabel = "Hello";
         }
         
         sender.setTitle(newLabel, for: UIControl.State.normal);
         
         sender.setBackgroundImage(image, for: UIControl.State.normal);
         */

        
        func flipCard(_ button: UIButton) -> String //Flip the card back/face
        {
            let tag = button.tag; //Take the tag number assigned to each button
            let emoji = brain.getEmoji(tagNum: tag)
            return emoji;
        }
        
        func win() //call if movesLeft >0 && all matches made
        {
            let result = brain.checkWin(); //Checks if all conditions are met in MMmodel, returns a bool
            if (result == true) //check if returned bool is true
            {
                let myAlert = UIAlertController(title: "You Win", message: nil, preferredStyle: UIAlertController.Style.alert); //Pop up on screen
                myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in self.returnRoot()})) //Click ok to close window
                self.present(myAlert, animated: true, completion: nil);
            }
        }
        
        func lose() //call when movesLeft == 0
        {
            let myAlert = UIAlertController(title: "You Lose", message: nil, preferredStyle: UIAlertController.Style.alert); //Pop up called if lblMoveLeft goes to 0
            myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in self.returnRoot()}))
            self.present(myAlert, animated: true, completion: nil);
        }
        
        func decMovesLeft() //decrement label after 2 cards are picked
        {
            var count: Int? = Int(lblMovesLeft.text!);
            count! -= 1;
            lblMovesLeft.text! = String(describing: count!);
            if (lblMovesLeft.text! == "0") //If you have 0 moves left, then call the lose() function popup
            {
                lose();
            }
        }
        
        //Notes
        /*if let movesString = lblMovesMade.text
         {
         var movesMade = Int(movesString)!;
         movesMade = movesMade + 1;
         lblMovesMade.text = String(movesMade);
         }*/
        
        func incMovesMade() //increment label
        {
            var count: Int? = Int(lblMovesMade.text!);
            count! += 1;
            lblMovesMade.text! = String(describing: count!);
        }
        
        let bgImage = sender.backgroundImage(for: UIControl.State.normal); //Use current bgImage
        
        if (stat == 0) // Card 1
        {
            sender.setBackgroundImage(nil, for: UIControl.State.normal)
            prevButton = sender;
            sender.setTitle(flipCard(prevButton!), for: UIControl.State.normal);
            stat += 1;
            previousTag = sender.tag;
        }
        else if (stat == 1) // Card 2
        {
            sender.setBackgroundImage(nil, for: UIControl.State.normal)
            currentButton = sender;
            sender.setTitle(flipCard(currentButton!), for: UIControl.State.normal);
            stat += 1;
            currentTag = sender.tag;
        }
        else // Compare Card 1 and Card 2, check for match, call every time 2 card are chosen
        {
            if (brain.isMatch(tag1: previousTag, tag2: currentTag))
            {
                sender.setBackgroundImage(nil, for: UIControl.State.normal);   //SetBackgroundImage
                decMovesLeft()
                incMovesMade()
                prevButton = sender;
                previousTag = prevButton!.tag;
                sender.setTitle(flipCard(prevButton!), for: UIControl.State.normal)
                stat = 1;
                win(); //Check for win status each time
            }
            else // No match --> Reset cards back to original state
            {
                currentButton?.setBackgroundImage(bgImage, for: UIControl.State.normal); // Reflip card down
                prevButton?.setBackgroundImage(bgImage, for: UIControl.State.normal); // Reflip card down
                currentButton?.setTitle(nil, for: UIControl.State.normal); // Make Emoji Dissapear
                prevButton?.setTitle(nil, for: UIControl.State.normal); // Make Emoji Dissapear
                decMovesLeft()
                incMovesMade()
                sender.setBackgroundImage(nil, for: UIControl.State.normal);
                prevButton = sender;
                previousTag = prevButton!.tag;
                sender.setTitle(flipCard(prevButton!), for: UIControl.State.normal)
                stat = 1;
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        brain.initializeGame(amount: [5,4]); //5 rows, 4 columns
        brain.printArray();                 //debugging
        lblMovesLeft.text! = String(30); // 30(pairs) tries left, 10 mistakes allowed
        lblMovesMade.text! = String(0); // Start point
    }
    
    func returnRoot() //Helper function for popup controller
    { _ = navigationController?.popViewController(animated: true);
        //viewDidLoad();
    }
    
    override func didReceiveMemoryWarning()
    {super.didReceiveMemoryWarning();}
    
}
        



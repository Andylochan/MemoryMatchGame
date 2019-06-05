//
//  MMmodel.swift
//  MemoryMatch
//
//  Created by Andy Lochan on 4/21/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

import Foundation

//1. Contain a struct of type node
struct Node { //Declare types
    var symbol: String; //a. String for emoji
    var matched: Bool; //b. Indicate if matched
    var count = 0; // Keep track of size/amount
    
    init(symbol: String, matched: Bool, count: Int ) //intialize variables
    {
        self.symbol = symbol;
        self.matched = matched;
        self.count = count;
    }
    
    init() //set default values for variables
    {
        self.symbol = ""; //Empty string to be loaded with emoji
        self.matched = false; //default flag unless set true
        self.count = 0; //Keep track of amount set
    }
}

//2. Class for the gameplay
class MMmodel{
    var emojis: [String]; // An array container for emoji's of type String
    var gameDec: Bool; // Bool status condition for overall game state
    var gameArray: [[Node]]; //a. 2D array of type Node
    var nodeArray: [Node];
    var size: [Int];
    
    init()
    {
        self.emojis = ["🙈", "👀", "🐍", "🍓", "😭", "👌", "🛩", "🔫", "🐙", "🍤"] //Emojis for card faces, 2 each
        self.gameDec = false; //always false unless all matches are made
        self.gameArray = [[Node]]() //2d row/column of type Node
        self.nodeArray = [Node]()
        self.size = [Int]()
    }
    
    init(gameDec:Bool, emojis:[String], gameArr:[[Node]], nodeArray:[Node], sizeArray:[Int] )
    {
        self.gameDec = gameDec; //Ititialize Vars in class head
        self.emojis = emojis;
        self.gameArray = gameArr;
        self.nodeArray = nodeArray;
        self.size = sizeArray;
    }
    
    func genArrNode(arr:[String]) //c. Created an array of nodes
    {
        for i in 0..<arr.count {
            var node = Node();
            node.symbol = arr[i];
            node.matched = false;
            nodeArray.append(node);
        }
    }
    
    func randomNum(array:[String]) -> Int //Randomize the selection of emojis
    {
        let index = Int(arc4random_uniform(UInt32(array.count)));
        return index; //Return random number bounded by array size
    }
    
    func printArray() //e. Print function for debugging
    {
        for i in 0 ..< size[0]{ //i rows
            for j in 0 ..< size[1] // j columns
            {print(gameArray[i][j].symbol);} //Print ixj grid
        }
    }
    
    func getEmoji(tagNum:Int) -> String //f. Return an emoji given tag number
    {
        let column = tagNum%size[1]; //j
        let row = tagNum%size[0]; //i
        return gameArray[row][column].symbol; //Return the emoji at the grid coordinate
    }
    
    func setEmoji() -> String // Return an emoji as a String
    {
        let index = randomNum(array: emojis); //assign a random value out of 10 to identify emoji pairs
        return emojis[index];
    }
    
    func initializeGame(amount: [Int]) //b. Generate the game board grid randomly of size: [i,j]
    {
        size = amount;
        genArrNode(arr: emojis);
        let matches = (size[0]*size[1]) / 2; //4X5 / 2 = 10 matches
        var node = Node();
        
        for _ in 0 ..< size[0]  //all elements in i rows
        {
            var row = [Node]();
            for _ in 0 ..< size[1] //all elements in j columns
            {
                let index = Int(arc4random_uniform(UInt32(matches))); //Randomized choice out of 10 matches
                node = nodeArray[index];
                nodeArray[index].count += 1; //Increment count to 1
                node.count = nodeArray[index].count;
                
                while(node.count > 2) //set 2nd node, no more than 2 of the same
                {
                    let index = Int(arc4random_uniform(UInt32(matches))); //Randomized choice out of 10 matches
                    node = nodeArray[index];
                    nodeArray[index].count += 1; //Increment count to 2
                    node.count = nodeArray[index].count;
                }
                row.append(node); //Append row into Node array
            }
            gameArray.append(row); //Append row into gameArray
        }
    }
    
    func isMatch(tag1:Int, tag2:Int) -> Bool //Check if tag 1 and tag 2 are equivalent, return boolean state
    {
        let matches = (size[0]*size[1]) / 2; // 4X5 / 2 = 10 matches
        if (getEmoji(tagNum: tag1) == getEmoji(tagNum: tag2)) //i. Check if two items match
        {
            for index in 0 ..< matches { // for random index from 0 to 10
                if(nodeArray[index].symbol == getEmoji(tagNum: tag1))
                {
                    nodeArray[index].matched = true; //ii. Set their values in the struct to true
                }
            }
            return true; // they are a match
        }
        else
        {
            return false; //iii. if they do not match, return false
        }
    }
    
    
    func checkWin() -> Bool //i. check board for a win
    {
        let matches = (size[0]*size[1])/2; //set matches to (4x5)/2=10 matches
        for index in 0 ..< matches {            //check each case
            if(nodeArray[index].matched == false){  //iii. if not all are true, then return false
                return false;
            }
        }
        return true; //ii. else return true if none are false, this is the win state. Return func win() in ViewController
    }
    
}

//
//


//
//  ViewController.swift
//  MyNote
//
//  Created by Jake Saferstein on 2/6/16.
//  Copyright © 2016 Jake Saferstein. All rights reserved.
//

import UIKit
import GameController
import VirtualGameController

class ViewController: UIViewController {
    
    var textView : UILabel! = UILabel()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        textView.text = "The most meme-worthy blackboard"
        textView.font =  UIFont.systemFontOfSize(100)
        textView.adjustsFontSizeToFitWidth = true
        textView.backgroundColor = UIColor(red: 59/255, green: 101/255, blue: 61/255, alpha: 1)
        textView.frame = self.view.bounds
        self.view.addSubview(textView)
        
        VgcManager.startAs(.Central, appIdentifier: "MyNote")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "controllerConnected", name:GCControllerDidConnectNotification, object: nil);
        VgcController.startWirelessControllerDiscoveryWithCompletionHandler { () -> Void in

            if VgcController.controllers().count == 0 {
                NSLog("No controllers")
                self.textView.text = "No controllers"
            }
        }
        
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//            selector:@selector(didReceivePoseChange:)
//        name:TLMMyoDidReceivePoseChangedNotification
//        object:nil];
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceivePoseChange:", name:TLMMyoDidReceivePoseChangedNotification, object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerConnected()
    {
        NSLog("%@", VgcController.controllers().debugDescription)
        
        guard let firstCtrlr = VgcController.controllers().first else {
            
            NSLog("Error getting first controller which is dumb b/c a controller just connnected.");
            textView.text = "Error getting first controller which is dumb b/c a controller just connnected."
            return
        }
        
        firstCtrlr.playerIndex = GCControllerPlayerIndex.Index1
        NSLog("Got controlller")
        textView.text = "Got controller"
    }
//
//    func didReceivePoseChange()
//    {
//        NSLog("Did get pose change")
//    }


}


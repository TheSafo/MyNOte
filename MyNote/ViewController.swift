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
    var ctrlr : VgcController?
    var pointerVw : UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textView.text = "The most meme-worthy blackboard"
        textView.font =  UIFont.systemFontOfSize(100)
        textView.adjustsFontSizeToFitWidth = true
        textView.backgroundColor = UIColor(red: 59/255, green: 101/255, blue: 61/255, alpha: 1)
        textView.frame = self.view.bounds
        self.view.addSubview(textView)
        
        pointerVw.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        pointerVw.backgroundColor = UIColor.redColor()
        self.view.addSubview(pointerVw)
        
        VgcManager.startAs(.Central, appIdentifier: "vgc", customElements: CustomElements(), customMappings: CustomMappings(), includesPeerToPeer: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "controllerConnected:", name:GCControllerDidConnectNotification, object: nil);
        
        VgcController.startWirelessControllerDiscoveryWithCompletionHandler { () -> Void in

            if VgcController.controllers().count == 0 {
                NSLog("No controllers")
                self.textView.text = "No controllers"
            }
        }
        
        Elements.customElements.valueChangedHandler = { (controller, element:Element) in
            
            if element.identifier == 102
            {
                if let val = element.value as? String
                {
                    NSLog("Got new point %@", val)
                    
                    let xyPercents = CGPointFromString(val)
                    
                    self.pointerVw.frame = CGRect(x: (xyPercents.x/100.0) * self.view.frame.size.width, y: (xyPercents.y/100.0) * self.view.frame.size.height,
                        width: self.pointerVw.frame.size.width, height: self.pointerVw.frame.size.height)
                }
            }
        }
    }
    
    func receivedPlayerIndex(notif:NSNotification)
    {
        NSLog("Recieved index")
    }

    func controllerConnected(notif:NSNotification)
    {
        NSLog("CONTROLLER CONNECTED CALLED: WITH %i CONTROLLERS", VgcController.controllers().count)
        
        guard let firstCtrlr = VgcController.controllers().first else {
            
            NSLog("Error getting first controller which is dumb b/c a controller just connnected.");
            textView.text = "Error getting first controller which is dumb b/c a controller just connnected."
            return
        }
        
        firstCtrlr.playerIndex = GCControllerPlayerIndex.Index2
        NSLog("Got remote connected")
        textView.text = "Got remote connected"

        if VgcController.controllers().count > 1
        {
            let scndCtrlr = VgcController.controllers()[1]
            scndCtrlr.playerIndex = GCControllerPlayerIndex.Index1
            NSLog("Got controlller")
            textView.text = "Got controller"
            ctrlr = scndCtrlr
        }
    }
}


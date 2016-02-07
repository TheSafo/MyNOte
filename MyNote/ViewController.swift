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
    
    enum CurrentMode: Int {
        
        case PointerMode = 0
        case DrawMode = 1
        case EraseMode = 2
    }
    
    let thresh = CGFloat(0.005) //.5% of the screen must be moved to move
    
    var textView : UILabel! = UILabel()
    var pointerVw : UIView = UIView()
    var drawingVw : UIImageView = UIImageView()
    var bgVw : UIImageView = UIImageView()
    var curImg : Int = 1
    
    var ctrlr : VgcController?
    
    var curMode :CurrentMode = .PointerMode
    var lastPt : CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        textView.text = "The most meme-worthy blackboard"
//        textView.font =  UIFont.systemFontOfSize(100)
//        textView.adjustsFontSizeToFitWidth = true
//        textView.backgroundColor = UIColor(red: 59/255, green: 101/255, blue: 61/255, alpha: 1)
//        textView.frame = self.view.bounds
//        self.view.addSubview(textView)
//        self.view.backgroundColor = UIColor(red: 59/255, green: 101/255, blue: 61/255, alpha: 1)
        
        bgVw.frame = self.view.bounds
        bgVw.image = UIImage(named: String(format: "Slide%i", curImg))
        self.view .addSubview(bgVw)
        
        drawingVw.frame = self.view.bounds
        drawingVw.backgroundColor = UIColor.clearColor()
        self.view .addSubview(drawingVw)
        
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
//                    NSLog("Got new point %@", val)
                    let w = self.view.frame.size.width
                    let h = self.view.frame.size.height
                    
                    let xyPercents = CGPointFromString(val)
                    let curPt = CGPoint(x:(xyPercents.x/100.0) * w, y: (xyPercents.y/100.0) * h)
                    
                    let maxX = self.lastPt.x + (self.thresh * w)
                    let minX = self.lastPt.x - (self.thresh * w)
                    let maxY = self.lastPt.y + (self.thresh * h)
                    let minY = self.lastPt.y - (self.thresh * h)
                    
                    if (curPt.x > minX && curPt.x < maxX) && (curPt.y > minY && curPt.y < maxY)
                    {
//                        NSLog("Too little movement since last point")
                        return
                    }
                    
                    self.pointerVw.frame = CGRect(x: curPt.x, y: curPt.y, width: self.pointerVw.frame.size.width, height: self.pointerVw.frame.size.height)
                    
                    if self.curMode == .DrawMode
                    {
                        NSLog("Drawing")
                        UIGraphicsBeginImageContext(self.drawingVw.frame.size);
                        self.drawingVw.image?.drawInRect(CGRect(x: 0, y: 0, width: self.drawingVw.bounds.size.width, height: self.drawingVw.bounds.size.height))
                        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPt.x, self.lastPt.y);
                        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), curPt.x, curPt.y);
//                        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCapRound);
                        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 25);
                        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0/255, 0/255, 0/255, 1.0);
//                        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
//                        
                        CGContextStrokePath(UIGraphicsGetCurrentContext());
                        self.drawingVw.image = UIGraphicsGetImageFromCurrentImageContext();
//                        [self.tempDrawImage setAlpha:opacity];
                        UIGraphicsEndImageContext();
                    }
                    else if self.curMode == .EraseMode
                    {
                        NSLog("Erase")
                        UIGraphicsBeginImageContext(self.drawingVw.frame.size);
                        self.drawingVw.image?.drawInRect(CGRect(x: 0, y: 0, width: self.drawingVw.bounds.size.width, height: self.drawingVw.bounds.size.height))
                        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPt.x, self.lastPt.y);
                        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), curPt.x, curPt.y);
                        //                        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCapRound);
                        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 50);
                        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0/255, 0/255, 0/255, 0);
                                                CGContextSetBlendMode(UIGraphicsGetCurrentContext(), CGBlendMode.Clear);
                        //
                        CGContextStrokePath(UIGraphicsGetCurrentContext());
                        self.drawingVw.image = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                    }
                    
                    self.lastPt = curPt
                }
            }
            else if element.identifier == 103
            {
                if let val = element.value as? String
                {
                    NSLog("Got pose update to %@", val)
                    
                    if val == "Rest"
                    {
                        self.curMode = .PointerMode
                    }
                    else if val == "Fist"
                    {
                        self.curMode = .DrawMode
                    }
                    else if val == "FingersSpread"
                    {
                        self.curMode = .EraseMode
                    }
                    else if val == "DoubleTap"
                    {
                        //TODO: SLIDE SHOW STUFF
                        self.curMode = .PointerMode
                        
                        self.curImg++
                        
                        if self.curImg > 8
                        {
                            self.curImg == 1
                        }
                        
                        self.bgVw.image = UIImage(named: String(format: "Slide%i", self.curImg))
                        self.drawingVw.image = UIImage()
                    }
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


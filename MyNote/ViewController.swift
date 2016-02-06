//
//  ViewController.swift
//  MyNote
//
//  Created by Jake Saferstein on 2/6/16.
//  Copyright © 2016 Jake Saferstein. All rights reserved.
//

import UIKit
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
//    
//    func didReceivePoseChange()
//    {
//        NSLog("Did get pose change")
//    }


}


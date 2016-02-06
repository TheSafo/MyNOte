//
//  ViewController.swift
//  MyNotePhone
//
//  Created by Jake Saferstein on 2/6/16.
//  Copyright © 2016 Jake Saferstein. All rights reserved.
//

import UIKit
import VirtualGameController


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        VgcManager.startAs(.Peripheral, appIdentifier: "MyNote", customElements: CustomElements(), customMappings: CustomMappings(), includesPeerToPeer: true)
        VgcManager.peripheral.browseForServices()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foundService", name: VgcPeripheralFoundService, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func foundService()
    {
        guard let firstService = VgcManager.peripheral.availableServices.first else
        {
            NSLog("No service actually found???")
            return
        }
        
        VgcManager.peripheral.connectToService(firstService)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peripheralDidConnect", name: VgcPeripheralDidConnectNotification, object: nil)
    }

    func peripheralDidConnect()
    {
        NSLog("Peripheral connected")
    }
}


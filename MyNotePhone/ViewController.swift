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
    
    var didConnect = false
    
    /*
    // Pushing it on an existing navigation controller
    - (void)pushMyoSettings {
    TLMSettingsViewController *settings = [[TLMSettingsViewController alloc] init];
    
    [self.navigationController pushViewController:settings animated:YES];
    }
    
    // Presenting modally
    - (void)modalPresentMyoSettings {
    UINavigationController *settings = [TLMSettingsViewController settingsInNavigationController];
    
    [self presentViewController:settings animated:YES completion:nil];
    }
    
    // Presenting in a Popover (iPad only)
    - (void)popoverPresentMyoSettings {
    // Make sure to hold a strong reference to your popover so it doesn't get dealloc'ed when it's presented.
    self.popover = [TLMSettingsViewController settingsInPopoverController];
    
    [self.popover presentPopoverFromBarButtonItem:settingsButton
    permittedArrowDirections:UIPopoverArrowDirectionAny
    animated:YES];
    }
*/

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        VgcManager.startAs(.Peripheral, appIdentifier: kAppKey, customElements: CustomElements(), customMappings: CustomMappings(), includesPeerToPeer: true)
        VgcManager.peripheral.browseForServices()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foundService", name: VgcPeripheralFoundService, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didRecieveOrientationEvent:", name: TLMMyoDidReceiveOrientationEventNotification, object: nil)
        

    }
    
    override func viewDidAppear(animated: Bool) {
//        let ctrlr :TLMSettingsViewController = TLMSettingsViewController()
//        self.presentViewController(ctrlr, animated: true) { () -> Void in
//            NSLog("Presented")
//        }
        
//        while !didConnect
//        {
//            TLMHub.sharedHub().attachToAdjacent()
//            NSLog("Tried to attach")
//            sleep(5)
//        }
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

    func didRecieveOrientationEvent(notif : NSNotification)
    {
        didConnect = true
        
        guard let event = notif.userInfo![kTLMKeyOrientationEvent] else
        {
            return
        }
        
        if let typedEvent = event as? TLMOrientationEvent
        {
            let quat = typedEvent.quaternion
            let eulers = TLMEulerAngles(quaternion: quat)
            
            let CalibrationYaw = 90.0
            let CalibrationPitch = 0.0
            //pitch defines y, yaw defines x
            let MaxYawChange = 60.0
            let MaxPitchChange = 45.0
            
            var CurrentYaw = eulers.yaw.degrees
            var CurrentPitch = eulers.pitch.degrees
            
            //limit pitch and yaw to +- their max quantities
            if (CurrentYaw-CalibrationYaw)>MaxYawChange{
                CurrentYaw = MaxYawChange+CalibrationYaw
            }
            if (CurrentYaw-CalibrationYaw) < (-1.0)*MaxYawChange{
                CurrentYaw = -MaxYawChange+CalibrationYaw
            }
            if (CurrentPitch-CalibrationPitch)>MaxPitchChange{
                CurrentPitch = MaxPitchChange+CalibrationPitch
            }
            if (CurrentPitch-CalibrationPitch) < (-1.0)*MaxPitchChange{
                CurrentPitch = -MaxPitchChange+CalibrationPitch
            }
            let x = 50.0 + 50.0*(CurrentYaw-CalibrationYaw)/MaxYawChange
            let y = 50.0 + 50.0*(CurrentPitch-CalibrationPitch)/MaxPitchChange
//            let quat = event.quaternion
            NSLog("Got x,y : %f, %f", x,y)
        }
        else
        {
            
        }
    }
}


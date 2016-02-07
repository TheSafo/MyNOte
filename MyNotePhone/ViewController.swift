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
        
    @IBOutlet var debugLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        VgcManager.startAs(.Peripheral, appIdentifier: "vgc", customElements: CustomElements(), customMappings: CustomMappings(), includesPeerToPeer: true)
        VgcManager.peripheral.browseForServices()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foundService", name: VgcPeripheralFoundService, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didRecieveOrientationEvent:", name: TLMMyoDidReceiveOrientationEventNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didRecievePoseChangeEvent:", name: TLMMyoDidReceivePoseChangedNotification, object: nil)
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
    
    func didRecievePoseChangeEvent(notif :NSNotification)
    {
        guard let pose = notif.userInfo![kTLMKeyPose] else
        {
            NSLog("Memed by a pose change notif")
            return
        }
        
        if let typedPose = pose as? TLMPose
        {
            var toSend:String = ""
            switch(typedPose.type)
            {
                case(TLMPoseType.Rest):
                    NSLog("Rest")
                    toSend = "Rest"
                case(TLMPoseType.Fist):
                    NSLog("Fist")
                    toSend = "Fist"
                case(TLMPoseType.FingersSpread):
                    NSLog("Fingers spread")
                    toSend = "FingersSpread"
                case(TLMPoseType.DoubleTap):
                    NSLog("Double tap")
                    toSend = "DoubleTap"
                default:
                    NSLog("Ignore")
                    toSend = "Ignore"
            }
            
            VgcManager.elements.custom[CustomElementType.Gesture.rawValue]?.value = toSend
            let eleToSend = VgcManager.elements.custom[CustomElementType.Gesture.rawValue]
            VgcManager.peripheral.sendElementState(eleToSend!)
        }
        else
        {
            NSLog("Pose couldnt be typed for some weird meme-son")
        }
    }

    func didRecieveOrientationEvent(notif : NSNotification)
    {
        guard let event = notif.userInfo![kTLMKeyOrientationEvent] else
        {
            NSLog("Memed by a orientation notif")
            return
        }
        
        if let typedEvent = event as? TLMOrientationEvent
        {
            let quat = typedEvent.quaternion
            let eulers = TLMEulerAngles(quaternion: quat)
            
            let CalibrationYaw = -90.0
            let CalibrationPitch = 0.0
            //pitch defines y, yaw defines x
            let MaxYawChange = 60.0
            let MaxPitchChange = 45.0
            
            var CurrentYaw = eulers.yaw.degrees
            var CurrentPitch = eulers.pitch.degrees
            
            //limit pitch and yaw to +- their max quantities
            if (CurrentYaw - CalibrationYaw) > MaxYawChange
            {
                CurrentYaw = MaxYawChange+CalibrationYaw
            }
            if (CurrentYaw - CalibrationYaw) < (-1.0)*MaxYawChange
            {
                CurrentYaw = -MaxYawChange+CalibrationYaw
            }
            if (CurrentPitch-CalibrationPitch) > MaxPitchChange
            {
                CurrentPitch = MaxPitchChange+CalibrationPitch
            }
            if (CurrentPitch-CalibrationPitch) < (-1.0)*MaxPitchChange
            {
                CurrentPitch = -MaxPitchChange+CalibrationPitch
            }
            
            var x = 50.0 - 50.0*((CurrentYaw-CalibrationYaw)%360)/MaxYawChange
            let y = 50.0 - 50.0*((CurrentPitch-CalibrationPitch)%360)/MaxPitchChange
            

//            NSLog("Got x,y : %f, %f", x,y)
            debugLbl.text = String(format: "%f, %f", arguments: [x,y])
            
            let pointXY = CGPoint(x: x, y: y)
            let toSend = NSStringFromCGPoint(pointXY)
            
            VgcManager.elements.custom[CustomElementType.PointerXY.rawValue]?.value = toSend
            let eleToSend = VgcManager.elements.custom[CustomElementType.PointerXY.rawValue]
            VgcManager.peripheral.sendElementState(eleToSend!)
        }
        else
        {
            
        }
    }
}


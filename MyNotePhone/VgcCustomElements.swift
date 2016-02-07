//
//  VgcCustomElements.swift
//  MyNote
//
//  Created by Jake Saferstein on 2/6/16.
//  Copyright © 2016 Jake Saferstein. All rights reserved.
//

import Foundation
import VirtualGameController

///
/// Create a case for each one of your custom elements, along with a raw value in
/// the range shown below (to prevent collisions with the standard elements).

public enum CustomElementType: Int {

    case PointerXY = 102
    case Gesture = 103
}

///
/// Your customElements class must descend from CustomElementsSuperclass
///
public class CustomElements: CustomElementsSuperclass {
    
    override init() {
        
        super.init()
        
        ///
        /// CUSTOMIZE HERE
        ///
        /// Create a constructor for each of your custom elements.
        ///
        /// - parameter name: Human-readable name, used in logging
        /// - parameter dataType: Supported types include .Float, .String and .Int
        /// - parameter type: Unique identifier, numbered beginning with 100 to keep them out of collision with standard elements
        ///
        
        customProfileElements = [
            CustomElement(name: "Pointer XY", dataType: .String, type:CustomElementType.PointerXY.rawValue),
            CustomElement(name: "Gesture", dataType: ElementDataType.String, type:CustomElementType.Gesture.rawValue)
        ]
        
    }
    
}
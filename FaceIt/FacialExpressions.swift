//
//  FacialExpressions.swift
//  FaceIt
//
//  Created by Ali Abbas Jaffri on 18/05/2016.
//  Copyright © 2016 Ali Abbas Jaffri. All rights reserved.
//

import Foundation

struct FacialExpressions
{
    var eyes : Eyes
    var eyeBrows : Eyebrows
    var mouth : Mouth
    
    enum Eyes : Int
    {
        case Open
        case Close
        case Squint
    }
    
    enum Eyebrows : Int
    {
        case Relaxed
        case Normal
        case Furrowed
        
        func moreRelaxedBrow() -> Eyebrows {
            return Eyebrows(rawValue: rawValue - 1) ?? .Relaxed
        }
        
        func moreFurrowedBrow() -> Eyebrows {
            return Eyebrows(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    
    enum Mouth : Int
    {
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        
        func sadderMouth() -> Mouth
        {
            return Mouth(rawValue : rawValue  - 1) ?? .Frown
        }
        
        func happierMouth() -> Mouth
        {
            return Mouth(rawValue : rawValue  + 1) ?? .Smile
        }
    }
    
}
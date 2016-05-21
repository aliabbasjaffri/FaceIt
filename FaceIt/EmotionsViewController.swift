//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Ali Abbas Jaffri on 21/05/2016.
//  Copyright © 2016 Ali Abbas Jaffri. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController
{
    private let emotionalFaces: Dictionary<String , FacialExpressions> = [
        "Angry" : FacialExpressions(eyes: .Close , eyeBrows: .Furrowed , mouth: .Frown),
        "Happy" : FacialExpressions(eyes: .Open , eyeBrows: .Normal , mouth: .Smile),
        "Worried" : FacialExpressions(eyes: .Open , eyeBrows: .Relaxed , mouth: .Smirk),
        "Mischievious" : FacialExpressions(eyes: .Open , eyeBrows: .Furrowed , mouth: .Grin),
    ]
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let destinationViewController =  segue.destinationViewController
        if let faceViewController = destinationViewController as? FaceViewController
        {
            if let identifier = segue.identifier
            {
                if let expression = emotionalFaces[identifier]
                {
                    faceViewController.expression = expression
                }
            }
        }
    }
}

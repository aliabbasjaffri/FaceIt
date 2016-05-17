//
//  ViewController.swift
//  FaceIt
//
//  Created by Ali Abbas Jaffri on 16/05/2016.
//  Copyright © 2016 Ali Abbas Jaffri. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController
{
    @IBOutlet weak var faceView: FaceView! { didSet{ updateUI() } }
    
    var expressions = FacialExpressions(eyes: .Close, eyeBrows: .Normal , mouth: .Smile) { didSet{ updateUI() } }
    
    private var mouthCurvatures = [ FacialExpressions.Mouth.Frown : -1.0, .Smirk: 0.5, .Neutral: 0.0, .Grin : 0.5, .Smile : 1.0 ]
    private var eyeBrowTilts = [ FacialExpressions.Eyebrows.Relaxed : 0.5 , .Furrowed : -0.5 , .Normal : 0.0 ]
    
    private func updateUI()
    {
        switch expressions.eyes
        {
            case .Open: faceView.eyesOpen = true
            case .Close : faceView.eyesOpen = false
            case .Squint : faceView.eyesOpen = false
        }
        faceView.mouthCurvature = CGFloat(mouthCurvatures[expressions.mouth] ?? 0.0)
        faceView.eyeBrowTilt = eyeBrowTilts[expressions.eyeBrows] ?? 0.0
    }

}


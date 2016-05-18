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
    @IBOutlet weak var faceView: FaceView! {
        didSet
        {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(_:))))
            
            let happySwipeView = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))
            happySwipeView.direction = .Up
            faceView.addGestureRecognizer(happySwipeView)
            
            let sadderSwipeView = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseSadness))
            sadderSwipeView.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeView)
            
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(recognizer: UITapGestureRecognizer)
    {
        if recognizer.state == .Ended
        {
            switch expressions.eyes
            {
                case .Open: expressions.eyes = .Close
                case .Close: expressions.eyes = .Open
                case .Squint: break
            }
        }
        
    }
    
    var expressions = FacialExpressions(eyes: .Open, eyeBrows: .Relaxed , mouth: .Smirk) { didSet{ updateUI() } }
    
    private var mouthCurvatures = [ FacialExpressions.Mouth.Frown : -1.0, .Smirk: 0.5, .Neutral: 0.0, .Grin : 0.5, .Smile : 1.0 ]
    private var eyeBrowTilts = [ FacialExpressions.Eyebrows.Relaxed : 0.5 , .Furrowed : -0.5 , .Normal : 0.0 ]
    
    func increaseHappiness()
    {
        expressions.mouth = expressions.mouth.happierMouth()
    }
    
    func increaseSadness()
    {
        expressions.mouth = expressions.mouth.sadderMouth()
    }
    
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


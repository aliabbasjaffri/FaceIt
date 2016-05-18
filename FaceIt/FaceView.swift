//
//  FaceView.swift
//  FaceIt
//
//  Created by Ali Abbas Jaffri on 16/05/2016.
//  Copyright © 2016 Ali Abbas Jaffri. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { self.setNeedsLayout() } }
    
    @IBInspectable
    var mouthCurvature : CGFloat = 1.0 { didSet { self.setNeedsLayout() } }
    
    @IBInspectable
    var eyeBrowTilt : Double = 0.0 { didSet { self.setNeedsLayout() } }
    
    @IBInspectable
    var eyesOpen: Bool = true { didSet { self.setNeedsLayout() } }
    
    @IBInspectable
    var color : UIColor = UIColor.blueColor() { didSet { self.setNeedsLayout() } }
    
    @IBInspectable
    var lineWidth : CGFloat = 5.0 { didSet { self.setNeedsLayout() } }
    
    func changeScale(recognizer:UIPinchGestureRecognizer)
    {
        switch recognizer.state
        {
            case .Changed, .Ended:
                scale *= recognizer.scale
                recognizer.scale = 1.0
            default: break
        }
    }
    
    private var faceRadius: CGFloat{
       return min(bounds.size.width , bounds.size.height) / 2 * scale
    }
    private var faceCenter: CGPoint{
     return CGPoint(x:bounds.midX , y:bounds.midY)
    }
    
    private enum Eye
    {
        case LeftEye
        case RightEye
    }
    
    private func pathForCircleCenteredAtPoint(centerPoint: CGPoint , withRadius radius: CGFloat) -> UIBezierPath
    {
        let path =  UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint
    {
        let eyeOffset = faceRadius / Ratios.FaceRadiusToEyeOffset
        var eyeCenter = faceCenter
        
        eyeCenter.y -= eyeOffset
        
        switch eye
        {
            case .LeftEye : eyeCenter.x -= eyeOffset
            case .RightEye : eyeCenter.x += eyeOffset
        }
        
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath
    {
        let eyeRadius = (faceRadius / Ratios.FaceRadiusToEyeRadius)
        let eyeCenter = getEyeCenter(eye)
        
        if eyesOpen
        {
            return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
        }
        else
        {
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLineToPoint(CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = faceRadius / Ratios.FaceRadiusToMouthWidth
        let mouthHeight = faceRadius / Ratios.FaceRadiusToMouthHeight
        let mouthOffset = faceRadius / Ratios.FaceRadiusToMouthOffset
        
        let mouthRect = CGRect(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1 , min(mouthCurvature , 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let controlPointOne = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let controlPointTwo = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: controlPointOne, controlPoint2: controlPointTwo)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath
    {
        var tilt = eyeBrowTilt
        switch eye
        {
            case .LeftEye : tilt *= -1
            case .RightEye : break
        }
        
        var browCenter = getEyeCenter(eye)
        browCenter.y -= faceRadius / Ratios.FaceRadiusToBrowOffset
        
        let eyeRadius = faceRadius / Ratios.FaceRadiusToBrowOffset
        let tiltOffset = CGFloat(max(-1 , min(tilt , 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        
        let path = UIBezierPath()
        path.moveToPoint(browStart)
        path.addLineToPoint(browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect)
    {
        color.set()
        pathForCircleCenteredAtPoint(faceCenter, withRadius: faceRadius).stroke()
        pathForEye(.LeftEye).stroke()
        pathForEye(.RightEye).stroke()
        pathForMouth().stroke()
        pathForBrow(.LeftEye).stroke()
        pathForBrow(.RightEye).stroke()
    }
    
    private struct Ratios
    {
        static let FaceRadiusToEyeOffset: CGFloat = 3
        static let FaceRadiusToEyeRadius: CGFloat = 10
        static let FaceRadiusToMouthWidth: CGFloat = 1
        static let FaceRadiusToMouthHeight: CGFloat = 3
        static let FaceRadiusToMouthOffset: CGFloat = 3
        static let FaceRadiusToBrowOffset: CGFloat = 5
    }
}

//
//  FaceView.swift
//  FaceIt
//
// 

import UIKit
@IBDesignable
class FaceView: UIView
{
    @IBInspectable
    var scale: CGFloat = 0.90{didSet{setNeedsDisplay()}}
   
    @IBInspectable
    var mouthCurvature: Double = 1.0{didSet{setNeedsDisplay()}} // 1 full smile, -1 full frown
   
    @IBInspectable
    var eyesOpen:Bool=false{didSet{setNeedsDisplay()}}
   
    @IBInspectable
    var eyeBrowTilt:CGFloat=0.0{didSet{setNeedsDisplay()}} // 1 full furrow, 0 fully relaxed
   
    @IBInspectable
    var color:UIColor=UIColor.blue{didSet{setNeedsDisplay()}}
    
    func changeScale(recognizer:UIPinchGestureRecognizer)
    {
        switch recognizer.state {
        case .changed,.ended:
            scale*=recognizer.scale
            recognizer.scale=1.0
        default:
            break
        }
    }
    
    fileprivate var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    fileprivate var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    fileprivate struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let browTilt: CGFloat = 3

    }
    
    fileprivate enum Eye {
        case left
        case right
    }

    fileprivate func pathForCircleCenteredAtPoint(_ midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false
        )
        path.lineWidth = 5.0
        return path
    }
    
    fileprivate func getEyeCenter(_ eye: Eye) -> CGPoint
    {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .left: eyeCenter.x -= eyeOffset
        case .right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    fileprivate func pathForEye(_ eye: Eye) -> UIBezierPath
    {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        if eyesOpen {
            return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
        }else{
            let start=CGPoint(x:eyeCenter.x-eyeRadius,y:eyeCenter.y)
            let end=CGPoint(x:eyeCenter.x+eyeRadius,y:eyeCenter.y)
            let path=UIBezierPath()
            path.move(to:start)
            path.addLine(to: end)
            path.lineWidth=5
            return path
        }
    }
    
    fileprivate func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset

        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        
        return path
    }
    
    fileprivate func pathForBrow(eye:Eye)->UIBezierPath
    {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        let tiltOffset=CGFloat(40)*scale
        let frownTilt=10 * scale * (max(-1, min(eyeBrowTilt, 1)))
        var start=CGPoint(x:eyeCenter.x-eyeRadius,y:eyeCenter.y-tiltOffset)
        var end=CGPoint(x:eyeCenter.x+eyeRadius,y:eyeCenter.y-tiltOffset)
        switch eye {
        case .left:
            end.y+=frownTilt
            
        case .right:
            start.y+=frownTilt
        }
        
        let path=UIBezierPath()
        path.move(to:start)
        path.addLine(to: end)
        path.lineWidth=5
        return path

        
    }
    override func draw(_ rect: CGRect)
    {
        color.set()
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
        pathForBrow(eye: .left).stroke()
        pathForBrow(eye: .right).stroke()
    }
}
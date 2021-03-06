//
//  FaceIt
//
//

import UIKit

class FaceViewController: UIViewController
{
    var expression = FacialExpression(eyes:.Open,eyeBrows:.Relaxed,mouth:.Frown){
        didSet{
        updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView!{
        //Note: Outlets are not set in prepareSegue methiod
        didSet{
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(faceView.changeScale(recognizer:))))
       
            let happierSwipeGesture=UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            happierSwipeGesture.direction = .up
            faceView.addGestureRecognizer(happierSwipeGesture)
            
            let sadderSwipeGesture=UISwipeGestureRecognizer(target: self, action: #selector(increaseSadness))
            sadderSwipeGesture.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGesture)
            updateUI()
        }
        
    }
    
    func increaseHappiness()
    {
    expression.mouth=expression.mouth.happierMouth()
        
    }
   
    func increaseSadness()
    {
        expression.mouth=expression.mouth.sadderMouth()
        
    }
    
    private func updateUI() {
        if(faceView != nil){
        switch expression.eyes {
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
        }
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = CGFloat(eyeBrowTilts[expression.eyeBrows] ?? 0.0)
        }
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown:-1.0,.Grin:0.5,.Smile:1.0,.Smirk:-0.5,.Neutral:0.0 ]
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed:-0.5,.Furrowed:0.5,.Normal:0.0]
    
    
    @IBAction func recognizer(_ recognizer: UITapGestureRecognizer) {
        
        if(recognizer.state == .ended){
            switch expression.eyes {
            case .Open:
                expression.eyes = .Closed
            case .Closed:
                expression.eyes = .Open
            default:
                break
            }
        }
    }
    
    @IBAction func blinkEye(_ sender: UIButton) {
        let currentState = expression.eyes
        let delay = DispatchTime(uptimeNanoseconds: 1000)
        if(currentState == .Closed)
        {
            UIView .animate(withDuration: 2, animations: {
                self.faceView.eyesOpen = true

            }, completion: { (result) in
                UIView .animate(withDuration: 2, animations: {
                    self.expression.eyes = .Closed
                });
            });
            
        }
        else
        {
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                self.expression.eyes = .Closed
            })
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                self.expression.eyes = .Open
            })
        }
               
    }
    
    @IBAction func changeFaceColor(_ sender: UIButton) {
    }
}

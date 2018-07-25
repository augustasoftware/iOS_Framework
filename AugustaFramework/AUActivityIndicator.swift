//
//  AUActivityIndicator.swift
//  AugustaFramework
//
//  Created by augusta on 20/07/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import Foundation
import AMTumblrHud


public class AUActivityIndicator{
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var tumblrHUD: AMTumblrHud = AMTumblrHud.init()
    
    public enum AUActivityIndicatorType {
        case normal
        case sqaureFading
        case twoCircleAnimation
    }
    
    public init(){
        
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    public func hideActivityIndicator(_ uiView: UIView) {
        
        activityIndicator.removeFromSuperview()
        loadingView.removeFromSuperview()
        container.removeFromSuperview()
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    public func showActivityIndicator(_ uiView: UIView){
        container.frame = uiView.frame
        container.center = uiView.center
        
        container.backgroundColor = AUActivityIndicator.UIColorFromHex(0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = AUActivityIndicator.UIColorFromHex(0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    //****************************** How to use? Start **********************************//
    //  let indicatorView =  AUActivityIndicator.init()
    //  indicatorView.showCustomActivityIndicator(self.view, activityIndicatorStyle: .twoCircleAnimation, containerBGColor: .clear, loadingViewBgColor: .black, circle1Color: .red, circle2Color: .yellow)
    
    //  DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 2 to desired number of seconds
    //  // Your code with delay
    //  indicatorView.hideActivityIndicator(self.view)
    //  }
    //****************************** How to use? End **********************************//
   
    public func showCustomActivityIndicator(_ uiView : UIView, activityIndicatorStyle: AUActivityIndicatorType, containerBGColor: UIColor, loadingViewBgColor: UIColor, viewCornerRadius: CGFloat = 10, circle1Color: UIColor = UIColor.init(white: 1, alpha: 0.90), circle2Color: UIColor = UIColor.init(white: 1, alpha: 0.40)){
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = containerBGColor
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = loadingViewBgColor
        loadingView.clipsToBounds = false
        loadingView.layer.cornerRadius = viewCornerRadius
        
        switch activityIndicatorStyle {
        case .normal:
            
            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
            activityIndicator.activityIndicatorViewStyle = .whiteLarge
            activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
            
            loadingView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            container.addSubview(loadingView)
        case .sqaureFading:
            
            tumblrHUD = AMTumblrHud(frame: CGRect(x: 100, y: 100, width: 55, height: 20))
            tumblrHUD.hudColor = .white
            tumblrHUD.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
            tumblrHUD.show(animated: true)
            
            loadingView.addSubview(tumblrHUD)
            container.addSubview(loadingView)
            break
        case .twoCircleAnimation:
            
            var circleWidth = CGFloat(50)
            var circleHeight = circleWidth
            
            // Create a new CircleView
            let circleView = CircleView(frame: CGRect.init(x: self.loadingView.frame.size.width/2, y: self.loadingView.frame.size.width/2, width: circleWidth, height: circleHeight), lineColor: circle1Color)
            circleView.center = container.center
            
            circleWidth = CGFloat(40)
            circleHeight = circleWidth
            
            // Create a new CircleView
            let circleView1 = CircleView(frame: CGRect.init(x: self.loadingView.frame.size.width/2, y: self.loadingView.frame.size.width/2, width: circleWidth, height: circleHeight), lineColor: circle2Color)
            circleView1.center = circleView.center
            container.addSubview(loadingView)
            container.addSubview(circleView)
            // Animate the drawing of the circle over the course of 1 second
            circleView.animateCircle(duration: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                circleView1.animateCircle(duration: 1.0)
                self.container.addSubview(circleView1)
                
            }
            break
        default:
            break;
        }
        
        
        uiView.addSubview(container)
        
    }
    
    class func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

class CircleView: UIView, CAAnimationDelegate{
    
    var circleLayer: CAShapeLayer!
    
    init(frame: CGRect, lineColor: UIColor) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = lineColor.cgColor
        circleLayer.lineWidth = 5.0;
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        //circleLayer.strokeEnd = 1
        animation.delegate = self
        animation.setValue(1, forKey: "CompletionId")
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateStart")
        
    }
    
    func animateCircle1(duration: TimeInterval) {
        
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeStart")
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.delegate = self
        animation.setValue(2, forKey: "CompletionId")
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateEnd")
        
        
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let animObject = anim as NSObject
        if let keyValue = animObject.value(forKey: "CompletionId") as? Int {
            if keyValue == 1 {
                //circleLayer.strokeEnd = 1.0
                self.animateCircle1(duration: 1.0)
            }
            else{
                //circleLayer.strokeStart = 1.0
                self.animateCircle(duration: 1.0)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


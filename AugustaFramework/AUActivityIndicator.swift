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
    
    public func showCustomActivityIndicator(_ uiView : UIView, activityIndicatorStyle: UIActivityIndicatorViewStyle, containerBGColor: UIColor, loadingViewBgColor: UIColor, viewCornerRadius: CGFloat = 10){
        container.frame = uiView.frame
        container.center = uiView.center
        
        container.backgroundColor = containerBGColor
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = loadingViewBgColor
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = viewCornerRadius
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.activityIndicatorViewStyle = activityIndicatorStyle
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    public func showCustomActivityIndicator1(_ uiView : UIView){
        container.frame = uiView.frame
        container.center = uiView.center
        
        container.backgroundColor = AUActivityIndicator.UIColorFromHex(0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = AUActivityIndicator.UIColorFromHex(0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        tumblrHUD = AMTumblrHud(frame: CGRect(x: 100, y: 100, width: 55, height: 20))
        tumblrHUD.hudColor = .white
        //[UIColor magentaColor];
        tumblrHUD.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        tumblrHUD.show(animated: true)
        
        loadingView.addSubview(tumblrHUD)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
        
        //  Converted to Swift 4 by Swiftify v4.1.6766 - https://objectivec2swift.com/
        
    }
    
    class func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

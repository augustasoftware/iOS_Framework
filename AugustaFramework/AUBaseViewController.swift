//
//  AUBaseViewController.swift
//  AugustaFramework
//
//  Created by Augusta on 15/07/19.
//  Copyright © 2019 augusta. All rights reserved.
//

import UIKit

public class AUThemeManager:NSObject{
    
    /****************************************HOW TO USE THEMER START *******************************************/
//    let themer: AUThemeManager = AUThemeManager.sharedInstance
//    themer.viewBackgroundColor = .lightGray
//    themer.backButtonImage = UIImage.init(named: "custom_back")
//    themer.backButtonTitle = "back1"
//    themer.navigationBarHidden = true
//    themer.navigationBarTintColor = .green
//    themer.navigationBarTitleFont = UIFont(name: "HelveticaNeue-Bold", size: 22.0) ?? UIFont.systemFont(ofSize: 20)
//    themer.navigationBarTitleImage = "custom_back"
//    themer.pushPopAnimationEnabled = false
    /****************************************HOW TO USE THEMER END *******************************************/
    public static let sharedInstance = AUThemeManager()
    public var viewBackgroundColor: UIColor?
    public var navigationBarHidden: Bool = false
    public var navigationBarTintColor: UIColor?
    public var backButtonImage: UIImage?
    public var backButtonTitle: String = ""
    public var navigationBarTitleFont : UIFont = UIFont.systemFont(ofSize: 14.0)
    public var pushPopAnimationEnabled: Bool = true
    public var navigationBarTitleImage: String = ""
}

open class AUBaseViewController: UIViewController {
   
    let themer: AUThemeManager = AUThemeManager.sharedInstance
    
     open override func viewDidLoad() {
        super.viewDidLoad()

       
            self.refreshView()
    }
    
    func refreshView(){
        
        
        // bg color
         self.view.backgroundColor = themer.viewBackgroundColor
        
        //navigation bar visiblity
        if(themer.navigationBarHidden){
            self.navigationController?.navigationBar.isHidden = true
        }
        else{
            self.navigationController?.navigationBar.isHidden = false
        }
        
        // nav bar tint color
        self.navigationController?.navigationBar.tintColor = themer.navigationBarTintColor
        
        // back button image
        self.navigationController?.navigationBar.backIndicatorImage = themer.backButtonImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = themer.backButtonImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: themer.backButtonTitle, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonPressed))
        
        //nav bar title font
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: themer.navigationBarTitleFont]
        
        
        if(themer.navigationBarTitleImage.count != 0){
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
            imageView.contentMode = .scaleAspectFit
            
            let image = UIImage(named: themer.navigationBarTitleImage)
            imageView.image = image
            
            navigationItem.titleView = imageView
        }

    }
    
    @objc public func backButtonPressed(){
        self.navigationController?.popViewController(animated: AUThemeManager.sharedInstance.pushPopAnimationEnabled)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

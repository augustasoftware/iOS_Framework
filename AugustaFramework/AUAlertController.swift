//
//  AUAlertController.swift
//  AugustaFramework
//
//  Created by augusta on 18/07/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import Foundation

public typealias alertHandlerBlock = (_ indexClicked : Int) ->()

public class AUAlertModel{
    var title:String = ""
    var message:String = ""
    var buttonModels:[AUAlertButtonModel] = []
    var style: UIAlertControllerStyle = .alert
    var controller: UIViewController = UIViewController.init()
    
    public init(title:String, message:String, buttonModels:[AUAlertButtonModel], style: UIAlertControllerStyle,  controller: UIViewController){
        self.title = title
        self.message = message
        self.buttonModels = buttonModels
        self.style = style
        self.controller = controller
    }
}

public class AUAlertButtonModel{
    public let actionTitle:String = ""
    public let actionStyle:UIAlertActionStyle = .cancel
}

public class AUAlertHandler{
    
    
    public func showAlertView(alertData: AUAlertModel,  handler: @escaping alertHandlerBlock)
    {
        if(alertData.style == .alert)
        {
            let alert = UIAlertController(title: alertData.title, message: alertData.message, preferredStyle: alertData.style)
            if(alertData.buttonModels.count == 0)
            {
                print("Single button alert must have a value")
            }
            else{
                var index = 0
                for alertButtonModel in alertData.buttonModels{
                    let action = UIAlertAction(title: alertButtonModel.actionTitle, style: alertButtonModel.actionStyle) {
                        UIAlertAction in
                        handler(index) // call button action
                    }
                    alert.addAction(action)
                    index = index + 1
                }
               
                alertData.controller.present(alert, animated: true, completion: nil)
            }
        }
        else{
            
        }
        
        
    }
    
    public func showAlertViewWithTwoOptions(title: String, message:String, okButtonText:String, cancelButtonText:String, controller:UIViewController, handler: @escaping alertHandlerBlock)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: okButtonText, style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        let logoutAction = UIAlertAction(title: cancelButtonText, style: UIAlertActionStyle.default) {
            UIAlertAction in
//            self.requestToCheckBusinessEmailConfirmation()
        }
        alert.addAction(okAction)
        alert.addAction(logoutAction)
//        self.present(alert, animated: true, completion: nil)
    }
}

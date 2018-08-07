//
//  AUPasswordFieldHelper.swift
//  SampleTextFieldHelper
//
//  Created by augusta on 06/08/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import UIKit

public enum AUPasswordHelperValidationParams {
    case minMaxCharacterLimit
    case upperCaseNeeded
    case lowerCaseNeeded
    case numericNeeded
    case specialCharNeeded
    case noBlankSpace
}

public class AUPasswordFieldHelper: UIView {
    
    @IBOutlet public weak var helperView: UIView!
    @IBOutlet weak var minMaxCharStackView: UIStackView!
    @IBOutlet weak var upperCaseStackView: UIStackView!
    @IBOutlet weak var lowerCaseStackView: UIStackView!
    @IBOutlet weak var numericStackView: UIStackView!
    @IBOutlet weak var specialCharacterStackView: UIStackView!
    @IBOutlet weak var blankSpaceStackView: UIStackView!
    @IBOutlet weak var minMaxImageView: UIImageView!
    @IBOutlet weak var upperCaseImageView: UIImageView!
    @IBOutlet weak var lowerCaseImageView: UIImageView!
    @IBOutlet weak var numbericImageView: UIImageView!
    @IBOutlet weak var specialCharImageView: UIImageView!
    @IBOutlet weak var blankSpaceImageView: UIImageView!
    @IBOutlet weak var helperViewHeightConstraint: NSLayoutConstraint!
    
    private var mappedTextField: UITextField?
    private var tickMarkImage: UIImage?
    private var unTickImage: UIImage?
    
    public var isHelperShown: Bool = false
    
    private var itemsNeededForValidation: [AUPasswordHelperValidationParams]?
    
    public override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
        helperView.layer.cornerRadius = 10
    }
    
    required public init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle1 = Bundle(for: AUPasswordFieldHelper.self)
        bundle1.loadNibNamed("AUPasswordFieldHelper", owner: self, options: nil)
        guard let content = helperView else { return }
        content.frame = self.bounds
        content.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content)
    }
    
    public var minimumCharLimit : Int = -1
    public var maximumCharLimit : Int = -1
    
    public func configurePasswordHelper(textField: UITextField, itemsNeeded:[AUPasswordHelperValidationParams], tickImage: UIImage, unTickImage: UIImage){
        self.mappedTextField = textField
        self.helperViewHeightConstraint.constant = CGFloat(itemsNeeded.count * 25) + 25 // (25 is heading height)
        itemsNeededForValidation = itemsNeeded
        if(!itemsNeeded.contains(.minMaxCharacterLimit)){
            minMaxCharStackView.isHidden = true
        }
        if(!itemsNeeded.contains(.upperCaseNeeded)){
            upperCaseStackView.isHidden = true
        }
        if(!itemsNeeded.contains(.lowerCaseNeeded)){
            lowerCaseStackView.isHidden = true
        }
        if(!itemsNeeded.contains(.numericNeeded)){
            numericStackView.isHidden = true
        }
        if(!itemsNeeded.contains(.specialCharNeeded)){
            specialCharacterStackView.isHidden = true
        }
        if(!itemsNeeded.contains(.noBlankSpace)){
            blankSpaceStackView.isHidden = true
        }
        
        minMaxImageView.image = unTickImage
        upperCaseImageView.image = unTickImage
        lowerCaseImageView.image = unTickImage
        numbericImageView.image = unTickImage
        blankSpaceImageView.image = unTickImage
        specialCharImageView.image = unTickImage
        self.unTickImage = unTickImage
        self.tickMarkImage = tickImage
        self.addPasswordHelperViewInView()
    }

    private func addPasswordHelperViewInView(){
        mappedTextField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        mappedTextField?.addTarget(self, action: #selector(textFieldDidBegin(_:)), for: .editingDidBegin)
        mappedTextField?.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEnd)

        self.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: helperView, attribute: .bottom, relatedBy: .equal, toItem: mappedTextField, attribute: .top, multiplier: 1, constant: -5)
        let xConstraint = NSLayoutConstraint(item: helperView, attribute: .centerX, relatedBy: .equal, toItem: mappedTextField, attribute: .centerX, multiplier: 1, constant: 0)
        mappedTextField?.superview?.addSubview(helperView)
        helperView.isHidden = true
        self.isHelperShown = false
        mappedTextField?.superview?.addConstraints([bottomConstraint, xConstraint])
        mappedTextField?.superview?.layoutIfNeeded()
        self.validateBasedOnText(textString: mappedTextField?.text ?? "")
    }
    
    public func showOrHideHelper(show: Bool){
        if(show){
           
            UIView.transition(with: (mappedTextField?.superview)!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.helperView.isHidden = false
                self.isHelperShown = true
            })
        }
        else{
            UIView.transition(with: (mappedTextField?.superview)!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.helperView.isHidden = true
                self.isHelperShown = false
            })
        }
    }
    
    public func toggleHelper(){
        if(self.isHelperShown){
            UIView.transition(with: (mappedTextField?.superview)!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.helperView.isHidden = true
                self.isHelperShown = false
            })
            
        }
        else{
            UIView.transition(with: (mappedTextField?.superview)!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.helperView.isHidden = false
                self.isHelperShown = true
            })
           
        }
    }
    
    public func validateBasedOnText(textString: String){
        
        var validationSuccessCount: Int = 0
        
         charLabel: if(self.itemsNeededForValidation?.contains(.minMaxCharacterLimit))!{
            if(self.minimumCharLimit == -1 || self.maximumCharLimit == -1){
                print("Minimum and maximum char limit is not set. Please set and try again")
                break charLabel
            }
            if(textString.count > self.minimumCharLimit && textString.count < self.maximumCharLimit){
                self.minMaxImageView.image = self.tickMarkImage
                validationSuccessCount = validationSuccessCount + 1
            }
            else{
                self.minMaxImageView.image = self.unTickImage
            }
            
        }
        
        if(self.itemsNeededForValidation?.contains(.upperCaseNeeded))!{
            let capitalLetterRegEx  = ".*[A-Z]+.*"
            let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
            let capitalresult = texttest.evaluate(with: textString)
           
            if(capitalresult){
                self.upperCaseImageView.image = self.tickMarkImage
                validationSuccessCount = validationSuccessCount + 1
            }
            else{
                self.upperCaseImageView.image = self.unTickImage
            }
        }
        
        if(self.itemsNeededForValidation?.contains(.lowerCaseNeeded))!{
            let lowerLetterRegEx  = ".*[a-z]+.*"
            let texttest = NSPredicate(format:"SELF MATCHES %@", lowerLetterRegEx)
            let capitalresult = texttest.evaluate(with: textString)
           
            if(capitalresult){
                self.lowerCaseImageView.image = self.tickMarkImage
                validationSuccessCount = validationSuccessCount + 1
            }
            else{
                self.lowerCaseImageView.image = self.unTickImage
            }
        }
        
        if(self.itemsNeededForValidation?.contains(.numericNeeded))!{
            let numberRegEx  = ".*[0-9]+.*"
            let texttest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            let numberresult = texttest.evaluate(with: textString)
           
            if(numberresult){
                self.numbericImageView.image = self.tickMarkImage
                validationSuccessCount = validationSuccessCount + 1
            }
            else{
                self.numbericImageView.image = self.unTickImage
            }
        }
        
        if(self.itemsNeededForValidation?.contains(.specialCharNeeded))!{
            let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
            let texttest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            let specialresult = texttest.evaluate(with: textString)
            
            if(specialresult){
                self.specialCharImageView.image = self.tickMarkImage
                validationSuccessCount = validationSuccessCount + 1
            }
            else{
                self.specialCharImageView.image = self.unTickImage
            }
        }
        
        if(self.itemsNeededForValidation?.contains(.noBlankSpace))!{
            let specialCharacterRegEx  = ".*[ ]+.*"
            let texttest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            let specialresult = texttest.evaluate(with: textString)
            if(specialresult){
                self.blankSpaceImageView.image = self.unTickImage
            }
            else{
                self.blankSpaceImageView.image = self.tickMarkImage
                validationSuccessCount = validationSuccessCount + 1
            }
        }
        
        if(validationSuccessCount == self.itemsNeededForValidation?.count){
            self.showOrHideHelper(show: false)
        }
        else{
            self.showOrHideHelper(show: true)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.validateBasedOnText(textString: textField.text!)
    }
    
    @objc func textFieldDidBegin(_ textField: UITextField) {
        self.showOrHideHelper(show: true)
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) {
        self.showOrHideHelper(show: false)
    }
    

}

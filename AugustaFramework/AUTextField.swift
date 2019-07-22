//
//  AUTextField.swift
//  AugustaFramework
//
//  Created by iMac Augusta on 7/22/19.
//  Copyright © 2019 augusta. All rights reserved.
//

import Foundation
import UIKit


public enum SGCellButtonType {
    case Emerald
    case RedRound
    case Cancel
    case DropDown
}

public enum SGCellTextFieldType {
    case Calendar
    case Clock
    case DropDown
    case Normal
}






public class TxtDropDownn: UITextField {
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
        self.setDropDownImage()
    }
    
    private func commonSetup() {
        self.borderStyle = .none
        self.clipsToBounds = true
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1.0
        self.layer.sublayerTransform = CATransform3DMakeTranslation(-5, 0, 0)
        
    }
    
    private func setDropDownImage() {
        let imageView = UIImageView.init(image: UIImage(named: "blackDropDown"))
        self.rightView = imageView
        self.rightView?.frame = CGRect(x: 0, y: 0, width: 25 , height: 25)
        self.rightViewMode = .always
        self.setLeftPaddingPoints(10)
    }
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

public class TxtClockTime: UITextField {
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
        self.setClockTimeImage()
    }
    
    private func commonSetup() {
        self.borderStyle = .none
        self.clipsToBounds = true
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.clear
        self.layer.sublayerTransform = CATransform3DMakeTranslation(-5, 0, 0)
    }
    
    private func setClockTimeImage() {
        let imageView = UIImageView.init(image: UIImage(named: "baseline-clock"))
        self.rightView = imageView
        self.rightView?.frame = CGRect(x: 0, y: 0, width: 24 , height: 24)
        self.rightViewMode = .always
        self.setLeftPaddingPoints(10)
    }
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

public class TxtCalendar: UITextField {
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
        self.setCalendarImage()
    }
    
    private func commonSetup() {
        self.borderStyle = .none
        self.clipsToBounds = true
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.clear
        self.layer.sublayerTransform = CATransform3DMakeTranslation(-5, 0, 0)
    }
    
    private func setCalendarImage() {
        let imageView = UIImageView.init(image: UIImage(named: "calendar"))
        self.rightView = imageView
        self.rightView?.frame = CGRect(x: 0, y: 0, width: 24 , height: 24)
        self.rightViewMode = .always
        self.setLeftPaddingPoints(10)
    }
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

public class SGCellTextField : UITextField{
    
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    private func commonSetup() {
        self.textColor = UIColor.black
    }
    
    public func setCellTextFieldType(txtFieldtype:SGCellTextFieldType) {
        self.borderStyle = .none
        self.clipsToBounds = true
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.clear
        
        var imageView:UIImageView? = nil
        switch txtFieldtype {
        case .DropDown:
            imageView = UIImageView.init(image: UIImage(named: "blackDropDown"))
        case .Calendar:
            imageView = UIImageView.init(image: UIImage(named: "calendar"))
        case .Clock:
            imageView = UIImageView.init(image: UIImage(named: "baseline-clock"))
        case .Normal:
            break
        }
        self.layer.sublayerTransform = CATransform3DMakeTranslation(-5, 0, 0)
        self.rightView = imageView
        self.rightView?.frame = CGRect(x: 0, y: 0, width: 24 , height: 24)
        self.rightViewMode = .always
        self.setLeftPaddingPoints(10)
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

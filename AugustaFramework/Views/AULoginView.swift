//
//  AULoginView.swift
//  AugustaFramework
//
//  Created by augusta on 26/07/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import UIKit

public enum AULoginForgotPasswordLocation{
    case normal
    case leftBottom
    case insideField
}
public protocol AULoginViewDelegate{
    func forgotPasswordClicked(sender: Any)
    func loginButtonTapped(sender: Any)
}

public class AULoginView: UIView {
    
    @IBOutlet public weak var loginView: UIView!
    @IBOutlet public weak var loginViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet public weak var passwordTextField: UITextField!
    @IBOutlet public weak var userNameTextField: UITextField!
    @IBOutlet public weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotPassword1Button: UIButton!
    @IBOutlet weak var forgotPassword2Button: UIButton!
    @IBOutlet weak var forgotPassword3Button: UIButton!
    
     public var delegate: AULoginViewDelegate?
    
    public override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AULoginView", owner: self, options: nil)
        guard let content = loginView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        self.delegate?.loginButtonTapped(sender: sender)
    }
    
    @IBAction func forgotPassword1Clicked(_ sender: Any) {
        self.delegate?.forgotPasswordClicked(sender: sender)
    }
    
    @IBAction func forgotPassword2Clicked(_ sender: Any) {
        self.delegate?.forgotPasswordClicked(sender: sender)
    }
    @IBAction func forgotPassword3Clicked(_ sender: Any) {
        self.delegate?.forgotPasswordClicked(sender: sender)
    }
    
    public func configureLoginView(forgotPasswordLocation: AULoginForgotPasswordLocation){
        switch forgotPasswordLocation {
        case .normal:
            self.forgotPassword3Button.isHidden = false
            self.forgotPassword1Button.isHidden = true
            self.forgotPassword2Button.isHidden = true
        case .leftBottom:
            self.forgotPassword2Button.isHidden = false
            self.forgotPassword3Button.isHidden = true
            self.forgotPassword1Button.isHidden = true
        case .insideField:
            self.forgotPassword1Button.isHidden = false
            self.forgotPassword2Button.isHidden = true
            self.forgotPassword3Button.isHidden = true
        default:
            break
        }
    }

}

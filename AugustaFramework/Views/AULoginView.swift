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
    
    func loginButtonClicked()
    func forgotPasswordClicked()
    func forgotPasswordSubmitClicked()
    func resetPasswordSubmitClicked()
}

public class AULoginView: UIView {
    
    // Login Details
    @IBOutlet public weak var loginView: UIView!
    @IBOutlet public weak var passwordTextField: UITextField!
    @IBOutlet public weak var userNameTextField: UITextField!
    @IBOutlet public weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotPassword1Button: UIButton!
    @IBOutlet weak var forgotPassword2Button: UIButton!
    @IBOutlet weak var forgotPassword3Button: UIButton!
    
    //Fogot Password
    @IBOutlet public weak var forgotPasswordView: UIView!
    @IBOutlet public weak var forgotPWDSubmitButton: UIButton!
    @IBOutlet public weak var forgotPWDUsernameField: UITextField!
    
    // Reset Password
    @IBOutlet public weak var resetView: UIView!
    @IBOutlet public weak var resetOldPWDTextField: UITextField!
    @IBOutlet public weak var resetPWDTextField: UITextField!
    @IBOutlet public weak var resetConfirmPWDTextField: UITextField!
    @IBOutlet public weak var resetPWDSubmitButton: UIButton!
    
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
        let bundle1 = Bundle(for: AULoginView.self)
        bundle1.loadNibNamed("AULoginView", owner: self, options: nil)
        guard let content = loginView else { return }
        content.frame = self.bounds
        content.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content)
        guard let content1 = resetView else { return }
        content1.frame = self.bounds
        content1.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content1)
        guard let content2 = forgotPasswordView else { return }
        content2.frame = self.bounds
        content2.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content2)
    }
    
    
    //****************************** How to use? Start **********************************//
    //    let auloginView = AULoginView.init(frame: loginTempView.bounds)
    //    auloginView.delegate = self
    //    auloginView.configureForgotPassword(forgotPasswordLocation: .leftBottom, forgotPasswordText: "forgot password?")
    //    auloginView.userNameTextField.delegate = self
    //    auloginView.passwordTextField.delegate = self
    //    auloginView.addLoginViewInView(view: loginTempView)
    //****************************** How to use? End **********************************//
    
    /// HOW TO USE?  - Check comments section on top of the method implementaion AULoginView
    ///
    /// - Parameter view: view in which this login view has to be added
    public func addLoginViewInView(view: UIView, viewController: UIViewController)
    {
        //self.loginButton.addTarget(self, action: #selector(self.loginButtonClicked(_:)), for: .touchUpInside) //<- use `#selector(...)`

        //self.loginButton.addTarget(self, action: Selector(loginButtonClicked(self.loginButton)), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: loginView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: loginView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: loginView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: loginView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        view.addSubview(loginView)
        view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        view.layoutIfNeeded()
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        self.delegate?.loginButtonClicked()
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        self.delegate?.forgotPasswordClicked()
    }
    
    
    /// forgot password configuration is not mandatory if there is no forgot password
    ///
    /// - Parameters:
    ///   - forgotPasswordLocation: position of forgot password button
    ///   - forgotPasswordText: text to be shown in that button
    public func configureForgotPassword(forgotPasswordLocation: AULoginForgotPasswordLocation, forgotPasswordText: String){
        switch forgotPasswordLocation {
        case .normal:
            self.forgotPassword3Button.isHidden = false
            self.forgotPassword3Button.setTitle(forgotPasswordText, for: .normal)
            self.forgotPassword1Button.isHidden = true
            self.forgotPassword2Button.isHidden = true
        case .leftBottom:
            self.forgotPassword2Button.isHidden = false
            self.forgotPassword2Button.setTitle(forgotPasswordText, for: .normal)
            self.forgotPassword3Button.isHidden = true
            self.forgotPassword1Button.isHidden = true
        case .insideField:
            self.forgotPassword1Button.isHidden = false
            self.forgotPassword1Button.setTitle(forgotPasswordText, for: .normal)
            self.forgotPassword2Button.isHidden = true
            self.forgotPassword3Button.isHidden = true
        default:
            break
        }
    }
    
    //MARK: Forgot password
    //****************************** How to use? Start **********************************//
//    let auloginView = AULoginView.init(frame: loginTempView.bounds)
//    auloginView.delegate = self
//    auloginView.addForgotPasswordViewInView(view: loginTempView)
    //****************************** How to use? End **********************************//
    
    public func addForgotPasswordViewInView(view: UIView, viewController: UIViewController){
        
        //self.forgotPWDSubmitButton.addTarget(viewController, action: #selector(self.forgotPWDSubmitButtonClicked(_:)), for: .touchUpInside)
        //self.forgotPWDSubmitButton.addTarget(self, action: Selector(forgotPWDSubmitButtonClicked(self.forgotPWDSubmitButton)), for: .touchUpInside)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: forgotPasswordView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: forgotPasswordView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: forgotPasswordView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: forgotPasswordView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        view.addSubview(forgotPasswordView)
        view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        view.layoutIfNeeded()
    }
    
    @IBAction func forgotPWDSubmitButtonClicked(_ sender: Any) {
        self.delegate?.forgotPasswordSubmitClicked()
    }
    
    //MARK: Reset password
    //****************************** How to use? Start **********************************//
    //    let auloginView = AULoginView.init(frame: loginTempView.bounds)
    //    auloginView.delegate = self
    //    auloginView.addResetPasswordViewInView(view: loginTempView)
    //****************************** How to use? End **********************************//
    
    public func addResetPasswordViewInView(view: UIView, viewController: UIViewController, isOldPWDVisible: Bool = false){
        self.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: resetView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: resetView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: resetView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: resetView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        resetOldPWDTextField.isHidden = !isOldPWDVisible
        view.addSubview(resetView)
        view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        view.layoutIfNeeded()
    }
    
    @IBAction func resetPWDSubmitButtonClicked(_ sender: Any) {
        self.delegate?.resetPasswordSubmitClicked()
    }
    
    
    
    
}


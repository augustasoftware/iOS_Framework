//
//  AULoginViewController.swift
//  AugustaFramework
//
//  Created by augusta on 25/07/18.
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

public class AULoginViewController: UIViewController {

    @IBOutlet public weak var loginViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet public weak var passwordTextField: UITextField!
    @IBOutlet public weak var userNameTextField: UITextField!
    @IBOutlet public weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotPassword1Button: UIButton!
    @IBOutlet weak var forgotPassword2Button: UIButton!
    @IBOutlet weak var forgotPassword3Button: UIButton!
    
    
    public var delegate: AULoginViewDelegate?
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

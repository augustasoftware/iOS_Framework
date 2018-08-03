//
//  AUBillingInfoView.swift
//  AugustaFramework
//
//  Created by augusta on 01/08/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import UIKit
import Stripe

let MAX_CARD_CVV_NO = 4
let CONTENT_CARD_NUMBER_IN_VALID = "Please enter valid card number"

public typealias kStripeTokenSuccessBlock = (_ success : Bool, _ message : STPToken) ->()
public typealias kStripeTokenFailureBlock = (_ success : Bool, _ message : String) ->()


public enum AUBillingInfoPaymentType {
    case stripe
    case payPal
    case applePay
    case unknown
}

public class AUBillingInfoView: UIView {
    
    @IBOutlet public weak var cardNoTextField: UITextField!
    @IBOutlet public weak var cardExpiryTextField: UITextField!
    @IBOutlet public weak var cardSecurityCode: UITextField!
    @IBOutlet public weak var nameTextField: UITextField!
    @IBOutlet public weak var cardTypeImageView: UIImageView!
    
    @IBOutlet weak var billingAddressView: UIView!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cardDetailsView: UIView!
    var billingMethodType:AUBillingInfoPaymentType?
    var textFieldValidationHandling: Bool?
    var cardBrand : STPCardBrand = STPCardBrand.unknown
    
    var selectedExpiryDate : String = ""
    var selectedMonth:String! = ""
    var selectedYear:String! = ""
    
    public var stripeToken: String = ""
    
    @IBOutlet public var pickerBaseView: UIView!
    @IBOutlet public weak var pickerViewToolBar: UIView!
    @IBOutlet public weak var expiryDatePicker: AUMonthYearPickerView!
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    public override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle1 = Bundle(for: AUBillingInfoView.self)
        bundle1.loadNibNamed("AUBillingInfoView", owner: self, options: nil)
        guard let content = cardDetailsView else { return }
        content.frame = self.bounds
        content.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content)
        guard let content1 = pickerBaseView else { return }
        content1.frame = self.bounds
        content1.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content1)
        guard let content2 = billingAddressView else { return }
        content2.frame = self.bounds
        content2.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content2)
        self.loadInitialSetup()
    }
    
    func loadInitialSetup(){
        cardExpiryTextField.inputView = pickerBaseView
        changeCardImage(cardNumber: "")
        // picker setup
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        self.pickerViewToolBar.addSubview(toolbar)
        let currentYear = String(format: "%d", expiryDatePicker.year)
        self.selectedExpiryDate = String(format: "%02d/%@", expiryDatePicker.month, currentYear.substring(from:currentYear.index(currentYear.endIndex, offsetBy: -2)))
        self.selectedMonth = String(format: "%d", expiryDatePicker.month)
        self.selectedYear = currentYear
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let inputStr = String(format: "%d", year)
            let expiryDate = String(format: "%02d/%@", month, inputStr.substring(from:inputStr.index(inputStr.endIndex, offsetBy: -2)))
            self.selectedExpiryDate = expiryDate
            self.selectedMonth = String(format: "%d", month)
            self.selectedYear = String(format: "%d", year)
        }
    }
    
    // picker can cel and done
    
    @objc func donePicker(){
        cardExpiryTextField.text = self.selectedExpiryDate
        cardExpiryTextField.resignFirstResponder()
    }
    
    @objc func cancelPicker(){
        cardExpiryTextField.resignFirstResponder()
    }
    
    public func initializeSetUp(paymentMethod: AUBillingInfoPaymentType, textFieldValidationHandling: Bool = false){
        self.textFieldValidationHandling = textFieldValidationHandling
        switch paymentMethod {
        case .stripe:
            if(textFieldValidationHandling){
                cardNoTextField.delegate = self
                cardExpiryTextField.delegate = self
                cardSecurityCode.delegate = self
                nameTextField.delegate = self
            }
            break
        case .payPal:
            break
        case .applePay:
            break
        default:
            break
        }
    }
    
    public func addCardDetailsInView(view: UIView)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: cardDetailsView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: cardDetailsView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: cardDetailsView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: cardDetailsView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        view.addSubview(cardDetailsView)
        view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        view.layoutIfNeeded()
    }
    
    public func addAddressDetailsViewInView(view: UIView)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: billingAddressView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: billingAddressView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: billingAddressView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: billingAddressView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        view.addSubview(billingAddressView)
        view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        view.layoutIfNeeded()
    }
    
    public func isValidCardDetailsEntered()-> Bool{
        if(self.textFieldValidationHandling)!{
            return true
        }
        return false
    }
    
    public func getStripeToken(stripeCardParams: STPCardParams?, stripeTokenSuccessBlock: @escaping kStripeTokenSuccessBlock,  stripeTokenFailureBlock: @escaping kStripeTokenFailureBlock){
        var stripeCardParamsNew: STPCardParams = STPCardParams()
        if stripeCardParams != nil{
            
        }
        else{
            stripeCardParamsNew = STPCardParams()
            stripeCardParamsNew.number = AUUtilities.removeWhiteSpace(text: cardNoTextField.text!)
            stripeCardParamsNew.cvc =  AUUtilities.removeWhiteSpace(text: cardSecurityCode.text!)
            stripeCardParamsNew.expMonth = UInt(selectedMonth ?? "0")!
            stripeCardParamsNew.expYear = UInt(selectedYear ?? "0")!
            stripeCardParamsNew.name =  AUUtilities.removeWhiteSpace(text: nameTextField.text! )
            stripeCardParamsNew.address.line1 =  AUUtilities.removeWhiteSpace(text: addressTextField.text!)
            stripeCardParamsNew.address.city =  AUUtilities.removeWhiteSpace(text: cityTextField.text!)
            stripeCardParamsNew.address.state =  AUUtilities.removeWhiteSpace(text: stateTextField.text!)
            stripeCardParamsNew.address.postalCode =  AUUtilities.removeWhiteSpace(text: zipTextField.text!)
        }
        var finalParams: STPCardParams = stripeCardParams ?? stripeCardParamsNew
        // get stripe token for current card
        
        STPPaymentConfiguration.shared().publishableKey = stripeToken
        STPAPIClient.shared().createToken(withCard: finalParams) { (token: STPToken?, error: Error?) in
            if let token = token {
                stripeTokenSuccessBlock(true, token)
               
            } else {
                stripeTokenFailureBlock(false, error.debugDescription)
            }
            
        }
    }
}

extension AUBillingInfoView: UITextFieldDelegate{
    //MARK: UITextField Delegates
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringVal = NSString(string: textField.text!)
        let newText = stringVal.replacingCharacters(in: range, with: string)
        if (textField == textField) {
            if newText.count == 1 && newText == " " {
                let oldString = textField.text!
                let newStart = oldString.index(oldString.startIndex, offsetBy: range.location)
                let newEnd = oldString.index(oldString.startIndex, offsetBy: range.location + range.length)
                let newString = oldString.replacingCharacters(in: newStart..<newEnd, with: string)
                textField.placeholder = newString.replacingOccurrences(of: " ", with: textField.placeholder ?? "")
                return false
            }
        }
        
        
        
        if (textField == cardSecurityCode){
            
            if(self.cardBrand == STPCardBrand.amex)
            {
                return newText.count <= MAX_CARD_CVV_NO
            }
            else
            {
                return newText.count <= 3
            }
            
        }
        
        if (textField == nameTextField){
            return  newText.count <= 100
        }
        
        if(textField == cardNoTextField){
            
            var result = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            result = STPCardValidator.sanitizedNumericString(for: result)
            
            let attributedString = NSMutableAttributedString( string: result, attributes: nil)
            if(result.count >= 2)
            {
                changeCardImage(cardNumber: result)
            }
            else
            {
                changeCardImage(cardNumber: "")
            }
            
            // if card number is invalid show error message
            if STPCardValidator.validationState(forNumber: result, validatingCardBrand: true) == STPCardValidationState.invalid {
                print("card validation failed")
                return false
            }
            
            
            var cardSpacing  = [Int]()
            if self.cardBrand == STPCardBrand.amex {
                cardSpacing = [3, 9]
            } else {
                cardSpacing = [3, 7, 11]
            }
            for index in 0..<attributedString.length {
                
                let contains = cardSpacing.contains(where: { $0 == index })
                if(contains) {
                    attributedString.addAttribute(NSAttributedStringKey.kern, value: 5, range: NSRange(location: index, length: 1))
                } else {
                    attributedString.addAttribute(NSAttributedStringKey.kern, value: 0, range: NSRange(location: index, length: 1))
                }
            }
            textField.attributedText = attributedString
            return false
        }
        return true
        
    }
    
    /// Change card image displayed with the card number
    ///
    /// - Parameter cardNumber: The card number entered, it should be more than two digits
    public func changeCardImage(cardNumber: String)
    {
        let frameworkBundle = Bundle(for: AUBillingInfoView.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("AugustaFramework.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        self.cardBrand = STPCardValidator.brand(forNumber: cardNumber)
        switch self.cardBrand {
        case .amex:
            cardTypeImageView.image = UIImage(named: "card_amex", in: resourceBundle, compatibleWith: nil)
        case .visa:
            cardTypeImageView.image =  UIImage(named: "card_visa", in: resourceBundle, compatibleWith: nil)
        case .masterCard:
            cardTypeImageView.image =  UIImage(named: "card_mastercard", in: resourceBundle, compatibleWith: nil)
        case .dinersClub:
            cardTypeImageView.image =  UIImage(named: "card_diners", in: resourceBundle, compatibleWith: nil)
        case .discover:
            cardTypeImageView.image =  UIImage(named: "card_discover", in: resourceBundle, compatibleWith: nil)
        case .JCB:
            cardTypeImageView.image =  UIImage(named: "card_jcb", in: resourceBundle, compatibleWith: nil)
        case .unionPay:
            cardTypeImageView.image =  UIImage(named: "card_unionpay", in: resourceBundle, compatibleWith: nil)
        default:
            cardTypeImageView.image =  UIImage(named: "card", in: resourceBundle, compatibleWith: nil)
        }
    }
}


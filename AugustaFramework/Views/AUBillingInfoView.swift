//
//  AUBillingInfoView.swift
//  AugustaFramework
//
//  Created by augusta on 01/08/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import UIKit
import Stripe
import IQKeyboardManagerSwift

let MAX_CARD_CVV_NO = 4
let CONTENT_CARD_NUMBER_IN_VALID = "Please enter valid card number"
let CONTENT_CARD_NUMBER_EMPTY = "Please enter card number"
let CONTENT_CARD_EXPIRATIONDATE_EMPTY = "Please select expiration date"
let CONTENT_CARD_NAME_EMPTY = "Please enter card name"
let CONTENT_CARD_CVV_EMPTY = "Please enter Security Code"
let CONTENT_CARD_IN_VALID_CVV = "Please enter valid Security Code"
let CONTENT_CARD_EXPIRATIONDATE_FORMAT = "Expiration date should be MM/YY"
let CONTENT_CARD_EXPIRATIONDATE_VALID = "Please enter valid expiration date"
let CONTENT_ALERT_STREET_ADDRESS = "Please enter the street address"
let CONTENT_FIRST_NAME = "Please enter first name"
let CONTENT_SECOND_NAME = "Please enter last name"
let CONTENT_CITY = "Please enter city"
let CONTENT_STATE = "Please select state"
let CONTENT_ZIPCODE_BLANK = "Zipcode shouldn't be blank"
let CONTENT_ZIPCODE_MINIMUM = "Zipcode can contains alphabets, number, hypen & length should range between 2 to 12 characters"

let CONTENT_ZIPCODE_ALPHANUMERIC = "Zipcode should contain 1 numberic character"

public typealias kStripeTokenSuccessBlock = (_ success : Bool, _ message : STPToken) ->()
public typealias kStripeTokenFailureBlock = (_ success : Bool, _ message : String) ->()

public protocol AUBillingInfoViewDelegate{
    func countrySelected(countrySelected: String)
    func stateSelected(stateSelected: String)
    func citySelected(citySelected: String)
}

public enum AUBillingInfoPaymentType {
    case stripe
    case payPal
    case applePay
    case unknown
}

public class AUBillingInfoView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var pickerSelectedTextField: UITextField = UITextField()
    private var selectedItemFromPicker: String?
    var selectedCountry: String?
    var selectedState: String?
    var selectedCity: String?
    
    public var delegate: AUBillingInfoViewDelegate?
    
    @IBOutlet public weak var cardNoTextField: UITextField!
    @IBOutlet public weak var cardExpiryTextField: UITextField!
    @IBOutlet public weak var cardSecurityCode: UITextField!
    @IBOutlet weak var cardDetailsView: UIView!
    @IBOutlet public weak var cardTypeImageView: UIImageView!
    
    @IBOutlet weak var billingAddressCountryView: UIView!
    var isCountryPresentInBilling: Bool = false
    var isCityPickerEnabled : Bool = false
    @IBOutlet public weak var countryFirstNameTextField: UITextField!
    @IBOutlet public weak var countrySecondNameTextField: UITextField!
    @IBOutlet weak var countryZipTextField: UITextField!
    @IBOutlet weak var countryAddressTextField: UITextField!
    @IBOutlet weak var countryStateTextField: UITextField!
    @IBOutlet weak var countryCityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var billingAddressView: UIView!
    @IBOutlet public weak var firstNameTextField: UITextField!
    @IBOutlet public weak var secondNameTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    
    
    var billingMethodType:AUBillingInfoPaymentType?
    var textFieldValidationHandling: Bool?
    var cardBrand : STPCardBrand = STPCardBrand.unknown
    
    var selectedExpiryDate : String = ""
    var selectedMonth:String! = ""
    var selectedYear:String! = ""
    var currentMonth = Int()
    var currentYear = Int()
    
    public var stripeKey: String = ""
    
    @IBOutlet public var pickerBaseView: UIView!
    @IBOutlet public weak var pickerViewToolBar: UIView!
    @IBOutlet public weak var expiryDatePicker: AUMonthYearPickerView!
    @IBOutlet public weak var cityStatePicker: UIPickerView!
    
    public var countryNamesArray : [String]?
    public var stateNamesArray : [String]?
    public var cityNamesArray : [String]?
    
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
        guard let content3 = billingAddressCountryView else { return }
        content3.frame = self.bounds
        content3.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content3)
        self.loadInitialSetup()
    }
    
    func loadInitialSetup(){
        cardExpiryTextField.inputView = pickerBaseView
        changeCardImage(cardNumber: "")
        // picker setup
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
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
        
        
        if(pickerSelectedTextField == cardExpiryTextField)
        {
            cardExpiryTextField.text = self.selectedExpiryDate
            self.cardDetailsView.endEditing(true)
        }
        else
        {
            if(pickerSelectedTextField == stateTextField || pickerSelectedTextField == countryStateTextField)
            {
                self.delegate?.stateSelected(stateSelected: selectedItemFromPicker ?? "")
            }
            else if(pickerSelectedTextField == cityTextField || pickerSelectedTextField == countryCityTextField)
            {
                self.delegate?.citySelected(citySelected: selectedItemFromPicker ?? "")
            }
            else if(pickerSelectedTextField == countryTextField)
            {
                self.delegate?.countrySelected(countrySelected: selectedItemFromPicker ?? "")
            }
            pickerSelectedTextField.text = selectedItemFromPicker
            self.billingAddressCountryView.endEditing(true)
            self.billingAddressView.endEditing(true)
        }
    }
    
    @objc func cancelPicker(){
        if(pickerSelectedTextField == cardExpiryTextField){
            self.cardDetailsView.endEditing(true)
        }
        else{
            self.billingAddressCountryView.endEditing(true)
            self.billingAddressView.endEditing(true)
        }
    }
    
    public func initializeSetUp(paymentMethod: AUBillingInfoPaymentType, textFieldValidationHandling: Bool = false, isCountryPresentInBilling: Bool = false, isCityPickerInput: Bool = false){
        self.textFieldValidationHandling = textFieldValidationHandling
        self.isCountryPresentInBilling = isCountryPresentInBilling
        self.isCityPickerEnabled = isCityPickerInput
        stateTextField.inputView = pickerBaseView
        cityTextField.inputView = pickerBaseView
        countryTextField.inputView = pickerBaseView
        countryStateTextField.inputView = pickerBaseView
        countryCityTextField.inputView = pickerBaseView
        cityStatePicker.delegate = self
        cityStatePicker.dataSource = self
        switch paymentMethod {
        case .stripe:
            if(textFieldValidationHandling){
                cardNoTextField.delegate = self
                cardExpiryTextField.delegate = self
                cardSecurityCode.delegate = self
                stateTextField.delegate = self
                cityTextField.delegate = self
                countryTextField.delegate = self
                countryStateTextField.delegate = self
                countryCityTextField.delegate = self
                firstNameTextField.delegate = self
                secondNameTextField.delegate = self
                zipTextField.delegate = self
                countryFirstNameTextField.delegate = self
                countrySecondNameTextField.delegate = self
                countryAddressTextField.delegate = self
                countryZipTextField.delegate = self
                
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
        if(!self.isCountryPresentInBilling){
            let topConstraint = NSLayoutConstraint(item: billingAddressView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: billingAddressView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: billingAddressView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: billingAddressView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            view.addSubview(billingAddressView)
            view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
            view.layoutIfNeeded()
        }
        else{
            let topConstraint = NSLayoutConstraint(item: billingAddressCountryView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: billingAddressCountryView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: billingAddressCountryView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: billingAddressCountryView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            view.addSubview(billingAddressCountryView)
            view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
            view.layoutIfNeeded()
        }
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
            stripeCardParamsNew.name =  AUUtilities.removeWhiteSpace(text: String(format:"%@ %@", countryFirstNameTextField.text ?? "", countrySecondNameTextField.text ?? "" ))
            stripeCardParamsNew.address.line1 =  AUUtilities.removeWhiteSpace(text: countryAddressTextField.text!)
            stripeCardParamsNew.address.city =  AUUtilities.removeWhiteSpace(text: countryCityTextField.text!)
            stripeCardParamsNew.address.state =  AUUtilities.removeWhiteSpace(text: countryStateTextField.text!)
            stripeCardParamsNew.address.postalCode =  AUUtilities.removeWhiteSpace(text: countryTextField.text!)
        }
        var finalParams: STPCardParams = stripeCardParams ?? stripeCardParamsNew
        // get stripe token for current card
        
        STPPaymentConfiguration.shared().publishableKey = stripeKey
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
        
        if(textField == cardExpiryTextField)
        {
            IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
            IQKeyboardManager.shared.enableAutoToolbar = false
            expiryDatePicker.isHidden = false
            cityStatePicker.isHidden = true
            pickerSelectedTextField = textField
        }
        else if(textField == stateTextField || textField == countryStateTextField)
        {
            IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
            IQKeyboardManager.shared.enableAutoToolbar = false
            expiryDatePicker.isHidden = true
            cityStatePicker.isHidden = false
            pickerSelectedTextField = textField
            cityStatePicker.reloadAllComponents()
        }
        else if(self.isCityPickerEnabled && (textField == cityTextField  || textField == countryCityTextField))
        {
            IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
            IQKeyboardManager.shared.enableAutoToolbar = false
            expiryDatePicker.isHidden = true
            cityStatePicker.isHidden = false
            pickerSelectedTextField = textField
            cityStatePicker.reloadAllComponents()
        }
        else if(textField == countryTextField)
        {
            IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
            IQKeyboardManager.shared.enableAutoToolbar = false
            expiryDatePicker.isHidden = true
            cityStatePicker.isHidden = false
            pickerSelectedTextField = textField
            cityStatePicker.reloadAllComponents()
        }
        else
        {
            pickerSelectedTextField = UITextField()
            IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
        return true
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
                    attributedString.addAttribute(NSAttributedString.Key.kern, value: 5, range: NSRange(location: index, length: 1))
                } else {
                    attributedString.addAttribute(NSAttributedString.Key.kern, value: 0, range: NSRange(location: index, length: 1))
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
    
    //MARK: UIPicker Delegate
    //MARK: UIPickerView Delegates
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(self.isCityPickerEnabled && (pickerSelectedTextField == cityTextField || pickerSelectedTextField == countryCityTextField))
        {
            return cityNamesArray?[row] ?? ""
        }
        else if(pickerSelectedTextField == stateTextField || pickerSelectedTextField == countryStateTextField){
            return stateNamesArray?[row] ?? ""
        }
        else if(pickerSelectedTextField == countryTextField){
            return countryNamesArray?[row] ?? ""
        }
        
        return ""
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(self.isCityPickerEnabled && (pickerSelectedTextField == cityTextField || pickerSelectedTextField == countryCityTextField))
        {
            return cityNamesArray?.count ?? 0
        }
        else if(pickerSelectedTextField == stateTextField || pickerSelectedTextField == countryStateTextField){
            return stateNamesArray?.count ?? 0
        }
        else if(pickerSelectedTextField == countryTextField){
            return countryNamesArray?.count ?? 0
        }
        
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if((pickerSelectedTextField == stateTextField || pickerSelectedTextField == countryStateTextField) && (stateNamesArray?.count)!-1 > row)
        {
            self.selectedItemFromPicker = self.stateNamesArray?[row] ?? ""
        }
        if((pickerSelectedTextField == cityTextField || pickerSelectedTextField == countryCityTextField) && (cityNamesArray?.count)!-1 > row)
        {
            self.selectedItemFromPicker = self.cityNamesArray?[row] ?? ""
        }
        if(pickerSelectedTextField == countryTextField && (countryNamesArray?.count)!-1 > row)
        {
            self.selectedItemFromPicker = self.countryNamesArray?[row] ?? ""
        }
    }
    
    public func reloadAllPickerViewComponents(){
        self.cityStatePicker.reloadAllComponents()
    }
    
    public func luhnCheck(number: String) -> Bool {
        var sum = 0
        let digitStrings = number.characters.reversed().map { String($0) }
        
        for tuple in digitStrings.enumerated() {
            guard let digit = Int(tuple.element) else { return false }
            let odd = tuple.offset % 2 == 1
            
            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        
        return !(sum % 10 == 0)
    }
    
    func isValidExpirationCardValues(str:String) -> Bool
    {
        var dateArr = str.components(separatedBy: "/")
        let temp_selectedMonth = dateArr[0] as String
        let temp_selectedYear = dateArr[1] as String
        let currentStr = String(format: "%d", currentYear)
        if Int(temp_selectedYear) == Int(currentStr.substring(from:currentStr.index(currentStr.endIndex, offsetBy: -2)))
        {
            if Int(temp_selectedMonth)! >= currentMonth
            {
                return true
            }
            else
            {
                return false
            }
        }
        else{
            return true
            
        }
    }
    
    // MARK: - Private Methods
    func loadYearDetails()
    {
        let date = Date()
        let calendar = Calendar.current
        
        let yearVal = calendar.component(.year, from: date)
        let monthVal = calendar.component(.month, from: date)
        
        currentYear = yearVal
        currentMonth = monthVal
        
    }
    
    public func isValidationSuccess(billingInfoModel: BillingInfoDataModel) -> (success: Bool, message: String) {
        loadYearDetails()
        var isValidationSuccess = true
        var message = ""
        if( billingInfoModel.cardNoValidation && AUUtilities.removeWhiteSpace(text: billingInfoModel.cardNo ?? "").count == 0){
            message = CONTENT_CARD_NUMBER_EMPTY
            isValidationSuccess = false
        }
        else if(billingInfoModel.cardNoValidation && luhnCheck(number: billingInfoModel.cardNo ?? "")) // card number validation
        {
            isValidationSuccess = false
            message = CONTENT_CARD_NUMBER_IN_VALID
        }
        else if billingInfoModel.cvvValidation && STPCardValidator.validationState(forNumber: billingInfoModel.cardNo, validatingCardBrand: true) != .valid {
            message = CONTENT_CARD_NUMBER_IN_VALID
            isValidationSuccess = false
        }
        else if( billingInfoModel.expiryValuesValidation && AUUtilities.removeWhiteSpace(text: billingInfoModel.expiryValues ?? "").count == 0){
            message = CONTENT_CARD_EXPIRATIONDATE_EMPTY
            isValidationSuccess = false
        }
        else if (billingInfoModel.expiryValuesValidation && isValidExpirationCardValues(str:AUUtilities.removeWhiteSpace(text: billingInfoModel.expiryValues ?? ""))) == false
        {
            isValidationSuccess = false
            message = CONTENT_CARD_EXPIRATIONDATE_VALID
        }
            
        else if(billingInfoModel.cvvValidation && AUUtilities.removeWhiteSpace(text: billingInfoModel.cvv ?? "").count == 0)
        {
            message = CONTENT_CARD_CVV_EMPTY
            isValidationSuccess = false
        }
        else if(billingInfoModel.cvvValidation && AUUtilities.removeWhiteSpace(text: billingInfoModel.cvv ?? "").count < 3)
        {
            message = CONTENT_CARD_IN_VALID_CVV
            isValidationSuccess = false
        }
        else  if billingInfoModel.cvvValidation && STPCardValidator.validationState(forCVC: billingInfoModel.cvv ?? "", cardBrand: self.cardBrand) != .valid{
            message = CONTENT_CARD_IN_VALID_CVV
            isValidationSuccess = false
        }
        else if(billingInfoModel.firstNameValidation && AUUtilities.removeWhiteSpace(text: billingInfoModel.firstName ?? "").count == 0){
            message = CONTENT_FIRST_NAME
            isValidationSuccess = false
        }
        else if(billingInfoModel.lastNameValidation && AUUtilities.removeWhiteSpace(text: billingInfoModel.lastName ?? "").count == 0){
            message = CONTENT_SECOND_NAME
            isValidationSuccess = false
        }
        else if(billingInfoModel.addressValidation && AUUtilities.removeWhiteSpace(text: billingInfoModel.address ?? "").count == 0){
            message = CONTENT_ALERT_STREET_ADDRESS
            isValidationSuccess = false
        }
        else if(billingInfoModel.stateValidation && AUUtilities.removeWhiteSpace(text: billingInfoModel.state ?? "").count == 0){
            message = CONTENT_STATE
            isValidationSuccess = false
        }
        else if(billingInfoModel.cityValidation && AUUtilities.removeWhiteSpace(text: billingInfoModel.city ?? "").count == 0){
            message = CONTENT_CITY
            isValidationSuccess = false
        }
        else if(billingInfoModel.zipCodeValidation && AUUtilities.removeWhiteSpace(text: billingInfoModel.zipCode ?? "").count == 0){
            message = CONTENT_ZIPCODE_BLANK
            isValidationSuccess = false
        }
        else if (billingInfoModel.zipCodeValidation && (AUUtilities.removeWhiteSpace(text: billingInfoModel.zipCode ?? "").count < billingInfoModel.zipCodeMin) &&  (AUUtilities.removeWhiteSpace(text: billingInfoModel.zipCode ?? "").count > billingInfoModel.zipCodeMax) ) {
            message = CONTENT_ZIPCODE_MINIMUM
            isValidationSuccess = false
        }
        
        
        
        return (success: isValidationSuccess, message: message)
    }
}

public class BillingInfoDataModel: NSObject{
    
    public var cardNo: String?
    public var cardNoValidation: Bool = true
    
    public var expiryValues: String?
    public var expiryValuesValidation: Bool = true
    
    public var cvv: String?
    public var cvvValidation: Bool = true
    
    public var firstName: String?
    public var firstNameValidation: Bool = true
    
    public var lastName: String?
    public var lastNameValidation: Bool = true
    
    public var address: String?
    public var addressValidation: Bool = true
    
    public var country: String?
    public var countryValidation: Bool = true
    
    public var state: String?
    public var stateValidation: Bool = true
    
    public var city: String?
    public var cityValidation: Bool = true
    
    public var zipCode: String?
    public var zipCodeMin: Int = 0
    public var zipCodeMax: Int = 12
    public var zipCodeIsAlphaNumeric: Bool = true
    public var zipCodeValidation : Bool = true
    
}



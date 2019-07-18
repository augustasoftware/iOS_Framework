//
//  AUListPicker.swift
//  AugustaFramework
//
//  Created by Augusta on 18/07/19.
//  Copyright © 2019 augusta. All rights reserved.
//

import UIKit

public protocol AUListPickerDelegate {
    func doneButtonAction(selectedItem: String)
    func pickerDidSelectItem(selectedItem: String, selectedIndex: Int)
}

open class AUListPicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
        
    public var pickerDataArray : [String]?
    
    @IBOutlet public weak var pickerBaseView: UIView!
    @IBOutlet public weak var searchBar: UISearchBar!
    @IBOutlet public weak var doneButton: UIButton!
    @IBOutlet public weak var pickerView: UIPickerView!
    private var selectedItemFromPicker: String?

    
    public var delegate: AUListPickerDelegate?
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.delegate?.doneButtonAction(selectedItem: self.selectedItemFromPicker ?? "")
    }
    
    
    override open func awakeFromNib() {
       
    }
    
    public override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle1 = Bundle(for: AUListPicker.self)
        bundle1.loadNibNamed("AUListPicker", owner: self, options: nil)
        guard let content = pickerBaseView else { return }
        content.frame = self.bounds
        content.translatesAutoresizingMaskIntoConstraints = false
        searchBar.setUpSearchBar()
//        self.addSubview(content)
//        guard let content1 = pickerBaseView else { return }
//        content1.frame = self.bounds
//        content1.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(content1)
//        guard let content2 = billingAddressView else { return }
//        content2.frame = self.bounds
//        content2.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(content2)
//        guard let content3 = billingAddressCountryView else { return }
//        content3.frame = self.bounds
//        content3.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(content3)
//        self.loadInitialSetup()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: UIPicker Delegate
    //MARK: UIPickerView Delegates
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerDataArray?[row] ?? ""
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataArray?.count ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedItemFromPicker = self.pickerDataArray?[row] ?? ""
        self.delegate?.pickerDidSelectItem(selectedItem: self.selectedItemFromPicker ?? "", selectedIndex: row)
        
    }
    
    public func reloadAllPickerViewComponents(){
        self.pickerView.reloadAllComponents()
    }

}

extension UISearchBar {
    
    func setUpSearchBar(){
        self.barTintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        // search bar UI changes background
        for view in self.subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground"){
                view.alpha = 0.0
            }
        }
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.clear
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .black
        
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: "Montserrat", size: 14.0)
    }
    
}

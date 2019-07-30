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
    
    public enum AUListPickerStyle{
        case defaultPicker
        case listPickerWithSearch
        case listPickerWithoutSearch
    }
        
    public var pickerDataArray : [String]?
    public var pickerDataFilteredArray:  [String] = []
    
    public var baseViewInWhichPickerToBeAdded: UIView?
    
    public var pickerStyle: AUListPickerStyle = .defaultPicker
    
    @IBOutlet public weak var pickerBaseView: UIView!
    @IBOutlet public weak var searchBar: UISearchBar!
    @IBOutlet public weak var doneButton: UIButton!
    @IBOutlet public weak var pickerView: UIPickerView!
    
    @IBOutlet public weak var pickerStyle2View: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dataView: UIView!
    
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
//        self.commonInit()
    }
    
    public func commonInit() {
        let bundle1 = Bundle(for: AUListPicker.self)
        bundle1.loadNibNamed("AUListPicker", owner: self, options: nil)
        guard let content = pickerBaseView else { return }
        content.frame = self.bounds
        content.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content)
        guard let content1 = pickerStyle2View else { return }
        content1.frame = self.bounds
        content1.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content1)
//        guard let content2 = forgotPasswordView else { return }
//        content2.frame = self.bounds
//        content2.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(content2)
        searchBar.setUpSearchBar()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.dataView.frame.size = CGSize.init(width: self.dataView.frame.size.width, height: self.dataView.frame.size.height - 170)
                        self.tblMenu.frame.size = CGSize.init(width: self.tblMenu.frame.size.width, height: self.tblMenu.frame.size.height - 170)
        }, completion: {(_ completed: Bool) -> Void in
            
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.dataView.frame.size = CGSize.init(width: self.dataView.frame.size.width, height: self.dataView.frame.size.height + 170)
                        self.tblMenu.frame.size = CGSize.init(width: self.tblMenu.frame.size.width, height: self.tblMenu.frame.size.height + 170)
        }, completion: {(_ completed: Bool) -> Void in
            
        })
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // filter data
        if(searchText.isEmpty)
        {
            self.pickerDataFilteredArray = self.pickerDataArray ?? []
            self.tblMenu.reloadData()
            return
        }
        
        let array = self.pickerDataArray
        self.pickerDataFilteredArray = array?.filter { $0.lowercased().contains(searchText.lowercased()) ?? false } ?? []
        
       
        
        self.tblMenu.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func configureViewAndData(textFields: [UITextField], baseView: UIView){
        if(pickerStyle == .defaultPicker){
            for textField in textFields{
                textField.inputView = self.pickerBaseView
            }
        }
        else{
//            baseViewInWhichPickerToBeAdded = baseView
//            for textField in textFields{
//
////                textField.addTarget(self, action: #selector(textFieldDidBegin(_:)), for: .editingDidBegin)
//                textField.inputView = nil
//            }
//
           
        }
    }
    
    @objc func textFieldDidBegin(_ textField: UITextField) {
//        self.pickerStyle2View.isHidden = false
//        textField.resignFirstResponder()
    }
   
}


//MARK:- UITableView Delegate & Datasources
extension AUListPicker: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerDataFilteredArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.callNotificaitonCell(indexPath: indexPath)
    }
    
    func callNotificaitonCell(indexPath: IndexPath) -> AUListPickerTableViewCell {
        let jobCell:AUListPickerTableViewCell = self.tblMenu.dequeueReusableCell(withIdentifier: "", for: indexPath) as! AUListPickerTableViewCell
        
        let obj = self.pickerDataFilteredArray[indexPath.row]
        jobCell.mainLabel.text = obj
        
        return jobCell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        self.selectedItemFromPicker = self.pickerDataFilteredArray[indexPath.row] ?? ""
        self.delegate?.pickerDidSelectItem(selectedItem: self.selectedItemFromPicker ?? "", selectedIndex: indexPath.row)
        self.dismiss()
       
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
    }
    
    //dismiss me
    func dismiss(){
        self.pickerStyle2View.removeFromSuperview()
        //self.dismiss(animated: false, completion: nil)
    }
    
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
        
        if(pickerStyle == .defaultPicker){
            self.pickerView.reloadAllComponents()
        }
        else{
            self.searchBar.text = ""
            self.tblMenu.reloadData()
//            self.baseViewInWhichPickerToBeAdded?.addSubview(self.pickerStyle2View)
        }
        
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

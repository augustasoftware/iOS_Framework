//
//  ViewController.swift
//  TestAugustaFramework
//
//  Created by Augusta on 12/07/19.
//  Copyright © 2019 augusta. All rights reserved.
//

import UIKit
import AugustaFramework

class ViewController:AUBaseViewController, UITextFieldDelegate, AUListPickerDelegate {

    @IBOutlet weak var testTextField2: UITextField!
    @IBOutlet weak var testTextField: UITextField!
    
    var pickerView: AUListPicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
        pickerView = AUListPicker.init()
        pickerView?.delegate  = self
        testTextField.inputView = pickerView?.pickerBaseView
        testTextField2.inputView = pickerView?.pickerBaseView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func doneButtonAction(selectedItem: String) {
        debugPrint(selectedItem)
    }
    
    func pickerDidSelectItem(selectedItem: String, selectedIndex: Int) {
        debugPrint(selectedItem)
        debugPrint(selectedIndex)
    }

    func tryOutAlertHandler()    {
                    let alertButtonData1: AUAlertButtonModel = AUAlertButtonModel.init(actionTitle: "ok", actionStyle: .default, index: 0)
                    let alertButtonData2: AUAlertButtonModel = AUAlertButtonModel.init(actionTitle: "cancel", actionStyle: .default, index: 1)
                    let alertButtonData3: AUAlertButtonModel = AUAlertButtonModel.init(actionTitle: "cancel2", actionStyle: .default, index: 2)
                    let alertButtonData4: AUAlertButtonModel = AUAlertButtonModel.init(actionTitle: "cancel3", actionStyle: .cancel, index: 3)
        
                    let alertData: AUAlertModel = AUAlertModel.init(title: "Alert", message: "abcdefghijklmnopqrstuvwxyz", buttonModels: [alertButtonData1], style: .alert, controller: self)
                    AUAlertHandler.showAlertView(alertData: alertData, handler: {[unowned self] (index) in
                        print(index)
                        switch(index){
                        case 1:
                            break
                        case 2:
                            break
                        default:
                            break
                        }
                    })
        
                }
    
    
    
    //MARK: TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == testTextField){
            pickerView?.pickerDataArray = ["1","2","Erode","Chennai","Coimbatore"]
            pickerView?.reloadAllPickerViewComponents()
        }
        else if(textField == testTextField2){
            pickerView?.pickerDataArray = ["TN","AP","TS","KL","GA","MH","DL"]
            pickerView?.reloadAllPickerViewComponents()
        }
        
    }
}


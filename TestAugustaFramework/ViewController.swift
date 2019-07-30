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
    
    var listPickerView: AUListPicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tryOutAlertHandler()
    }
    
    @IBAction func showAction(_ sender: Any) {
        tryOutAlertHandler()
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
        
        let themer  = AUAlertThemerValues()
        themer.backGroundColor = .white
        themer.buttonTextColor = .red
        themer.titleColor = .black
        themer.textColor = .darkGray
                    let alertData: AUAlertModel = AUAlertModel.init(title: "Alert", message: "abcdefghijklmnopqrstuvwxyz", buttonModels: [alertButtonData1, alertButtonData2,alertButtonData4], style: .alert, controller: self)
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
                    }, style: .Custom, themer: themer)
        
                }
    
    
    
    //MARK: TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == testTextField){
            listPickerView.pickerDataArray = ["1","2","Erode","Chennai","Coimbatore"]
            listPickerView.reloadAllPickerViewComponents()
           
        }
        else if(textField == testTextField2){
            listPickerView.pickerDataArray = ["TN","AP","TS","KL","GA","MH","DL"]
            listPickerView.reloadAllPickerViewComponents()
        }
        
    }
}


//
//  ViewController.swift
//  TestAugustaFramework
//
//  Created by Augusta on 12/07/19.
//  Copyright © 2019 augusta. All rights reserved.
//

import UIKit
import AugustaFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tryOutAlertHandler()
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
}


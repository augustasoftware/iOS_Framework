//
//  AUBillingInfoManager.swift
//  AugustaFramework
//
//  Created by augusta on 31/07/18.
//  Copyright © 2018 augusta. All rights reserved.
//

import Foundation
import UIKit
import PayCardsRecognizer

public protocol AUBillingCardScanningDelegate{
    func cameraDidScanCard(with Result: PayCardsRecognizerResult)
}

public class AUBillingInfoManager{
    
    var recognizer: PayCardsRecognizer?
    var delegate: AUBillingCardScanningDelegate?
    
    public init(){
        
    }
    
    public func startScan(from view: UIView, borderColor: UIColor, mode: PayCardsRecognizerDataMode = .number, resultMode: PayCardsRecognizerResultMode = .sync){
        recognizer = PayCardsRecognizer(delegate: self, recognizerMode: .number, resultMode: .sync, container: view, frameColor: borderColor)
        recognizer?.startCamera()
    }
    
    public func stopScan(){
        if(recognizer != nil){
            recognizer?.stopCamera()
        }
    }
    
}

extension AUBillingInfoManager: PayCardsRecognizerPlatformDelegate{
    
    // PayCardsRecognizerPlatformDelegate
    
    public func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        recognizer?.stopCamera()
        self.delegate?.cameraDidScanCard(with: result)
//        cardNoTextField.text = result.recognizedNumber // Card number
//        cardNameTextField.text = result.recognizedHolderName // Card holder
//        cardMonthTextField.text = result.recognizedExpireDateMonth // Expire month
//        cardYearTextField.text = result.recognizedExpireDateYear // Expire year
//        (scanButton as! UIButton).setTitle("Scan Card", for: UIControlState.normal)
    }
}

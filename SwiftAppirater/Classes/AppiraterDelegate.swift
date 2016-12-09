//
//  AppiraterDelegate.swift
//  Pods
//
//  Created by Zhou Hao on 08/12/16.
//
//

import Foundation

protocol AppiraterDelegate: class {
    
    func appiraterShouldDisplayAlert(_ appirater: Appirater) -> Bool
    
    func appiraterDidDisplayAlert(_ appirater: Appirater)
    
    func appiraterDidDecline(toRate appirater: Appirater)
    
    func appiraterDidOpt(toRate appirater: Appirater)
    
    func appiraterDidOpt(toRemindLater appirater: Appirater)
    
    func appiraterWillPresentModalView(_ appirater: Appirater, animated: Bool)
    
    func appiraterDidDismissModalView(_ appirater: Appirater, animated: Bool)
}

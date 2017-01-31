//
//  GQPeripheralViewController.swift
//  GlobalQuizRemote
//
//  Created by Alexander Lukashevich  on 1/31/17.
//  Copyright © 2017 Alexander Lukashevich . All rights reserved.
//

import UIKit
import CoreBluetooth

class GQPeripheralViewController: UIViewController, CBPeripheralManagerDelegate {
  
  var peripheralManager:CBPeripheralManager?
  var transferChar:CBMutableCharacteristic?
  var dataToSend:Data?
  var sendDataIndex:Int = 0

  let SERVICE_UUID =
    CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
  
    override func viewDidLoad() {
        super.viewDidLoad()

peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
      peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey:SERVICE_UUID])
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    
    if #available(iOS 10.0, *) {
      if peripheral.state == CBManagerState.poweredOn {
        transferChar = CBMutableCharacteristic.init(type: SERVICE_UUID, properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.readable)
        
        let transferService = CBMutableService.init(type: SERVICE_UUID, primary: true)
        transferService.characteristics = [transferChar!]
        peripheralManager?.add(transferService)
      }
    } else {
      
    }
  }
  
  
  func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
    
    dataToSend = "SUCCESS".data(using:String.Encoding.utf8)
    sendDataIndex = 0
    sendData()
  }

  func sendData(){
    print("Sending data")
  }
  
  func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
    sendData()

  }

}

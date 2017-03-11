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
    var receiveChar:CBMutableCharacteristic?

  var dataToSend:Data?
  var sendDataIndex:Int = 0

   
    let SENDING_DATA_CHAR =
        CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74dd")
    
    let RECEIVE_DATA_CHAR =
        CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74bb")
    
    let MAIN_SERVICE =
        CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74aa")
    
    override func viewDidLoad() {
        super.viewDidLoad()

peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
        
      peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey:MAIN_SERVICE])
        
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        peripheralManager?.respond(to: requests.first!, withResult:.success)
        transferChar?.value = requests.first?.value
        print(transferChar?.value)
        print(requests)

//        let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: (requests.first?.value)!) as? [String : Any]
        print(NSString(data: (transferChar?.value)!, encoding: String.Encoding.utf8.rawValue))
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("readRequest")

    }
  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    
    print("peripheralManagerDidUpdateState")

    if #available(iOS 10.0, *) {
        print("here")

      if peripheral.state == CBManagerState.poweredOn {

        let mainService = CBMutableService.init(type: MAIN_SERVICE, primary: true)

        transferChar = CBMutableCharacteristic.init(type: SENDING_DATA_CHAR, properties: CBCharacteristicProperties.write, value: nil, permissions: CBAttributePermissions.writeable)
        
        receiveChar = CBMutableCharacteristic.init(type: RECEIVE_DATA_CHAR, properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.writeable)

        mainService.characteristics = [receiveChar!, transferChar!]
        peripheralManager?.add(mainService)

      }
    } else {
      
    }
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
    print("didSubscribeTo")

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

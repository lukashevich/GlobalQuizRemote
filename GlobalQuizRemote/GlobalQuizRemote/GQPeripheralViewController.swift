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
  var enableAnswerChar:CBMutableCharacteristic?
  var startGameChar:CBMutableCharacteristic?
  var answerChar:CBMutableCharacteristic?
  
  var answerController:ViewController?
  var dataToSend:Data?
  var sendDataIndex:Int = 0
  
  let ENABLE_ANSWER_CHAR =
    CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74dd")
  let ANSWER_CHAR =
    CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74db")
  let START_GAME_CHAR =
    CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74bb")
  
  let MAIN_SERVICE_1 =
    CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74aa")
//  let MAIN_SERVICE_2 =
//    CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74ab")
  
  override func viewDidLoad() {
    super.viewDidLoad()

    
    answerController = ViewController()
    answerController?.peripheralVC = self
    
    peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
    peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey:ANSWER_CHAR])
    
  }
  
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
    peripheralManager?.respond(to: requests.first!, withResult:.success)
    print(NSString(data: (requests.first?.value)!, encoding: String.Encoding.utf8.rawValue) ?? "FUCK")
    let split = NSString(data: (requests.first?.value)!, encoding: String.Encoding.utf8.rawValue)?.components(separatedBy: ",")
    if (split?.first?.isEqual("Start"))!{
      startGameChar?.value = requests.first?.value
      print("startGameChar")
      print(Int((split?.last)!) ?? "FUCK")
      print((split?.last)!)

      let userDef:UserDefaults = UserDefaults.standard
      userDef.set(Int((split?.last)!), forKey: "playerId")
      userDef.synchronize()
      
      performSegue(withIdentifier: "toPeripheral", sender: self)
      //            navigationController?.pushViewController(answerController!, animated: true)
    }else if (NSString(data: (enableAnswerChar?.value)!, encoding: String.Encoding.utf8.rawValue)?.isEqual(to: "Start"))!{
      enableAnswerChar?.value = requests.first?.value
      answerController?.received(action: NSString(data: (enableAnswerChar?.value)!, encoding: String.Encoding.utf8.rawValue)! as String)
    }
    //        let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: (requests.first?.value)!) as? [String : Any]
  }
  func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
    print("readRequest")
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier ==  "toPeripheral" {
      (segue.destination as! ViewController).peripheralVC = self
    }
  }
  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    
    print("peripheralManagerDidUpdateState")
    
    let mainService = CBMutableService.init(type: MAIN_SERVICE_1, primary: true)

    
    if #available(iOS 10.0, *) {
      print("here")
      
      if peripheral.state == CBManagerState.poweredOn {
        
        
        enableAnswerChar = CBMutableCharacteristic.init(type: ENABLE_ANSWER_CHAR, properties: CBCharacteristicProperties.write, value: nil, permissions: CBAttributePermissions.writeable)
        
        startGameChar = CBMutableCharacteristic.init(type: START_GAME_CHAR, properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.writeable)
        
        answerChar = CBMutableCharacteristic.init(type: ANSWER_CHAR, properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.readable)
        mainService.characteristics = [startGameChar!, enableAnswerChar!, answerChar!]
        peripheralManager?.add(mainService)
        peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey:ANSWER_CHAR])
        
        
      }
    } else {
      
      switch peripheral.state{
      case .poweredOn:
        
        enableAnswerChar = CBMutableCharacteristic.init(type: ENABLE_ANSWER_CHAR, properties: CBCharacteristicProperties.write, value: nil, permissions: CBAttributePermissions.writeable)
        
        startGameChar = CBMutableCharacteristic.init(type: START_GAME_CHAR, properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.writeable)
        
        answerChar = CBMutableCharacteristic.init(type: ANSWER_CHAR, properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.readable)
        mainService.characteristics = [startGameChar!, enableAnswerChar!, answerChar!]
        peripheralManager?.add(mainService)
        peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey:ANSWER_CHAR])
        
        break
      case .poweredOff:
        NSLog("CoreBluetooth BLE hardware is powered off");
        break;
      case .unauthorized:
        NSLog("CoreBluetooth BLE state is unauthorized");
        break
      case .unknown:
        NSLog("CoreBluetooth BLE state is unknown");
        break;
      case .unsupported:
        NSLog("CoreBluetooth BLE hardware is unsupported on this platform");
        break;
      default:
        break
      }
      
    }
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
    print("service added")
    print(service.characteristics)
    print(error.debugDescription)
    
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

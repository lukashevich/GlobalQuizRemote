//
//  ViewController.swift
//  GlobalQuizRemote
//
//  Created by Alexander Lukashevich  on 1/26/17.
//  Copyright © 2017 Alexander Lukashevich . All rights reserved.
//

import UIKit
import CoreBluetooth
import Alamofire

class ViewController: UIViewController,CBCentralManagerDelegate,
CBPeripheralDelegate {

  var manager:CBCentralManager!
  var peripheral:CBPeripheral!
  let serverName = "http://quiz.vany.od.ua/wp-json/quiz"
  //  let serverName = "http://quiz.vany.od.ua"

//  quiz.vany.od.ua/wp-json/quiz/test
  
  @IBOutlet weak var firstAnswer: UIButton!
  @IBOutlet weak var secondAnswer: UIButton!
  @IBOutlet weak var thirdAnswer: UIButton!
  @IBOutlet weak var fourthAnswer: UIButton!
  
  
  let BEAN_NAME = "Robu"
  let BEAN_SCRATCH_UUID =
    CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
  let BEAN_SERVICE_UUID =
    CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    manager = CBCentralManager(delegate: self, queue: nil)
  }

  
  func requestToServer(methodName:String){
   
    let serverMethodName = methodName
    
    let requestStr = serverName + "/" + serverMethodName + "/"
     print(requestStr)
    
    Alamofire.request(requestStr).responseJSON { response in
      print(response.request ?? "")  // original URL request
      print("\n")
      print(response.response ?? "") // HTTP URL response
      print("\n")
      print(response.data ?? "")     // server data
      
      print("\n")
      //      print(response.request )   // result of response serialization
      //
      if let JSON:[[String:AnyObject]] = response.result.value as? [[String:AnyObject]]{

              print("JSON: \(JSON)")
            }
    }
    
    


  }
  
   override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func centralManagerDidUpdateState(_ central: CBCentralManager){
    switch (central.state) {
    case CBManagerState.poweredOff:
      print("BLE powered off")
//      self.clearDevices()
      
    case CBManagerState.unauthorized:
      // Indicate to user that the iOS device does not support BLE.
      print("BLE not supported")
      break
      
    case CBManagerState.unknown:
      // Wait for another event
      print("BLE unknown event")
      break
      
    case CBManagerState.poweredOn:
      print("BLE powered on")
      self.startScanning()
      break
      
    case CBManagerState.resetting:
      print("BLE reset")
//      self.clearDevices()
      
    case CBManagerState.unsupported:
      print("BLE unsupported event")
      break
    }
  }
  
  func startScanning() {
    print("\(NSDate()) Start scanning...")
    
      _ = [CBCentralManagerScanOptionAllowDuplicatesKey : true]
      let ble = [CBUUID(string: "B737D0FF-AF53-9B83-E5D2-922140A9FFFF")]
      manager.scanForPeripherals(withServices: ble, options: nil)
  }
  
  private func centralManager(
    central: CBCentralManager,
    didDiscoverPeripheral peripheral: CBPeripheral,
    advertisementData: [String : AnyObject],
    RSSI: NSNumber) {
    let device = (advertisementData as NSDictionary)
      .object(forKey: CBAdvertisementDataLocalNameKey)
      as? NSString
    
    if device?.contains(BEAN_NAME) == true {
      self.manager.stopScan()
      
      self.peripheral = peripheral
      self.peripheral.delegate = self
      
      manager.connect(peripheral, options: nil)
    }
  }
  
  func peripheral(
    _ peripheral: CBPeripheral,
    didDiscoverCharacteristicsFor service: CBService,
    error: Error?) {
    for characteristic in service.characteristics! {
      let thisCharacteristic = characteristic as CBCharacteristic
      
      if thisCharacteristic.uuid == BEAN_SCRATCH_UUID {
        self.peripheral.setNotifyValue(
          true,
          for: thisCharacteristic
        )
      }
    }
  }
  
  
  @IBAction func aswerPressed(_ sender: Any) {
    let answerButton:UIButton = sender as! UIButton
    
    requestToServer(methodName: "test")
    
    switch answerButton {
    case firstAnswer :
       print("firstAnswer")
       break
    case secondAnswer :
      print("secondAnswer")
      break
    case thirdAnswer :
      print("thirdAnswer")
      break
    case fourthAnswer :
      print("fourthAnswer")
      break
      
    default:
      print("WTF !?")

    }
   
    
  }

  
}



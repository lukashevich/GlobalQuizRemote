//
//  ViewController.swift
//  GlobalQuizRemote
//
//  Created by Alexander Lukashevich  on 1/26/17.
//  Copyright © 2017 Alexander Lukashevich . All rights reserved.
//

import UIKit
import AudioToolbox
import CoreBluetooth
import Alamofire

protocol BTControllerDelegate: class {
    func received(action: String)
}

class ViewController: UIViewController,BTControllerDelegate {

    weak var delegate:CBPeripheralManagerDelegate?
    var peripheralVC:GQPeripheralViewController?
  var centralManager:CBCentralManager?
  var discoveredPeripheral:CBPeripheral?
  var data:NSMutableData?
//  var manager:CBCentralManager!
//  var peripheral:CBPeripheral!
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

//    centralManager = CBCentralManager.init(delegate: self, queue: nil)
//    data = NSMutableData()
//    
//    }
//
//  func centralManagerDidUpdateState(_ central: CBCentralManager) {
//    
//    if #available(iOS 10.0, *) {
//      switch central.state{
//      case CBManagerState.unauthorized:
//        print("This app is not authorised to use Bluetooth low energy")
//      case CBManagerState.poweredOff:
//        print("Bluetooth is currently powered off.")
//      case CBManagerState.poweredOn:
//        print("Bluetooth is currently powered on and available to use.")
//        centralManager?.scanForPeripherals(withServices: [BEAN_SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
//      default:break
//      }
//    } else {
//      
//      // Fallback on earlier versions
//      switch central.state as! CBCentralManagerState {
//      case CBCentralManagerState.unauthorized:
//        print("This app is not authorised to use Bluetooth low energy")
//      case CBCentralManagerState.poweredOff:
//        print("Bluetooth is currently powered off.")
//      case CBCentralManagerState.poweredOn:
//        print("Bluetooth is currently powered on and available to use.")
//        centralManager?.scanForPeripherals(withServices: [BEAN_SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
//      default:break
//      }
//    }
  }
  
//  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//    print("DIscovered ")
//    print(peripheral.name ?? "NOTHING")
//    print(RSSI)
//    
//    if discoveredPeripheral != peripheral {
//      discoveredPeripheral = peripheral
//      print("Connecting ")
//      centralManager?.connect(peripheral, options: nil)
//
//    }
//
//  }
  
//  func requestToServer(methodName:String){
//   
//    
//    let serverMethodName = methodName
//    
//    let requestStr = serverName + "/" + serverMethodName + "/"
//     print(requestStr)
//    
//    Alamofire.request(requestStr).responseJSON { response in
//      print(response.request ?? "")  // original URL request
//      print("\n")
//      print(response.response ?? "") // HTTP URL response
//      print("\n")
//      print(response.data ?? "")     // server data
//      
//      print("\n")
//      //      print(response.request )   // result of response serialization
//      //
//      if let JSON:[[String:AnyObject]] = response.result.value as? [[String:AnyObject]]{
//
//              print("JSON: \(JSON)")
//            }
//    }
//    
//    
//
//
//  }
  
   override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


//  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//    for service:CBService in peripheral.services! {
//      peripheral.discoverCharacteristics([BEAN_SERVICE_UUID], for: service)
//    }
//  }
//  
//  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//    for char:CBCharacteristic in service.characteristics! {
//      if  char.uuid.isEqual(BEAN_SERVICE_UUID) {
//        peripheral.setNotifyValue(true, for: char)
//      }
//    }
//  }
//  
//  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//    
//    let strFromData:NSString = NSString.init(data: data?.copy() as! Data, encoding: String.Encoding.utf8.rawValue)!
//    
//    if strFromData.isEqual("EOM") {
//      
//      peripheral.setNotifyValue(false, for: characteristic)
//      centralManager?.cancelPeripheralConnection(peripheral)
//    }
//    
//    data?.append(characteristic.value!)
//    
//  }
//  
//  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//    
//    if characteristic.isNotifying {
//      print("Notification begins")
//    } else {
//       centralManager?.cancelPeripheralConnection(peripheral)
//    }
//  }
//  
//  
//  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//    discoveredPeripheral = nil
//    centralManager?.scanForPeripherals(withServices: [BEAN_SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
//  }

  @IBAction func aswerPressed(_ sender: Any) {
    let answerButton:UIButton = sender as! UIButton
    
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

//    var answer:String = ""
//    
//    switch answerButton {
//    case firstAnswer :
//       answer = "firstAnswer"
//       break
//    case secondAnswer :
//      answer = "secondAnswer"
//      break
//    case thirdAnswer :
//       answer = "thirdAnswer"
//      break
//    case fourthAnswer :
//      answer = "fourthAnswer"
//      break
//      
//    default:
//      print("WTF !?")
//
//    }

    let userDef = UserDefaults.standard
    

//    let answer:NSMutableDictionary = NSMutableDictionary()
//    answer.setObject(answerButton.tag, forKey: "answer" as NSCopying)
//    answer.setObject(Date().timeIntervalSince1970, forKey: "time" as NSCopying)
//    answer.setObject(userDef.integer(forKey: "id"), forKey: "id" as NSCopying)
//
//    let answerData: Data = NSKeyedArchiver.archivedData(withRootObject: answer)
    let playerId = userDef.integer(forKey: "playerId")//\"id\":\(playerId),
//    let time  = Date().timeIntervalSince1970//\"time\":\(time),
    let answer  = answerButton.tag

    let answerData:Data = "\(answer),\(playerId)".data(using: .utf8)!
    print(answerData.count)
    peripheralVC?.peripheralManager?.updateValue(answerData, for: (peripheralVC?.answerChar!)!, onSubscribedCentrals: nil)

    
    
  }
    
    func received(action: String) {
        
        
    }

  
}




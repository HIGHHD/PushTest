//
//  ViewController.swift
//  IOSXPush
//
//  Created by zlqhjs on 16/10/13.
//  Copyright © 2016年 siyuan. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(pushMyLi(notification:)), name: NSNotification.Name(rawValue: "TEST_NAME"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "TEST_NAME"), object: nil)
    }
    func pushMyLi(notification: Notification) {
        let bvc = self.viewControllers?[1] as! BViewController
        bvc.param = notification.userInfo as! [String: String]
        bvc.doLabel()
    }
}

class BViewController: UIViewController {
    var param = [String: String]()
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func doLabel() {
        
        self.label1.text = self.param["reply"]
        self.label2.text = self.param["atta"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pushANoti(_ sender: UIButton) {
        self.updateNotification()
    }

    @IBAction func deletep(_ sender: AnyObject) {
        self.getNotification()
        self.doNotis(type: 2)
    }
    @IBAction func deleted(_ sender: UIButton) {
        self.getNotification()
        self.doNotis(type: 1)
    }
    
    func getNotification() {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            print(notifications)
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            print(notifications)
        }
    }
    
    func doNotis(type: Int) {
        switch type {
        case 1:
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        case 2:
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        default:
            break
        }
    }
    
    func updateNotification() {
        let requestIdentifer = "TestRequest"
        let request = UNNotificationRequest(identifier: requestIdentifer, content: self.setContent(), trigger: self.setTrigger(type: 1))
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error)
            print("还是这里ooooooooooooo")
        }
    }
    
    func setContent() ->  UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = "Test"
        content.subtitle = "1234567"
        content.body = "Copyright © 2016年 jpush. All rights reserved."
        content.badge = 1
        let path = Bundle.main.path(forResource: "em_alarm_d", ofType: "png")
        var att: UNNotificationAttachment?
        enum attError: Error {
            case FoundNil(String)
        }
        
        do {
            att = try? UNNotificationAttachment(identifier: "att1", url: URL.init(fileURLWithPath: path!), options: nil)
            guard (att != nil) else {
                //MARK:ceshi
                throw attError.FoundNil("this is nil")
            }
        } catch let error as Error? {
            print("?>?>?>?>?>?>?>?>?>?>?>?>?")
            print(error)
        }
        content.attachments = [att!]
        content.categoryIdentifier = "category1"
        content.launchImageName = "Default"
        content.sound = UNNotificationSound.default()
        return content
    }
    
    func setTrigger(type: Int) -> UNNotificationTrigger {
        var trigger: UNNotificationTrigger?
        switch type {
        case 1:
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        case 2:
            var dateComponent = DateComponents()
            dateComponent.weekday = 4
            dateComponent.hour = 15
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        case 3:
            let cen = CLLocationCoordinate2D(latitude: 39.943793, longitude: 116.43959)
            let region = CLCircularRegion(center: cen, radius: 500.0, identifier: "center")
            region.notifyOnExit = false
            region.notifyOnEntry = true
            trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        default:
            break
        }
        return trigger!
    }
}


//
//  ViewController3.swift
//  fotovk
//
//  Created by Алексей on 18.01.17.
//  Copyright © 2017 Alex.Stepanoff. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyVK
import SwiftyJSON
import CloudKit

class ViewController3: UIViewController {

    var vkid: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var vkscreenName: String = ""
    var vkid2: Int = 0
    var firstName2: String = ""
    var lastName2: String = ""
    var vkscreenName2: String = ""
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var switch1: UISwitch!
    
    @IBOutlet weak var switch2: UISwitch!
    
    @IBAction func buttoncheck(_ sender: Any) {
        spinner.startAnimating()
        var text1textfield: String = textfield.text!
        if text1textfield == "" {
            let alert = UIAlertController(title: "Error", message: "press id or link", preferredStyle: .alert)
            let cancelalert = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(cancelalert)
            present(alert, animated: true, completion: nil)
        }
        if text1textfield != "" {
            for character in (text1textfield.characters) {
                if character == "/" {
                    let startIndex = text1textfield.characters.startIndex
                    let startcount = text1textfield.characters
                    let text2 = startcount.index(of: "/")!
                    let text3 = startcount.index(after: text2)
                    text1textfield = text1textfield[text3..<text1textfield.endIndex]
                }
            }
        }
            getprepareuser (usertext: text1textfield)
            getpreparegroup (usertext: text1textfield)
    }
    
    @IBAction func buttonsave(_ sender: Any) {
        let pastLink = fotovkbase()
        if vkid != 0 {
            pastLink.fotovkid = vkid
            pastLink.fotovknamefirst = firstName
            pastLink.fotovknamelast = lastName
            pastLink.fotovknamescreen = firstName + " " + lastName
            pastLink.fotovkboolgroupe = true
        }
        if vkid2 != 0 {
            pastLink.fotovkid = vkid2
            pastLink.fotovknamefirst = firstName2
            pastLink.fotovknamelast = lastName2
            pastLink.fotovknamescreen = firstName2
            pastLink.fotovkboolgroupe = true
        }
        let record = CKRecord(recordType: "fotovk")
        record.setValue(pastLink.fotovkid, forKey: "fotovkid")
        record.setValue(pastLink.fotovknamefirst, forKey: "fotovknamefirst")
        record.setValue(pastLink.fotovknamelast, forKey: "fotovknamelast")
        record.setValue(pastLink.fotovknamescreen, forKey: "fotovknamescreen")
        let privateDataBase = CKContainer.default().privateCloudDatabase
        privateDataBase.save(record, completionHandler: { record, error in
            if error != nil {
                print(error)
            }else {}
        })
        
        // Get the default Realm
        let realm = try! Realm()
        try! realm.write {
            realm.add(pastLink)
        }
        writepicstobase()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttoncancel(_ sender: Any) {
               self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var buttonsave1: ButtonSet!
    
    @IBOutlet weak var buttoncancel1: ButtonSet!
    
    @IBOutlet weak var buttoncheck1: ButtonSet!
    
    @IBAction func switch11(_ sender: Any) {
        if switch1.isOn {
            switch2.setOn(false, animated: true)
            buttonsave1.isEnabled = true
        }
    }
    
    @IBAction func switch21(_ sender: Any) {
        if switch2.isOn {
            switch1.setOn(false, animated: true)
            buttonsave1.isEnabled = true
        }
    }
    
    func chanceswitch ()
    {
        if (vkid != 0 && vkid2 == 0) {
            self.label1.text = vkscreenName
            switch1.isHidden = false
        }
        if (vkid2 != 0 && vkid == 0) {
            self.label1.text = firstName2
            switch1.isHidden = false
        }
        if (vkid != 0 && vkid2 != 0) {
            self.label1.text = vkscreenName
            switch1.isHidden = false
            self.label2.text = firstName2
            switch2.isHidden = false
        }
        spinner.stopAnimating()
    }

    
    func getprepareuser(usertext: String)
    {
        var preparedReq = VK.API.Users.get()
        preparedReq.add(parameters: [VK.Arg.userIDs : usertext])
        preparedReq.add(parameters: [VK.Arg.fields : "screen_name"])
        preparedReq.send(
            onSuccess:
            {
                response in
                DispatchQueue.main.sync(execute: {
                self.vkid = response[0,"id"].intValue
                self.firstName = response[0,"first_name"].stringValue
                self.lastName = response[0,"last_name"].stringValue
                self.vkscreenName = self.firstName + " " + self.lastName
                self.chanceswitch()
                })
                },
            onError: {error in print("SwiftyVK: users.get fail \n \(error)")}
        )
    }
    
    
    func getpreparegroup(usertext: String)
    {
        var preparedReq2 = VK.API.Groups.getById()
        preparedReq2.add(parameters: [VK.Arg.groupIds : usertext])
        preparedReq2.send(
            onSuccess:
            {
                response in
                DispatchQueue.main.sync(execute: {
                self.vkid2 = response[0,"id"].intValue
                self.firstName2 = response[0,"name"].stringValue
                self.vkid2 = -self.vkid2
                self.chanceswitch()
                })
        },
            onError: {error in print("SwiftyVK: group.get fail \n \(error)")}
        )

    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch1.isHidden = true
        switch2.isHidden = true
        buttonsave1.isEnabled = false
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2, y:2)
        spinner.transform = transform
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}

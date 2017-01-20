//
//  TableViewController2.swift
//  fotovk
//
//  Created by Алексей on 27.12.16.
//  Copyright © 2016 Alex.Stepanoff. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyVK
import SwiftyJSON

class TableViewController2: UITableViewController {

    
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var switch1: UISwitch!
    
    @IBOutlet weak var switch2: UISwitch!
    
    var vkid: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var vkscreenName: String = ""
    var vkid2: Int = 0
    var firstName2: String = ""
    var lastName2: String = ""
    var vkscreenName2: String = ""

    
    @IBAction func buttoncheck(_ sender: UIButton) {
     activityindicator.isHidden = false
        activityindicator.startAnimating()
        var text1textfield: String = textfield.text!
        if text1textfield == "" {
            let alert = UIAlertController(title: "Error", message: "press id or link", preferredStyle: .alert)
            let cancelalert = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(cancelalert)
            present(alert, animated: true, completion: nil)
        }
        
        if text1textfield != "" {
            
            // обрезаем строку до id
            
            for character in (text1textfield.characters) {
                if character == "/" {
                    let startIndex = text1textfield.characters.startIndex
                    let startcount = text1textfield.characters
                    let text2 = startcount.index(of: "/")!
                    let text3 = startcount.index(after: text2)
                    text1textfield = text1textfield[text3..<text1textfield.endIndex]
                    // text1textfield содержиит нашу строку без лишних символов
                }
            }
            
        }

        reciveuserfromvk (usertext: text1textfield) {
            (result: Int) in
            self.chanceswitch ()
        }

    }

func chanceswitch ()
{
    activityindicator.stopAnimating()
    activityindicator.isHidden = true
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

    
    }
    
    
    @IBAction func buttonsave(_ sender: UIButton) {
        
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
        
        
        // Get the default Realm
        let realm = try! Realm()

        try! realm.write {
            realm.add(pastLink)
        }
        writepicstobase()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func buttoncancel(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var buttonsave1: UIButton!
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var buttoncancel1: UIButton!
    
    @IBOutlet weak var buttoncheck1: UIButton!
    
    @IBAction func switch11(_ sender: UISwitch) {
        if switch1.isOn {
            switch2.setOn(false, animated: true)
            buttonsave1.isEnabled = true
        }
    }
    
    @IBAction func switch21(_ sender: UISwitch) {
        if switch2.isOn {
            switch1.setOn(false, animated: true)
            buttonsave1.isEnabled = true
    }
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        switch1.isHidden = true
        switch2.isHidden = true
        buttonsave1.layer.cornerRadius = 10
        buttoncancel1.layer.cornerRadius = 10
        buttoncheck1.layer.cornerRadius = 10
        buttonsave1.isEnabled = false
        activityindicator.isHidden = true
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reciveuserfromvk (usertext: String, completion: @escaping (_ result: Int) -> Void)
    {

        var preparedReq = VK.API.Users.get()
        preparedReq.add(parameters: [VK.Arg.userIDs : usertext])
        preparedReq.add(parameters: [VK.Arg.fields : "screen_name"])
        preparedReq.send(
            onSuccess:
            {
                response in
                print(response)
                self.vkid = response[0,"id"].intValue
                self.firstName = response[0,"first_name"].stringValue
                self.lastName = response[0,"last_name"].stringValue
                self.vkscreenName = self.firstName + " " + self.lastName
                completion(self.vkid)

        },
            onError: {error in print("SwiftyVK: users.get fail \n \(error)")}
        )

        
        // второй
        var preparedReq2 = VK.API.Groups.getById()
        preparedReq2.add(parameters: [VK.Arg.groupIds : usertext])
        preparedReq2.send(
            onSuccess:
            {
                response in
                self.vkid2 = response[0,"id"].intValue
                self.firstName2 = response[0,"name"].stringValue
                self.vkid2 = -self.vkid2
        },
            onError: {error in print("SwiftyVK: group.get fail \n \(error)")}
        )

    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

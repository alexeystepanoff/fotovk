//
//  ViewControllerTableLink.swift
//  fotovk
//
//  Created by Алексей on 23.11.16.
//  Copyright © 2016 Alex.Stepanoff. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyVK
import SwiftyJSON

class ViewControllerTableLink: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    let realm = try! Realm()
    var results = try! Realm().objects(fotovkbase.self).sorted(byProperty: "fotovkid")
    var lists : Results<fotovkbase>!
    let resultpic = try! Realm().objects(fotovkpics.self).sorted(byProperty: "fotovkpicdate")
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = results[indexPath.row]
        cell.textLabel?.text = object.fotovknamescreen
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        
            try! realm.write {
                let item1 = results[indexPath.row]
                realm.delete(item1)
            }
        readDataendUpdateUI()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 //       readDataendUpdateUI()
                writepicstobase()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
    
    func readDataendUpdateUI()
    {
    
        results = try! Realm().objects(fotovkbase.self).sorted(byProperty: "fotovkid")
 //       self.tableview.setEditing(false, animated: true)
        self.tableview.reloadData()
    }
    
  
  
}

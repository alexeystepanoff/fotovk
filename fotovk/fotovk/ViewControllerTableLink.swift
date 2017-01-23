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
import CloudKit

class ViewControllerTableLink: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    let realm = try! Realm()
    var results = try! Realm().objects(fotovkbase.self).sorted(byProperty: "fotovkid")
    var lists : Results<fotovkbase>!
    let resultpic = try! Realm().objects(fotovkpics.self).sorted(byProperty: "fotovkpicdate")
    var selectedRecord = 0
    let refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = results[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = object.fotovknamescreen
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {        
            try! realm.write {
                let item1 = results[indexPath.row]
                var selectedRecord = results[indexPath.row].fotovkid
                let container = CKContainer.default()
                let privateDataBase = container.privateCloudDatabase
                let error: NSError
                let query = CKQuery(recordType: "fotovk", predicate: NSPredicate(format: "fotovkid == %D", selectedRecord))
                privateDataBase.perform(query, inZoneWith: nil, completionHandler: { results, error in
                    if error == nil {
                        if (results?.count)! > 0 {
                            let record: CKRecord! = results![0] as! CKRecord
                            privateDataBase.delete(withRecordID: record.recordID, completionHandler: { recordID, error in
                                if error != nil {
                                    print(error)
                                }
                            })
                        }
                    }
                    else {
                        print(error)
                    }
                })
                realm.delete(item1)
            }
        }
        readDataendUpdateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundimage = UIImage(named: "1.jpg")
        let imageviewbackground = UIImageView(image: backgroundimage)
        imageviewbackground.contentMode = .scaleAspectFill
        tableview.backgroundView = imageviewbackground
  self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white

        writepicstobase()
        refreshControl.backgroundColor = UIColor.white
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching more data ...")
        if #available(iOS 10.0, *)
        {
        tableview.refreshControl = refreshControl
        }
        else
        {
        tableview.addSubview(refreshControl)
    }
        refreshControl.addTarget(self, action: #selector(ViewControllerTableLink.getdatafronicloud), for: UIControlEvents.valueChanged)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.tableFooterView = UIView(frame: CGRect.zero)
        tableview.reloadData()
    }
    
    func getdatafronicloud()
    {
        var arrayfotovks:[CKRecord] = []
            let pastLink = fotovkbase()
    let cloudcontainer = CKContainer.default()
        let privatebase = cloudcontainer.privateCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "fotovk", predicate: predicate)
        privatebase.perform(query, inZoneWith: nil, completionHandler: { (results, error) ->Void in
        
            if error != nil {
            print(error)
                return
            }
            if let results = results {
            arrayfotovks = results
                if arrayfotovks.count != 0 {
for i in 0...arrayfotovks.count
{
    let arrayfotovk = arrayfotovks[i]
        pastLink.fotovkid = arrayfotovk.object(forKey: "fotovkid") as! Int
    pastLink.fotovknamefirst = arrayfotovk.object(forKey: "fotovknamefirst") as! String
    pastLink.fotovknamelast = arrayfotovk.object(forKey: "fotovknamelast") as! String
    pastLink.fotovknamescreen = arrayfotovk.object(forKey: "fotovknamescreen") as! String
    let realm = try! Realm()
    try! realm.write {
        realm.add(pastLink)
        self.tableview.reloadData()
    }
                    }
                }
            }
        })
        
        refreshControl.endRefreshing()
    }
    
    
    func readDataendUpdateUI()
    {
    
        results = try! Realm().objects(fotovkbase.self).sorted(byProperty: "fotovkid")
        self.tableview.reloadData()
    }
    
  
  
}

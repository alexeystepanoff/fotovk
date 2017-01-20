//
//  ViewController2.swift
//  fotovk
//
//  Created by Алексей on 15.12.16.
//  Copyright © 2016 Alex.Stepanoff. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyVK
import SwiftyJSON

class ViewController2: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!

    
    let realm = try! Realm()
    let resultpic = try! Realm().objects(fotovkpics.self).sorted(byProperty: "fotovkpicdate", ascending: false)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.black
        VK.logIn()
        DispatchQueue.global().async {
            self.collectionView.reloadData()
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController2.refreshTable), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        }

       func viewWillAppear()
        {
            self.collectionView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTable()
    {
    self.collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resultpic.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    let objectvk = resultpic[indexPath.row]
        let imgurl: NSURL = NSURL(string: objectvk.fotovkpiclinks)!
        let imgpic: NSData = NSData(contentsOf: imgurl as URL)!
        cell.imageView?.image = UIImage(data: imgpic as Data)!

    return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage"
        {
        
            let indexPaths = self.collectionView!.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as NSIndexPath
        let vc = segue.destination as! PicViewController
            let objectvk = resultpic[indexPath.row]
            let imgurl: NSURL = NSURL(string: objectvk.fotovkpiclinks)!
            let imgpic: NSData = NSData(contentsOf: imgurl as URL)!
            vc.image = UIImage(data: imgpic as Data)!
            vc.title = objectvk.fotovkpicowner
            vc.photoURL = imgurl
        }
    }
 
    
}

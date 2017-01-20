//
//  PicViewController.swift
//  fotovk
//
//  Created by Алексей on 15.12.16.
//  Copyright © 2016 Alex.Stepanoff. All rights reserved.
//

import UIKit
import CloudKit

class PicViewController: UIViewController {

        var photoURL: NSURL?
        var image = UIImage()
        var error:NSError?
    
// let iCloudDocumentsURL = FileManager.defaultManager.URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("fotovk")
    

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func sendtoicloud(_ sender: UIBarButtonItem) {
       
        let alertController = UIAlertController(title: "upload image", message: "Save to iCloud?", preferredStyle: .alert)
        
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in

            var textfile: String = (self.photoURL?.absoluteString)!
            
            for character in (textfile.characters) {
                if character == "/" {
                    let startIndex = textfile.characters.startIndex
                    let startcount = textfile.characters
                    let text4 = startcount.index(of: "/")!
                    let text5 = startcount.index(after: text4)
                    textfile = textfile[text5..<textfile.endIndex]
                    // textfile содержиит нашу строку без лишних символов
                }
            }
    let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent(textfile)


            do{
            try FileManager.default.setUbiquitous(true, itemAt: self.photoURL as! URL, destinationURL: iCloudDocumentsURL!)
        }catch
        {
            print(error)
        }

    
    }
    
    
    
        alertController.addAction(OKAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion:nil)
        
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

self.imageView.image = self.image

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

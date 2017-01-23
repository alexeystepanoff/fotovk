//
//  fotovkgetuser.swift
//  fotovk
//
//  Created by Алексей on 21.12.16.
//  Copyright © 2016 Alex.Stepanoff. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyVK
import SwiftyJSON

func writepicstobase()
{
        let resultpic = try! Realm().objects(fotovkpics.self).sorted(byProperty: "fotovkpicdate")
    let realm = try! Realm()
    let results = try! Realm().objects(fotovkbase.self).sorted(byProperty: "fotovkid")
    try! realm.write {
        realm.delete(resultpic)
    }
    for person in results {
        let nameid = String(person.fotovkid)
        let namestring = String(person.fotovknamescreen)
        let toDayminus30 = Calendar.current.date(byAdding: .day, value: -30, to: Date())?.timeIntervalSince1970
        let toDayInt: Int = Int(toDayminus30!)
        var flagvk: Bool = true
        var preparedReq3 = VK.API.Photos.getAll()
        preparedReq3.add(parameters: [VK.Arg.ownerId : nameid])
        preparedReq3.add(parameters: [VK.Arg.extended : "0"])
        preparedReq3.add(parameters: [VK.Arg.photoSizes : "0"])
        preparedReq3.add(parameters: [VK.Arg.noServiceAlbums : "0"])
        preparedReq3.add(parameters: [VK.Arg.count : "200"])
        preparedReq3.send(onSuccess:
            {
                response in response.count
                for i in 0...200 {
                    let pastLink = fotovkpics()
                    let vk2photo807 = response["items"][i]["photo_807"].stringValue
                    let vk2id = response["items"][i]["id"].intValue
                    let vk2ownedid = response["items"][i]["owner_id"].intValue
                    let vk2date = response["items"][i]["date"].intValue
                    print(vk2photo807)
                    pastLink.fotovkpicid = vk2id
                    pastLink.fotovkpiciown = vk2ownedid
                    pastLink.fotovkpicdate = vk2date
                    pastLink.fotovkpiclinks = vk2photo807
                    pastLink.fotovkpicowner = namestring!                  
                    if (pastLink.fotovkpicid != nil && pastLink.fotovkpiciown != nil && pastLink.fotovkpicdate != nil && pastLink.fotovkpiclinks != "" && flagvk == true && pastLink.fotovkpicdate > toDayInt)
                    {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.add(pastLink)
                            flagvk = true
                        }
                    }
                }
                
        }, onError: {error in(error)}
            
        )
        
        var flagvk2: Bool = true
        
        var preparedReq6 = VK.API.Photos.get()
        preparedReq6.add(parameters: [VK.Arg.ownerId : nameid])
        preparedReq6.add(parameters: [VK.Arg.albumId : "-7"])
        preparedReq6.add(parameters: [VK.Arg.rev : "1"])
        preparedReq6.add(parameters: [VK.Arg.count : "200"])
        preparedReq6.send(onSuccess:
            {
                response in response.count
                for i in 0...200 {
                    let pastLink = fotovkpics()
                    let vk2photo807 = response["items"][i]["photo_807"].stringValue
                    let vk2id = response["items"][i]["id"].intValue
                    let vk2ownedid = response["items"][i]["owner_id"].intValue
                    let vk2date = response["items"][i]["date"].intValue
                    pastLink.fotovkpicid = vk2id
                    pastLink.fotovkpiciown = vk2ownedid
                    pastLink.fotovkpicdate = vk2date
                    pastLink.fotovkpiclinks = vk2photo807
                    pastLink.fotovkpicowner = namestring!
                    if (pastLink.fotovkpicid != nil && pastLink.fotovkpiciown != nil && pastLink.fotovkpicdate != nil && pastLink.fotovkpiclinks != "" && flagvk2 == true && pastLink.fotovkpicdate > toDayInt)
                    {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.add(pastLink)
                            flagvk = true
                        }
                    }
                }
        }, onError: {error in(error)}
            
        )
}
}

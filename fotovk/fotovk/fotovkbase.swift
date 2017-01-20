//
//  fotovkbase.swift
//  fotovk
//
//  Created by Алексей on 23.11.16.
//  Copyright © 2016 Alex.Stepanoff. All rights reserved.
//

import Foundation
import RealmSwift


class fotovkbase: Object {
dynamic var fotovknamefirst = ""
dynamic var fotovknamelast = ""
    dynamic var fotovkid: Int = 0
dynamic var fotovknamescreen = ""
    dynamic var fotovkbooluser: Bool = false
    dynamic var fotovkboolgroupe: Bool = false
}

class fotovkpics: Object {

    dynamic var fotovkpicid: Int = 0
    dynamic var fotovkpiciown: Int = 0
    dynamic var fotovkpicdate: Int = 0
    dynamic var fotovkpiclinks = ""
    dynamic var fotovkpicowner = ""

}

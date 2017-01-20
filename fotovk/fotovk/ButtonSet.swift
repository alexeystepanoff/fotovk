//
//  ButtonSet.swift
//  fotovk
//
//  Created by Алексей on 18.01.17.
//  Copyright © 2017 Alex.Stepanoff. All rights reserved.
//

import UIKit
@IBDesignable
class ButtonSet: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }    
}

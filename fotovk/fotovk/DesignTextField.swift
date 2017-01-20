//
//  DesignTextField.swift
//  fotovk
//
//  Created by Алексей on 18.01.17.
//  Copyright © 2017 Alex.Stepanoff. All rights reserved.
//

import UIKit
@IBDesignable
class DesignTextField: UITextField {

    @IBInspectable var leftImage: UIImage? {
        didSet {
updateview()
}
    }
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
        updateview()
        }
    }
    
    func updateview()
    {
        if let image = leftImage {
        leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.tintColor = UIColor.white
            let width = leftPadding + 20
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
            leftView = view            
        } else {
        leftViewMode = .never
        }
    
    }
    
}

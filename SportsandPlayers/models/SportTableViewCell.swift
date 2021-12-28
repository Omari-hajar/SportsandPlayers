//
//  SportTableViewCell.swift
//  SportsandPlayers
//
//  Created by Hajar Alomari on 28/12/2021.
//

import UIKit

class SportTableViewCell: UITableViewCell{
   
    
    var imagePickerDelegate: ImagePickerDelegate?
    var buttonTouchedClosure : (()->Void)?

    @IBOutlet weak var sportImageIV: UIImageView!
    
    @IBOutlet weak var imageBtn: UIButton!
    
    @IBOutlet weak var sportNameLabel: UILabel!
    
    @IBAction func selectImagePressed(_ sender: UIButton) {
        self.buttonTouchedClosure?()
        imagePickerDelegate?.pickImage()
      
    }

    
}



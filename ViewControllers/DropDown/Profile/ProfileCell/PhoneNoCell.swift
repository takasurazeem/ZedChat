//
//  PhoneNoCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 05/09/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class PhoneNoCell: UITableViewCell {
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
   
    @IBOutlet weak var bgvprofileimgv: UIView!
    @IBOutlet weak var imgv: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       imgv.setImageColor(color: appclr)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

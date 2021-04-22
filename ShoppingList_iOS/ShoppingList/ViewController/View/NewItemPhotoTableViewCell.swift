//
//  NewItemPhotoTableViewCell.swift
//  ShoppingList
//
//  Created by Lenochka on 8/29/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit

class NewItemPhotoTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet var indicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

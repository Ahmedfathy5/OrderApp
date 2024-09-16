//
//  OrderCell.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 15/09/2024.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  MenuCell.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    

    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
    }
    
    
//    
//    var itemNames: String? = nil
//    {
//        didSet {
//            if oldValue != itemNames {
//                setNeedsUpdateConfiguration()
//            }
//        }
//    }
//    var price: Double? = nil
//    {
//        didSet {
//            if oldValue != price {
//                setNeedsUpdateConfiguration()
//            }
//        }
//    }
//    var image: UIImage? = nil
//    {
//        didSet {
//            if oldValue != image {
//                setNeedsUpdateConfiguration()
//            }
//        }
//    }
//    override func updateConfiguration(using state: UICellConfigurationState) {
//        var content = defaultContentConfiguration().updated(for: state)
//        content.text = itemName
//        content.secondaryText = price?.formatted(.currency(code: "usd"))
//        content.prefersSideBySideTextAndSecondaryText = true
//        
//      
//        self.contentConfiguration = content
//    }
    
    
    
}

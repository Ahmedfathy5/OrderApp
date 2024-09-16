//
//  MenuItemDetailVC.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import UIKit

class MenuItemDetailVC: UIViewController {
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemDetail: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var addOrderBtn: UIButton!
    
    
    var menuItem: MenuItem
    
    init( menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
    private func updateUI() {
        itemName.text = menuItem.name
        itemDetail.text = menuItem.detailText
        itemPrice.text = menuItem.price.formatted(.currency(code: "usd"))
        addOrderBtn.layer.cornerRadius = 15
        itemName.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        itemDetail.font = UIFont.systemFont(ofSize: 15, weight: .light)
        itemDetail.numberOfLines = 2
        Task.init {
            if let image = try? await NetworkManager.shared.fetchImage(from: menuItem.imageURL) {
                menuImage.image = image
            }
        }
        
    }
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: []) {
            self.addOrderBtn.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.addOrderBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        NetworkManager.shared.order.menuItems.append(menuItem)
    }
    
    
}

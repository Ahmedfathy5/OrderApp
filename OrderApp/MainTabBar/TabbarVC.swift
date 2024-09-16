//
//  TabbarVC.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import UIKit

class TabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: CategoryVC())
        let vc2 = UINavigationController(rootViewController: OrderVC())
        
        vc1.tabBarItem.image = UIImage(systemName: "slider.horizontal.3")
        vc2.tabBarItem.image = UIImage(systemName: "bag.badge.plus")
        
        vc1.title = "Menu"
        vc2.title = "Your Order"
        
        tabBar.tintColor = .black
        
        setViewControllers([vc1, vc2], animated: true)
   
        
    }
    

  

}

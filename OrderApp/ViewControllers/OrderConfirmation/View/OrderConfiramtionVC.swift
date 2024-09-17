//
//  OrderConfiramtionVC.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 15/09/2024.
//

import UIKit

class OrderConfiramtionVC: UIViewController {
    
    var minutesToPrepare: Int
    
    @IBOutlet weak var confiramtionLbl: UILabel!
    init(minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confiramtionLbl.numberOfLines = 2
        confiramtionLbl.textAlignment = .left
        if minutesToPrepare == 1 {
            confiramtionLbl.text = "I think you should Submit that you need the order First.🥹"
        } else {
            confiramtionLbl.text = "Thanks, Your Order will be ready in \(minutesToPrepare) Minutes."
        }
    }
}

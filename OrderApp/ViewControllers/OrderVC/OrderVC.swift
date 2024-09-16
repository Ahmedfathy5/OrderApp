//
//  OrderViewController.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import UIKit

class OrderVC: UIViewController {

    @IBOutlet weak var orderTableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var minutesToPrepareOrder = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your Order"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitTapped))
        setUptableView()
       // setUpActivityIndicator()
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(orderTableView!, selector: #selector(UITableView.reloadData), name: NetworkManager.orderUpdateNotification, object: nil)
    }

    @objc func submitTapped(_ sender: UIButton) {
        let orderTotal = NetworkManager.shared.order.menuItems.reduce(0) { (Result, MenuItem)-> Double in
            return Result + MenuItem.price
        }
        let formattedTotal = orderTotal.formatted(.currency(code: "usd"))
        let alertController = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedTotal)", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            self?.uploadOrder()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func uploadOrder() {
        let menuIDs = NetworkManager.shared.order.menuItems.map { $0.id }
        
        Task.init {
            do {
                let minutesToPrepare = try await NetworkManager.shared.submitOrder(forMenuIDs: menuIDs)
                minutesToPrepareOrder = minutesToPrepare
            } catch  {
                displayError(error, title: "Order Submission Failed")
            }
        }
        
    }
    
    private func setUptableView() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: String(describing: OrderCell.self), bundle: nil), forCellReuseIdentifier: String(describing: OrderCell.self))
    }
    private func setUpActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
}

extension OrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NetworkManager.shared.order.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderCell.self), for: indexPath) as? OrderCell else { return UITableViewCell()}
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = NetworkManager.shared.order.menuItems[indexPath.row]
        guard let cell = cell as? OrderCell else { return }
        
        cell.orderName.text = menuItem.name
        cell.orderPrice.text = "$\(menuItem.price)"
        cell.orderImage.image = UIImage(systemName: "photo.on.rectangle")
        Task.init {
            if let image = try? await NetworkManager.shared.fetchImage(from: menuItem.imageURL) {
                if let currentInedxPath = self.orderTableView.indexPath(for: cell), currentInedxPath == indexPath {
                    cell.orderImage.image = image
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NetworkManager.shared.order.menuItems.remove(at: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let orderConfirmation = OrderConfiramtionVC(minutesToPrepare: minutesToPrepareOrder)
     
        navigationController?.pushViewController(orderConfirmation, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
}

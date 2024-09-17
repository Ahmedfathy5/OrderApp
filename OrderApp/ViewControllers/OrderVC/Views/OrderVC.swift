//
//  OrderViewController.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import UIKit

class OrderVC: UIViewController {

    @IBOutlet weak var orderTableView: UITableView!
    let orderViewModel: OrderViewModel = OrderViewModel()
    
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
        Task {
                minutesToPrepareOrder = await orderViewModel.minutesToPrepareOrder() ?? 1
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
        orderViewModel.tableViewCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderCell.self), for: indexPath) as? OrderCell else { return UITableViewCell()}
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
       
        guard let cell = cell as? OrderCell else { return }
        let menuItem = orderViewModel.fetchMenuItem(indexPath: indexPath)
        
        cell.orderName.text = menuItem.name
        cell.orderPrice.text = "$\(menuItem.price)"
        cell.orderImage.image = UIImage(systemName: "photo.on.rectangle")
        Task.init {
           await orderViewModel.fetchImage(menuItem: menuItem, indexPath: indexPath) { [weak self] image in
               DispatchQueue.main.async {
                   if let currentIndexPath = self?.orderTableView.indexPath(for: cell), currentIndexPath == indexPath {
                       cell.orderImage.image = image
                   }
               }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            orderViewModel.deleteRows(indexPath: indexPath)
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

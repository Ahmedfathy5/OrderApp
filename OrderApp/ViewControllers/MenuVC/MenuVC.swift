//
//  MenuViewController.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import UIKit

class MenuVC: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    var category: String = ""
    let menuController = NetworkManager()
    var menuItems: [MenuItem] = []
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.capitalized
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(UINib(nibName: String(describing: MenuCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MenuCell.self))
        Task.init {
            do {
                let menuItems = try await NetworkManager.shared.fetchMenuItem(forCategory: category)
                updateUI(with: menuItems)
            } catch  {
                displayError(error, title: "Failed to fetch Menu Items for \(category)")
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageLoadTasks.forEach { key, value in value.cancel() }
    }
    
    private func updateUI(with menuItems: [MenuItem]){
        self.menuItems = menuItems
        self.menuTableView.reloadData()
    }
}
extension MenuVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuCell.self), for: indexPath) as? MenuCell else { return UITableViewCell() }
        configureCell(cell, forCategoryAt: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        guard let cell = cell as? MenuCell else { return }
        
        let menuItem = menuItems[indexPath.row]
        cell.itemImage.image = nil
        cell.itemName.text = menuItem.name
        cell.itemPrice.text = "$\(menuItem.price)"
       
        
       imageLoadTasks[indexPath] = Task.init {
            if let image = try? await NetworkManager.shared.fetchImage(from: menuItem.imageURL) {
                if let currentInedxPath = self.menuTableView.indexPath(for: cell), currentInedxPath == indexPath {
                    cell.itemImage.image = image
                }
            }
           imageLoadTasks[indexPath] = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let menuDetailVC = MenuItemDetailVC(menuItem: menuItems[indexPath.row])
        self.navigationController?.pushViewController(menuDetailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //MARK: - Cancel the image fetching task if it's no longer needed.
        imageLoadTasks[indexPath]?.cancel()
    }
    
}

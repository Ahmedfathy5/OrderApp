//
//  MenuViewController.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import UIKit

class MenuVC: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    let menuViewModel: MenuViewModel = MenuViewModel(category: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = menuViewModel.category.capitalized
        setUptableView()
        
        //MARK: - when the data is updated it's reload the tableView.
        menuViewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.menuTableView.reloadData()
            }
        }
        
        Task {
            await menuViewModel.fetchMenuItems()
        }
    }
    private func setUptableView() {
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(UINib(nibName: String(describing: MenuCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MenuCell.self))
    }
}
extension MenuVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuViewModel.menuItems.count
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
        let menuItem = menuViewModel.menuItems[indexPath.row]
        cell.itemImage.image = nil
        cell.itemName.text = menuItem.name
        cell.itemPrice.text = "$\(menuItem.price)"
        
        Task {
            await menuViewModel.fetchImage(for: indexPath, menuItem: menuItem) { [weak self] image in
                DispatchQueue.main.async {
                    if let currentIndexPath = self?.menuTableView.indexPath(for: cell), currentIndexPath == indexPath {
                        cell.itemImage.image = image
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let menuDetailVC = MenuItemDetailVC(menuDetailViewModel: MenuDetailViewModel(menuItem: menuViewModel.menuItems[indexPath.row]))
       
        self.navigationController?.pushViewController(menuDetailVC, animated: true)
    }
}

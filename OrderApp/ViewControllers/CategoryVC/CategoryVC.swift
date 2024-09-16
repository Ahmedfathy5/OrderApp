//
//  CategoryCell.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let menuController = NetworkManager()
   private var categories: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Resturants"
        Task.init {
            do {
                let categories = try await NetworkManager.shared.fetchCategories()
                updateUI(with: categories)
            } catch  {
                displayError(error, title: "Failed to fetch Categories.")
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: CategoryCell.self), bundle: nil), forCellReuseIdentifier: String(describing:  CategoryCell.self))
        
    }
 
  
   private func updateUI(with categories: [String]){
        self.categories = categories
       self.tableView.reloadData()
    }
    
}
extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:  CategoryCell.self), for: indexPath) as? CategoryCell else { return UITableViewCell() }
        configureCell(cell, forCategoryAt: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = category.capitalized
        cell.contentConfiguration = content
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
         let detailView = MenuVC()
        
        detailView.category = categories[indexPath.row]
        
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    
    
    
}

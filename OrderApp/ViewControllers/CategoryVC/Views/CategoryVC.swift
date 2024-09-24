//
//  CategoryCell.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
   private let viewModel: CategoryViewModel = CategoryViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Resturants"
        setUpTableView()
    }
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: CategoryCell.self), bundle: nil), forCellReuseIdentifier: String(describing:  CategoryCell.self))
    }
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:  CategoryCell.self), for: indexPath) as? CategoryCell else { return UITableViewCell() }
        configureCell(cell, forCategoryAt: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = category.capitalized
        cell.contentConfiguration = content
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
         let detailView = MenuVC()
        detailView.menuViewModel.category = viewModel.categories[indexPath.row]
        navigationController?.pushViewController(detailView, animated: true)
    }
    
}

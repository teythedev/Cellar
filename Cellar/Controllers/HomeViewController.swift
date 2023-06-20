//
//  HomeViewController.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import ProgressHUD


final class HomeViewController: UIViewController, HomeViewModelDelegate {
    func handleViewModelOutput(_ output: HomeViewModelOutput) {
        switch output {
        case .showLoading(let result, let message):
            if result {
                ProgressHUD.show(message)
            }else {
                ProgressHUD.dismiss()
            }
        case .showAddProductModal:
            let addProductViewController = AddProductViewController()
//            present(addProductViewController, animated: true) { [weak self] in
//                guard let strongSelf = self else {return}
//                strongSelf.viewModel?.fetchOwnedProducts(completion: { result in
//                    switch result {
//                    case .success(let success):
//                        //TODO: -
//                    case .failure(let failure):
//                        //TODO: -
//                    }
//                })
//            }
        }
        
    }
    
    
    var viewModel: HomeViewModelProtocol?
    
    
    
    let cellarTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(cellarTableView)
        cellarTableView.delegate = self
        cellarTableView.dataSource = self
        cellarTableView.estimatedRowHeight = 80
        setConstraints()
        viewModel?.delegate = self
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bag.badge.plus"), style: .done, target: self, action: #selector(goToAddProductPage))
       // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut))
    }
    
    @objc func showAddProductModal() {
        
    }
    
    @objc func signOut() throws {
        try Auth.auth().signOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.authListener?.addAuthUserListener(completion: {[weak self] user in
            if user == nil {
                self?.setupRootViewController(viewController: LoginViewController.make())
            }else {
                self?.viewModel?.fetchOwnedProducts(completion: { result in
                    print("ds")
                    self?.cellarTableView.reloadData()
                })
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.authListener?.removeAuthUserListener()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate( [
            cellarTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cellarTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cellarTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cellarTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.products?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellarTableView.dequeueReusableCell(withIdentifier: CustomCell.cellIdentifier, for: indexPath) as! CustomCell
        let item = viewModel?.products?[indexPath.row]
        cell.product = item
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {[ weak self ] action, view, completionHandler in
            guard let viewModel = self?.viewModel, let products = viewModel.products else {return}
            let ac = UIAlertController(title: "Warning!", message: "You are about to deleting \(products [indexPath.row].name)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completionHandler(false)
            }))
            ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self?.handleMoveToTrash(indexPath: indexPath)
                completionHandler(true)
            }))
            self?.present(ac, animated: true)
            
        }
        
        action.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

extension HomeViewController {
    private func handleMoveToTrash(indexPath: IndexPath) {
        guard let viewModel = viewModel else {return}
        viewModel.deleteProduct(index: indexPath.row)
        cellarTableView.reloadData()
    }
}

extension HomeViewController: CustomCellDelegate {
    
    
    func showWarning(error: CustomCellError, handler: @escaping (Bool) -> Void) {
        switch error {
        case .NoTitle(let noTitleError):
            let ac = UIAlertController(title: "Warning", message: noTitleError, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                handler(true)
            }))
            self.present(ac, animated: true)
        case .ZeroAmount(let zeroAmountError):
            let ac = UIAlertController(title: "Warning", message: zeroAmountError, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                handler(true)
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
                handler(false)
            }))
            self.present(ac, animated: true)
        }
    }
    
    func productDeleted(cell: CustomCell, product: Product) {
        if let indexPath = cellarTableView.indexPath(for: cell) {
            let product = viewModel?.products?[indexPath.row]
            guard let product = product else {return}
            let ac = UIAlertController(title: "Warning", message: "You are about to delete this product: \(product.name)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {[weak self] _ in
                self?.viewModel?.deleteProduct(index: indexPath.row)
                self?.cellarTableView.reloadData()
            }))
            present(ac, animated: true)
        }
    }
    
    
    
    func onEditingEnd(cell: CustomCell, product: Product) {
        if let indexpath = cellarTableView.indexPath(for: cell) {
            viewModel?.updateProduct(index: indexpath.row, product: product, completion: { [weak self] result in
                switch result {
                case .success(_):
                    //TODO: This is not working!!!!!
                    print("dsds")
                    self?.cellarTableView.reloadData()
                case .failure(_):
                    print("Update fail")
                }
            })
            
        }
    }
}




//
//  HomeViewController.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import UIKit



final class HomeViewController: UIViewController, HomeViewModelDelegate {
    func handleViewModelOutput(_ output: HomeViewModelOutput) {
        switch output {
        case .gotoLoginPage(let viewController):
            present(viewController, animated: true)
        }
    }
    
    var products = [
        Product(name: "Elma", amount: "0.5", unitType: UnitType.LT),
        Product(name: "Armut", amount: "10.0",unitType: UnitType.LT),
        Product(name: "Erik", amount: "0.25",unitType: UnitType.KG),
        Product(name: "Ekmek", amount: "6.0",unitType: UnitType.LT),
        Product(name: "Su", amount: "20",unitType: UnitType.LT),
        Product(name: "Muz", amount: "12",unitType: UnitType.LT),
        Product(name: "tuz", amount: "12",unitType: UnitType.LT),
        Product(name: "kuz", amount: "12",unitType: UnitType.LT),
        Product(name: "cuz", amount: "12",unitType: UnitType.LT),
        Product(name: "puz", amount: "12",unitType: UnitType.LT),
        Product(name: "buz", amount: "12",unitType: UnitType.LT),
        Product(name: "Erik", amount: "0.25",unitType: UnitType.LT),
        Product(name: "yrik", amount: "1.25",unitType: UnitType.LT),
        Product(name: "trik", amount: "2.25",unitType: UnitType.LT),
        Product(name: "urik", amount: "3.25",unitType: UnitType.LT),
        Product(name: "irik", amount: "4.25",unitType: UnitType.LT),
        Product(name: "orik", amount: "5.25",unitType: UnitType.LT),
        Product(name: "prik", amount: "6.25",unitType: UnitType.LT),
        Product(name: "prik", amount: "7.25",unitType: UnitType.LT),
    ]
    
    var viewModel: HomeViewModelProtocol?
    
    
    let cellarTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellIdentifier)

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
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if !Temps.isLoggedIn {
            viewModel?.fetchCurrentUser(completion: {[weak self] user in
                if let user = user {
                    print("\(user.name)")
                } else {
                    let lgn = LoginViewController()
                    let navController = UINavigationController(rootViewController: lgn)
                    lgn.viewModel = LoginViewModel()
                    navController.modalPresentationStyle = .fullScreen
                    self?.present(navController, animated: true)
                }
            })
        }else {
            print("Fetch cellar")
        }
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate( [
            cellarTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cellarTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            cellarTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            cellarTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellarTableView.dequeueReusableCell(withIdentifier: CustomCell.cellIdentifier, for: indexPath) as! CustomCell
        let item = products[indexPath.row]
        cell.product = item
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    
}

extension HomeViewController: CustomCellDelegate {
    
    
    func showWarning(error: CustomCellError, handler: @escaping (Bool) -> Void) {
        switch error {
        case .NoTitle(let noTitleError):
            let ac = UIAlertController(title: "Warning", message: noTitleError, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
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
            let product = products[indexPath.row]
            let ac = UIAlertController(title: "Warning", message: "You are about to delete this product: \(product.name)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {[weak self] _ in
                self?.products.remove(at: indexPath.row)
                self?.cellarTableView.reloadData()
            }))
            present(ac, animated: true)
            //cellarTableView.deleteRows(at: [indexPath], with: .middle)
            
        }
    }
    
    
    
    func onEditingEnd(cell: CustomCell, product: Product) {
        if let indexpath = cellarTableView.indexPath(for: cell) {
            products[indexpath.row] = product
        }
    }
}




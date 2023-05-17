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
    
    let products = [
        Product(name: "Elma", amount: "0.5"),
        Product(name: "Armut", amount: "10.0"),
        Product(name: "Erik", amount: "0.25"),
        Product(name: "Ekmek", amount: "6.0"),
        Product(name: "Su", amount: "20"),
        Product(name: "Muz", amount: "12"),
        Product(name: "tuz", amount: "12"),
        Product(name: "kuz", amount: "12"),
        Product(name: "cuz", amount: "12"),
        Product(name: "puz", amount: "12"),
        Product(name: "buz", amount: "12"),
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
        view.backgroundColor = .white
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
            cellarTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cellarTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
    func proddd(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) {
        
    }
    
    func productChanged(at: CustomCell, product: Product) {
        
    }
    
    
}




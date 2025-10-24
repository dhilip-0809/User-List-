//
//  UsersListViewController.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//
import UIKit

final class UsersListViewController: UITableViewController {
    
    var presenter: UsersListPresenterContract?
    
    private var users: [User] = []
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchResultsUpdater = self
        sc.searchBar.placeholder = "Search users"
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Users"
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        navigationItem.searchController = searchController
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    @objc private func refreshPulled() {
        presenter?.didPullToRefresh()
    }
    
    // MARK: - Table Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfUsers ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as? UserCell,
              let user = presenter?.user(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configure(with: user, at: indexPath)
        return cell
    }
    
    // MARK: - Table Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectUser(at: indexPath.row)
    }
}

// MARK: - UsersListViewContract

extension UsersListViewController: UsersListViewContract {
    
    func showUsers(_ users: [User]) {
        self.users = users
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        if refreshControl?.isRefreshing == false {
            activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        refreshControl?.endRefreshing()
    }
}

// MARK: - UISearchResultsUpdating

extension UsersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        presenter?.didSearchUsers(with: query)
    }
}

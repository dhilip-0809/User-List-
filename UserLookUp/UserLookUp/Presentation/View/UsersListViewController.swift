import UIKit

final class UsersListViewController: UIViewController {
    
    var presenter: UsersListPresenterContract?
    private var users: [User] = []
    private var searchHistory: [String] = []
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = LocalizationManager.Users.Search.placeholder
        sc.searchBar.delegate = self
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.autocapitalizationType = .none
        sc.searchBar.autocorrectionType = .no
        return sc
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = ThemeManager.Colors.Background.primary
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 80
        tv.showsVerticalScrollIndicator = true
        tv.keyboardDismissMode = .interactive
        return tv
    }()
    
    private let firstLaunchEmptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeManager.Colors.Background.primary
        return view
    }()
    
    private let welcomeStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    private let welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ThemeManager.Colors.Icon.secondary
        let config = UIImage.SymbolConfiguration(pointSize: 70, weight: .light, scale: .large)
        imageView.image = UIImage(systemName: "person.text.rectangle", withConfiguration: config)
        return imageView
    }()
    
    private let welcomeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizationManager.Users.Welcome.title
        label.font = ThemeManager.Typography.largeTitleBold
        label.textColor = ThemeManager.Colors.Text.primary
        label.textAlignment = .center
        return label
    }()
    
    private let welcomeMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizationManager.Users.Welcome.message
        label.font = ThemeManager.Typography.bodyRegular
        label.textColor = ThemeManager.Colors.Text.secondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let noResultsEmptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeManager.Colors.Background.primary
        view.isHidden = true
        return view
    }()
    
    private let noResultsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ThemeManager.Colors.Icon.secondary
        let config = UIImage.SymbolConfiguration(pointSize: 72, weight: .light, scale: .large)
        imageView.image = UIImage(systemName: "magnifyingglass.circle", withConfiguration: config)
        return imageView
    }()
    
    private let noResultsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("users.noResults.title", comment: "")
        label.font = ThemeManager.Typography.titleSemibold
        label.textColor = ThemeManager.Colors.Text.primary
        label.textAlignment = .center
        return label
    }()
    
    private let noResultsMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("users.noResults.message", comment: "")
        label.font = ThemeManager.Typography.smallRegular
        label.textColor = ThemeManager.Colors.Text.secondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let recentSearchesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeManager.Colors.Background.primary
        view.isHidden = true
        return view
    }()
    
    private let noResultsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    private let recentSearchesHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizationManager.Users.Recent.header
        label.font = ThemeManager.Typography.captionSemibold
        label.textColor = ThemeManager.Colors.Text.secondary
        return label
    }()
    
    private let recentSearchesTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = ThemeManager.Colors.Background.primary
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "recentCell")
        tv.rowHeight = 44
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let clearHistoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizationManager.Users.Recent.clearButton, for: .normal)
        button.titleLabel?.font = ThemeManager.Typography.buttonRegular
        return button
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupTableViews()
        setupActivityIndicator()
        setupEmptyStates()
        setupKeyboardHandling()
        loadSearchHistory()
        showInitialState()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            presenter?.didSearchUsers(with: searchText)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        searchController.searchBar.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        
        UIView.animate(withDuration: duration) {
            self.tableView.contentInset.bottom = keyboardHeight
            self.tableView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            self.recentSearchesTableView.contentInset.bottom = keyboardHeight
            self.recentSearchesTableView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            self.firstLaunchEmptyView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 2)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration) {
            self.tableView.contentInset.bottom = 0
            self.tableView.verticalScrollIndicatorInsets.bottom = 0
            self.recentSearchesTableView.contentInset.bottom = 0
            self.recentSearchesTableView.verticalScrollIndicatorInsets.bottom = 0
            self.firstLaunchEmptyView.transform = .identity
        }
    }
    
    private func setupNavigationBar() {
        title = LocalizationManager.Users.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = ThemeManager.Colors.Background.primary
        appearance.titleTextAttributes = [.foregroundColor: ThemeManager.Colors.Text.primary]
        appearance.largeTitleTextAttributes = [.foregroundColor: ThemeManager.Colors.Text.primary]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = ThemeManager.Colors.primary
        
        definesPresentationContext = true
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeManager.Colors.Background.primary
        view.addSubview(firstLaunchEmptyView)
        view.addSubview(recentSearchesView)
        view.addSubview(tableView)
        view.addSubview(noResultsEmptyView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            firstLaunchEmptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            firstLaunchEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstLaunchEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstLaunchEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            recentSearchesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recentSearchesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentSearchesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentSearchesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noResultsEmptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noResultsEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noResultsEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noResultsEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyStates() {
        firstLaunchEmptyView.addSubview(welcomeStackView)
        welcomeStackView.addArrangedSubview(welcomeImageView)
        welcomeStackView.addArrangedSubview(welcomeTitleLabel)
        welcomeStackView.addArrangedSubview(welcomeMessageLabel)
        
        NSLayoutConstraint.activate([
            welcomeStackView.centerXAnchor.constraint(equalTo: firstLaunchEmptyView.centerXAnchor),
            welcomeStackView.centerYAnchor.constraint(equalTo: firstLaunchEmptyView.centerYAnchor),
            welcomeStackView.leadingAnchor.constraint(greaterThanOrEqualTo: firstLaunchEmptyView.leadingAnchor, constant: 40),
            welcomeStackView.trailingAnchor.constraint(lessThanOrEqualTo: firstLaunchEmptyView.trailingAnchor, constant: -40),
            welcomeImageView.widthAnchor.constraint(equalToConstant: 120),
            welcomeImageView.heightAnchor.constraint(equalToConstant: 120),
            welcomeMessageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])
        
        noResultsEmptyView.addSubview(noResultsStackView)
        noResultsStackView.addArrangedSubview(noResultsImageView)
        noResultsStackView.addArrangedSubview(noResultsTitleLabel)
        noResultsStackView.addArrangedSubview(noResultsMessageLabel)
        
        NSLayoutConstraint.activate([
            noResultsStackView.centerXAnchor.constraint(equalTo: noResultsEmptyView.centerXAnchor),
            noResultsStackView.centerYAnchor.constraint(equalTo: noResultsEmptyView.centerYAnchor),
            noResultsStackView.leadingAnchor.constraint(greaterThanOrEqualTo: noResultsEmptyView.leadingAnchor, constant: 32),
            noResultsStackView.trailingAnchor.constraint(lessThanOrEqualTo: noResultsEmptyView.trailingAnchor, constant: -32),
            noResultsImageView.widthAnchor.constraint(equalToConstant: 120),
            noResultsImageView.heightAnchor.constraint(equalToConstant: 120),
            noResultsMessageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 280)
        ])
        
        recentSearchesView.addSubview(recentSearchesHeaderLabel)
        recentSearchesView.addSubview(recentSearchesTableView)
        recentSearchesView.addSubview(clearHistoryButton)
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.delegate = self
        clearHistoryButton.addTarget(self, action: #selector(clearHistoryTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            recentSearchesHeaderLabel.topAnchor.constraint(equalTo: recentSearchesView.topAnchor, constant: 16),
            recentSearchesHeaderLabel.leadingAnchor.constraint(equalTo: recentSearchesView.leadingAnchor, constant: 20),
            recentSearchesTableView.topAnchor.constraint(equalTo: recentSearchesHeaderLabel.bottomAnchor, constant: 8),
            recentSearchesTableView.leadingAnchor.constraint(equalTo: recentSearchesView.leadingAnchor),
            recentSearchesTableView.trailingAnchor.constraint(equalTo: recentSearchesView.trailingAnchor),
            recentSearchesTableView.heightAnchor.constraint(equalToConstant: 220),
            clearHistoryButton.topAnchor.constraint(equalTo: recentSearchesTableView.bottomAnchor, constant: 16),
            clearHistoryButton.centerXAnchor.constraint(equalTo: recentSearchesView.centerXAnchor)
        ])
    }
    
    private func setupTableViews() {
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.isHidden = true
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func loadSearchHistory() {
        searchHistory = SearchHistoryManager.shared.getSearchHistory()
    }
    
    private func showInitialState() {
        loadSearchHistory()
        
        if searchHistory.isEmpty {
            firstLaunchEmptyView.isHidden = false
            recentSearchesView.isHidden = true
            tableView.isHidden = true
            noResultsEmptyView.isHidden = true
        } else {
            firstLaunchEmptyView.isHidden = true
            recentSearchesView.isHidden = false
            tableView.isHidden = true
            noResultsEmptyView.isHidden = true
            recentSearchesTableView.reloadData()
        }
    }
    
    private func updateViewStates(searching: Bool, hasResults: Bool, searchText: String) {
        if !searching {
            showInitialState()
        } else if hasResults {
            firstLaunchEmptyView.isHidden = true
            recentSearchesView.isHidden = true
            tableView.isHidden = false
            noResultsEmptyView.isHidden = true
        } else {
            firstLaunchEmptyView.isHidden = true
            recentSearchesView.isHidden = true
            tableView.isHidden = true
            noResultsEmptyView.isHidden = false
        }
    }
    
    @objc private func refreshPulled() {
        presenter?.viewDidLoad()
    }
    
    @objc private func clearHistoryTapped() {
        let alert = UIAlertController(
            title: LocalizationManager.Users.Recent.ClearAlert.title,
            message: LocalizationManager.Users.Recent.ClearAlert.message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: LocalizationManager.Users.Recent.ClearAlert.cancel, style: .cancel))
        
        alert.addAction(UIAlertAction(title: LocalizationManager.Users.Recent.ClearAlert.confirm, style: .destructive) { [weak self] _ in
            SearchHistoryManager.shared.clearHistory()
            self?.loadSearchHistory()
            self?.recentSearchesTableView.reloadData()
            self?.showInitialState()
        })
        present(alert, animated: true)
    }
}

extension UsersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            updateViewStates(searching: false, hasResults: false, searchText: "")
        } else {
            presenter?.didSearchUsers(with: searchText)
        }
    }
}

extension UsersListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            SearchHistoryManager.shared.addSearch(searchText)
            loadSearchHistory()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadSearchHistory()
        showInitialState()
    }
}

extension UsersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentSearchesTableView {
            return searchHistory.count
        }
        return presenter?.numberOfUsers ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == recentSearchesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath)
            cell.textLabel?.text = searchHistory[indexPath.row]
            cell.imageView?.image = UIImage(systemName: "clock.arrow.circlepath")
            cell.imageView?.tintColor = ThemeManager.Colors.Icon.primary
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as? UserCell,
                  let user = presenter?.user(at: indexPath.row) else {
                return UITableViewCell()
            }
            cell.configure(with: user, at: indexPath)
            return cell
        }
    }
}

extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recentSearchesTableView {
            let searchTerm = searchHistory[indexPath.row]
            searchController.searchBar.text = searchTerm
            searchController.isActive = true
            presenter?.didSearchUsers(with: searchTerm)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            
            if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                SearchHistoryManager.shared.addSearch(searchText)
                loadSearchHistory()
            }
            
            presenter?.didSelectUser(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == recentSearchesTableView {
            let deleteAction = UIContextualAction(style: .destructive, title: LocalizationManager.Users.Recent.delete) { [weak self] _, _, completion in
                let searchTerm = self?.searchHistory[indexPath.row] ?? ""
                SearchHistoryManager.shared.removeSearch(searchTerm)
                self?.loadSearchHistory()
                if self?.searchHistory.isEmpty == true {
                    self?.showInitialState()
                } else {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                completion(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return nil
    }
}

extension UsersListViewController: UsersListViewContract {
    func showUsers(_ users: [User]) {
        self.users = users
        tableView.reloadData()
        let searchText = searchController.searchBar.text ?? ""
        let isSearching = !searchText.isEmpty
        let hasResults = !users.isEmpty
        updateViewStates(searching: isSearching, hasResults: hasResults, searchText: searchText)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(
            title: LocalizationManager.Users.Error.title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: LocalizationManager.Users.Error.ok, style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        if refreshControl.isRefreshing == false {
            firstLaunchEmptyView.isHidden = true
            recentSearchesView.isHidden = true
            tableView.isHidden = true
            noResultsEmptyView.isHidden = true
            activityIndicator.startAnimating()
        }
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        
        let searchText = searchController.searchBar.text ?? ""
        let isSearching = !searchText.isEmpty
        let hasResults = !users.isEmpty
        updateViewStates(searching: isSearching, hasResults: hasResults, searchText: searchText)
    }
}

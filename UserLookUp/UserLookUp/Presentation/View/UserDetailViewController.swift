import UIKit


final class UserDetailViewController: UIViewController {
    
    enum Tab: Int {
        case details, posts
    }
    
    enum DetailsSection: Int, CaseIterable {
        case contact, address, company
    }
    
    private let user: User
    private var posts: [Post] = []
    var postsPresenter: UserPostsPresenterContract?
    
    private var currentTab: Tab = .details
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["User Details", "User Posts"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    // MARK: - Initialization
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        postsPresenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = user.name
        view.backgroundColor = .systemGroupedBackground
        
        // Add segmented control to navigation bar
        navigationItem.titleView = segmentedControl
        
        // Setup table view
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basic")
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        currentTab = Tab(rawValue: sender.selectedSegmentIndex) ?? .details
        tableView.reloadData()
    }
    
    // MARK: - Helper Actions
    
    private func openEmail() {
        guard let url = URL(string: "mailto:\(user.email)") else { return }
        UIApplication.shared.open(url)
    }
    
    private func openPhone() {
        let tel = user.phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard let url = URL(string: "tel:\(tel)"), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    private func openWebsite() {
        var urlString = user.website
        if !urlString.hasPrefix("http") { urlString = "https://\(urlString)" }
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension UserDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentTab == .details ? DetailsSection.allCases.count : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if currentTab == .details {
            switch DetailsSection(rawValue: section)! {
            case .contact: return "CONTACT"
            case .address: return "ADDRESS"
            case .company: return "COMPANY"
            }
        } else {
            return "POSTS"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            header.textLabel?.textColor = .secondaryLabel
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentTab == .details {
            switch DetailsSection(rawValue: section)! {
            case .contact: return 3
            case .address: return 1
            case .company: return 2
            }
        } else {
            return posts.isEmpty ? 1 : posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentTab == .details {
            return configureDetailsCell(for: indexPath)
        } else {
            return configurePostsCell(for: indexPath)
        }
    }
    
    private func configureDetailsCell(for indexPath: IndexPath) -> UITableViewCell {
        let section = DetailsSection(rawValue: indexPath.section)!
        switch section {
        case .contact:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            var cfg = cell.defaultContentConfiguration()
            switch indexPath.row {
            case 0:
                cfg.text = "Email"
                cfg.secondaryText = user.email
            case 1:
                cfg.text = "Phone"
                cfg.secondaryText = user.phone
            case 2:
                cfg.text = "Website"
                cfg.secondaryText = user.website
            default: break
            }
            cfg.textProperties.color = .label
            cfg.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            cfg.secondaryTextProperties.color = .secondaryLabel
            cfg.secondaryTextProperties.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            cfg.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            cell.contentConfiguration = cfg
            cell.backgroundColor = .secondarySystemGroupedBackground
            return cell
            
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
            cell.selectionStyle = .none
            var cfg = cell.defaultContentConfiguration()
            cfg.text = "\(user.address.street), \(user.address.suite)"
            cfg.secondaryText = "\(user.address.city) • \(user.address.zipcode)"
            cfg.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            cfg.textProperties.color = .label
            cfg.secondaryTextProperties.color = .secondaryLabel
            cfg.secondaryTextProperties.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            cfg.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            cell.contentConfiguration = cfg
            cell.backgroundColor = .secondarySystemGroupedBackground
            return cell
            
        case .company:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
            cell.selectionStyle = .none
            var cfg = cell.defaultContentConfiguration()
            if indexPath.row == 0 {
                cfg.text = user.company.name
                cfg.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                cfg.textProperties.color = .label
            } else {
                cfg.text = user.company.catchPhrase
                cfg.textProperties.color = .secondaryLabel
                cfg.textProperties.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            }
            cfg.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            cell.contentConfiguration = cfg
            cell.backgroundColor = .secondarySystemGroupedBackground
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UserHeaderView()
        headerView.configure(with: user)
        return headerView
    }
    
    
    private func configurePostsCell(for indexPath: IndexPath) -> UITableViewCell {
        if posts.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
            cell.selectionStyle = .none
            var cfg = cell.defaultContentConfiguration()
            cfg.text = "No posts"
            cfg.textProperties.color = .secondaryLabel
            cfg.textProperties.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            cell.contentConfiguration = cfg
            cell.backgroundColor = .secondarySystemGroupedBackground
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: indexPath) as? PostCell else {
                return UITableViewCell()
            }
            let post = posts[indexPath.row]
            cell.configure(with: post)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentTab == .details {
            let section = DetailsSection(rawValue: indexPath.section)!
            if section == .contact {
                switch indexPath.row {
                case 0: openEmail()
                case 1: openPhone()
                case 2: openWebsite()
                default: break
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
        } else {
            if !posts.isEmpty {
                postsPresenter?.didSelectPost(at: indexPath.row)
            }
        }
    }
}

// MARK: - UserPostsViewContract

extension UserDetailViewController: UserPostsViewContract {
    
    func showPosts(_ posts: [Post]) {
        self.posts = posts
        if currentTab == .posts {
            tableView.reloadData()
        }
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        // You can add a loading indicator for posts section if needed
    }
    
    func hideLoading() {
        // Hide loading indicator
    }
}

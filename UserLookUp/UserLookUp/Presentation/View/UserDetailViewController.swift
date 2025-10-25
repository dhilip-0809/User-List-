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
    
    private let avatarHeaderView: UserAvatarHeaderView = {
        let view = UserAvatarHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let firstName = user.name.components(separatedBy: " ").first ?? user.name
        let control = UISegmentedControl(items: ["\(firstName)'s Details", "\(firstName)'s Posts"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        control.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.5)
        control.selectedSegmentTintColor = UIColor.secondarySystemGroupedBackground
        control.layer.cornerRadius = 8
        control.layer.masksToBounds = true
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        return control
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let postsEmptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let postsEmptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .light, scale: .large)
        imageView.image = UIImage(systemName: "doc.text.magnifyingglass", withConfiguration: config)
        return imageView
    }()
    
    private let postsEmptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Posts Available"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupPostsEmptyState()
        avatarHeaderView.configure(with: user)
        postsPresenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 71.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        navigationItem.backButtonTitle = "Back"
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(avatarHeaderView)
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basic")
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        NSLayoutConstraint.activate([
            avatarHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            avatarHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            avatarHeaderView.heightAnchor.constraint(equalToConstant: 120),
            
            segmentedControl.topAnchor.constraint(equalTo: avatarHeaderView.bottomAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupPostsEmptyState() {
        tableView.backgroundView = postsEmptyStateView
        
        let stackView = UIStackView(arrangedSubviews: [postsEmptyImageView, postsEmptyLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        
        postsEmptyStateView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: postsEmptyStateView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: postsEmptyStateView.centerYAnchor),
            postsEmptyImageView.widthAnchor.constraint(equalToConstant: 100),
            postsEmptyImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        postsEmptyStateView.isHidden = true
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        currentTab = Tab(rawValue: sender.selectedSegmentIndex) ?? .details
        tableView.reloadData()
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        if currentTab == .posts && posts.isEmpty {
            postsEmptyStateView.isHidden = false
        } else {
            postsEmptyStateView.isHidden = true
        }
    }
    
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
            return posts.isEmpty ? nil : "POSTS"
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
            return posts.count
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
                let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
                cfg.image = UIImage(systemName: "envelope.fill", withConfiguration: symbolConfig)
                cfg.imageProperties.tintColor = UIColor(red: 0.0/255.0, green: 71.0/255.0, blue: 131.0/255.0, alpha: 1.0)
                cfg.text = "Email"
                cfg.secondaryText = user.email
            case 1:
                let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
                cfg.image = UIImage(systemName: "phone.fill", withConfiguration: symbolConfig)
                cfg.imageProperties.tintColor = .systemGreen
                cfg.text = "Phone"
                cfg.secondaryText = user.phone
            case 2:
                let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
                cfg.image = UIImage(systemName: "globe", withConfiguration: symbolConfig)
                cfg.imageProperties.tintColor = .systemOrange
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
            
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            cfg.image = UIImage(systemName: "mappin.and.ellipse", withConfiguration: symbolConfig)
            cfg.imageProperties.tintColor = .systemRed
            
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
                let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
                cfg.image = UIImage(systemName: "building.2.fill", withConfiguration: symbolConfig)
                cfg.imageProperties.tintColor = .systemPurple
                cfg.text = user.company.name
                cfg.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                cfg.textProperties.color = .label
            } else {
                let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
                cfg.image = UIImage(systemName: "quote.opening", withConfiguration: symbolConfig)
                cfg.imageProperties.tintColor = .systemGray
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
    
    private func configurePostsCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
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
            }
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension UserDetailViewController: UserPostsViewContract {
    func showPosts(_ posts: [Post]) {
        self.posts = posts
        if currentTab == .posts {
            tableView.reloadData()
            updateEmptyState()
        }
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        tableView.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        tableView.isUserInteractionEnabled = true
    }
}

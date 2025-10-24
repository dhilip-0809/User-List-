import UIKit

final class UserHeaderView: UIView {
    
    // Callback closures for button actions
    var onMessageTap: (() -> Void)?
    var onCallTap: (() -> Void)?
    var onWebsiteTap: (() -> Void)?
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    private let avatarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 48, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageButton = makeActionButton(symbol: "message.fill", title: "Message")
    private lazy var callButton = makeActionButton(symbol: "phone.fill", title: "Call")
    private lazy var websiteButton = makeActionButton(symbol: "link", title: "Website")
    
    private lazy var actionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [messageButton, callButton, websiteButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 24
        return stack
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Setup hierarchy
        addSubview(contentStackView)
        avatarView.addSubview(avatarLabel)
        
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(companyLabel)
        
        contentStackView.addArrangedSubview(avatarView)
        contentStackView.addArrangedSubview(textStackView)
        contentStackView.addArrangedSubview(actionStackView)
        
        // Add button actions
        messageButton.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Content stack view - centered with padding
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Avatar constraints
            avatarView.widthAnchor.constraint(equalToConstant: 120),
            avatarView.heightAnchor.constraint(equalToConstant: 120),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            // Text stack width
            textStackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentStackView.leadingAnchor),
            textStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentStackView.trailingAnchor),
            
            // Action buttons
            actionStackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentStackView.leadingAnchor),
            actionStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentStackView.trailingAnchor),
            actionStackView.heightAnchor.constraint(equalToConstant: 70),
            
            // Button equal widths
            messageButton.widthAnchor.constraint(equalTo: callButton.widthAnchor),
            callButton.widthAnchor.constraint(equalTo: websiteButton.widthAnchor)
        ])
        
        // Make avatar circular after layout
        layoutIfNeeded()
        avatarView.layer.cornerRadius = 60
        avatarView.clipsToBounds = true
    }
    
    private func makeActionButton(symbol: String, title: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: symbol, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        config.imagePlacement = .top
        config.imagePadding = 6
        config.baseForegroundColor = .label
        config.title = title
        config.titleAlignment = .center
        
        // Create attributed string for title
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        config.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        companyLabel.text = user.company.name
        avatarLabel.text = String(user.name.prefix(1))
    }
    
    // MARK: - Button Actions
    
    @objc private func messageButtonTapped() {
        onMessageTap?()
    }
    
    @objc private func callButtonTapped() {
        onCallTap?()
    }
    
    @objc private func websiteButtonTapped() {
        onWebsiteTap?()
    }
}

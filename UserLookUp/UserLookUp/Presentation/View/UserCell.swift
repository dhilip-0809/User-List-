import UIKit

final class UserCell: UITableViewCell {
    
    static let reuseIdentifier = "UserCell"
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        return view
    }()
    
    private let avatarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 26
        view.clipsToBounds = true
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: config)
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        configureAccessibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardContainer)
        cardContainer.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        cardContainer.addSubview(usernameLabel)
        cardContainer.addSubview(nameLabel)
        cardContainer.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            avatarView.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 12),
            avatarView.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 52),
            avatarView.heightAnchor.constraint(equalToConstant: 52),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -12),
            
            nameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -16),
            
            chevronImageView.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 8),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14),
            
            cardContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 76)
        ])
        
        usernameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func configure(with user: User, at indexPath: IndexPath) {
        usernameLabel.text = user.username
        nameLabel.text = user.name
        
        let firstName = user.name.components(separatedBy: " ").first ?? user.name
        if let firstCharacter = firstName.first {
            avatarLabel.text = String(firstCharacter).uppercased()
            avatarView.backgroundColor = AvatarColorHelper.getColor(for: firstCharacter)
        } else {
            avatarLabel.text = "?"
            avatarView.backgroundColor = .systemGray
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
        accessibilityLabel = "User: \(user.username), Name: \(user.name)"
        accessibilityTraits = .button
        accessibilityHint = "Double tap to view user details"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        nameLabel.text = nil
        avatarLabel.text = nil
        avatarView.backgroundColor = nil
    }
    
    private func configureAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardContainer.layer.shadowPath = UIBezierPath(roundedRect: cardContainer.bounds, cornerRadius: 16).cgPath
    }
}

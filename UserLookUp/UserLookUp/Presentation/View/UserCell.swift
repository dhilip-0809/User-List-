import UIKit

final class UserCell: UITableViewCell {
    
    static let reuseIdentifier = "UserCell"

    // MARK: - UI
    
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 12
        v.clipsToBounds = true
        // use semantic background color so it adapts to light/dark and accessibility
     //   v.backgroundColor = .secondarySystemBackground
        return v
    }()

    // Avatar: keep >= 40 points for HIG touch target; using 48 gives some breathing room
    private let avatarView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 24 // will match 48x48 size
        v.clipsToBounds = true
        v.isAccessibilityElement = false // label will expose content
        return v
    }()

    private let avatarLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        // use a headline-ish preferred style for good scaling with Dynamic Type
        l.font = UIFont.preferredFont(forTextStyle: .headline)
        l.adjustsFontForContentSizeCategory = true
        l.textAlignment = .center
        l.textColor = .white
        return l
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .body) // primary text
        l.adjustsFontForContentSizeCategory = true
        l.numberOfLines = 1
        l.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return l
    }()

    private let usernameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .subheadline)
        l.adjustsFontForContentSizeCategory = true
        l.textColor = .secondaryLabel
        l.numberOfLines = 1
        return l
    }()

    private let companyLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .subheadline)
        l.adjustsFontForContentSizeCategory = true
        l.textColor = .tertiaryLabel
        l.numberOfLines = 1
        return l
    }()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        configureAccessibility()
        companyLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Layout
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(usernameLabel)
       // containerView.addSubview(companyLabel)

        // Use layout margins for readable spacing (HIG: readable content margins)
       // containerView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)

        NSLayoutConstraint.activate([
            // Container respects contentView safe area and has comfortable margins
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            // Avatar
            avatarView.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            avatarView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 48),
            avatarView.heightAnchor.constraint(equalToConstant: 48),

            // Avatar label centered
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            avatarLabel.leadingAnchor.constraint(greaterThanOrEqualTo: avatarView.leadingAnchor, constant: 4),
            avatarLabel.trailingAnchor.constraint(lessThanOrEqualTo: avatarView.trailingAnchor, constant: -4),

            // Text stack
            nameLabel.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),

            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            usernameLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.layoutMarginsGuide.bottomAnchor)

//            companyLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
//            companyLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
//            companyLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
//            companyLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.layoutMarginsGuide.bottomAnchor)
        ])

        // Let the cell adjust for Dynamic Type height changes
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        usernameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        companyLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        // Selection style: default is fine; if you want no highlight, set .none
        selectionStyle = .default

        // Slight shadow is discouraged for table cells in HIG by default; keep it subtle or none.
        backgroundColor = .systemBackground
    }

    // MARK: - Configure
    
    /// Configure with user and indexPath row for index-based color
    func configure(with user: User, at indexPath: IndexPath) {
        // Text
        nameLabel.text = user.username
       // usernameLabel.text = "@\(user.username)"
        usernameLabel.text = user.name
        companyLabel.text = user.name

        // Avatar initial
        let initial = String(user.name.trimmingCharacters(in: .whitespacesAndNewlines).prefix(1)).uppercased()
        avatarLabel.text = initial

        // Index-based color (hue-based for smooth distribution)
        let bgColor = colorForIndex(indexPath.row)
        avatarView.backgroundColor = bgColor

        // Ensure good contrast on the initial: if background is light, use .label, else white
    //    avatarLabel.textColor = bgColor.isLight ? .label : .white

        // Use same accent color for name text but keep subtle: do not overpower
     //   nameLabel.textColor = bgColor

        // Accessibility value (VoiceOver)
        let companyPart = companyLabel.text ?? ""
        accessibilityLabel = "\(user.name), \(companyPart). Username \(usernameLabel.text ?? "")"
        accessibilityTraits = .button // or .staticText depending on interactivity in your app

        // accessibility identifiers (useful for UI tests)
        avatarView.accessibilityIdentifier = "UserCell.avatar.\(user.username)"
        nameLabel.accessibilityIdentifier = "UserCell.name.\(user.username)"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        usernameLabel.text = nil
        companyLabel.text = nil
        avatarLabel.text = nil
        avatarView.backgroundColor = nil
        avatarLabel.textColor = .white
        accessibilityLabel = nil
    }

    // MARK: - Accessibility Config
    
    private func configureAccessibility() {
        isAccessibilityElement = false
        // Keep individual elements accessible if needed; we set cell-level label on configure()
        nameLabel.isAccessibilityElement = false
        usernameLabel.isAccessibilityElement = false
        companyLabel.isAccessibilityElement = false
        avatarLabel.isAccessibilityElement = false
    }

    // MARK: - Color helper (index-based)
    
    /// Return a visually distinct color for a row index using hue rotation.
    private func colorForIndex(_ index: Int) -> UIColor {
        // multiplier chosen to 'jump' hue sufficiently to reduce rapid repetition.
        // saturation/brightness set for good contrast with white text.
        let hueDegrees = (index * 41) % 360
        let hue = CGFloat(hueDegrees) / 360.0
        return UIColor(hue: hue, saturation: 0.6, brightness: 0.86, alpha: 1.0)
    }
}

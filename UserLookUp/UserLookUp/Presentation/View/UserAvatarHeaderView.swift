//
//  UserAvatarHeaderView.swift
//  UserLookUp
//
//  Created by Dhilip R on 25/10/25.
//


import UIKit

final class UserAvatarHeaderView: UIView {
    
    private let avatarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGroupedBackground
        
        addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        
        NSLayoutConstraint.activate([
            avatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            avatarView.widthAnchor.constraint(equalToConstant: 80),
            avatarView.heightAnchor.constraint(equalToConstant: 80),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor)
        ])
    }
    
    func configure(with user: User) {
        let firstName = user.name.components(separatedBy: " ").first ?? user.name
        if let firstCharacter = firstName.first {
            avatarLabel.text = String(firstCharacter).uppercased()
            avatarView.backgroundColor = AvatarColorHelper.getColor(for: firstCharacter)
        }
    }
}

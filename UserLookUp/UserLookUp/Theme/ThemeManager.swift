import UIKit

enum AppTheme {
    case light
    case dark
    case system
}

final class ThemeManager {
    static let shared = ThemeManager()
    
    private init() {}
    
    // MARK: - Colors
    struct Colors {
        static let primary = UIColor(red: 0.0/255.0, green: 71.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        
        struct Text {
            static var primary: UIColor { .label }
            static var secondary: UIColor { .secondaryLabel }
            static var tertiary: UIColor { .tertiaryLabel }
        }
        
        struct Background {
            static var primary: UIColor { .systemBackground }
            static var secondary: UIColor { .secondarySystemBackground }
            static var tertiary: UIColor { .tertiarySystemBackground }
            static var groupedBackground: UIColor { .systemGroupedBackground }
        }
        
        struct Icon {
            static var primary: UIColor { .systemGray }
            static var secondary: UIColor { .systemGray3 }
            static var accent: UIColor { primary }
        }
        
        struct Border {
            static var primary: UIColor { .separator }
            static var secondary: UIColor { .opaqueSeparator }
        }
        
        struct Button {
            static var primary: UIColor { Colors.primary }
            static var destructive: UIColor { .systemRed }
            static var disabled: UIColor { .systemGray4 }
        }
    }
    
    // MARK: - Fonts
    struct Typography {
        static let largeTitleBold = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let titleSemibold = UIFont.systemFont(ofSize: 22, weight: .semibold)
        static let bodyRegular = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let bodySemibold = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let captionSemibold = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let captionRegular = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let buttonRegular = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let buttonSemibold = UIFont.systemFont(ofSize: 15, weight: .semibold)
        static let smallRegular = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    // MARK: - Layout
    struct Layout {
        struct CornerRadius {
            static let small: CGFloat = 4
            static let medium: CGFloat = 8
            static let large: CGFloat = 12
            static let extraLarge: CGFloat = 16
        }
        
        struct Spacing {
            static let xxxSmall: CGFloat = 2
            static let xxSmall: CGFloat = 4
            static let xSmall: CGFloat = 6
            static let small: CGFloat = 8
            static let medium: CGFloat = 12
            static let standard: CGFloat = 16
            static let large: CGFloat = 20
            static let xLarge: CGFloat = 24
            static let xxLarge: CGFloat = 32
            static let xxxLarge: CGFloat = 40
        }
        
        struct IconSize {
            static let small: CGFloat = 16
            static let medium: CGFloat = 24
            static let large: CGFloat = 32
            static let extraLarge: CGFloat = 40
        }
    }
}

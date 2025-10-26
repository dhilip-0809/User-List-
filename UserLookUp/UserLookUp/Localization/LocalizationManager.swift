import Foundation

enum LocalizationManager {
    enum Common {
        static var ok: String { NSLocalizedString("common.ok", comment: "OK button title") }
        static var error: String { NSLocalizedString("common.error", comment: "Error title") }
    }
    
    enum Navigation {
        static var users: String { NSLocalizedString("navigation.users", comment: "Users navigation title") }
        static var back: String { NSLocalizedString("navigation.back", comment: "Back button title") }
    }
    
    enum Users {
        static var title: String { NSLocalizedString("users.title", comment: "Users screen title") }
        
        enum Search {
            static var placeholder: String { NSLocalizedString("users.search.placeholder", comment: "Search users placeholder") }
        }
        
        enum Welcome {
            static var title: String { NSLocalizedString("users.welcome.title", comment: "Welcome screen title") }
            static var message: String { NSLocalizedString("users.welcome.message", comment: "Welcome screen message") }
        }
        
        enum NoResults {
            static var title: String { NSLocalizedString("users.noResults.title", comment: "No results found title") }
            static var message: String { NSLocalizedString("users.noResults.message", comment: "No results found message") }
        }
        
        enum Recent {
            static var header: String { NSLocalizedString("users.recent.header", comment: "Recent searches header") }
            static var clearButton: String { NSLocalizedString("users.recent.clearButton", comment: "Clear history button") }
            static var delete: String { NSLocalizedString("users.recent.delete", comment: "Delete recent search") }
            
            enum ClearAlert {
                static var title: String { NSLocalizedString("users.recent.clearAlert.title", comment: "Clear history alert title") }
                static var message: String { NSLocalizedString("users.recent.clearAlert.message", comment: "Clear history alert message") }
                static var cancel: String { NSLocalizedString("users.recent.clearAlert.cancel", comment: "Cancel clearing history") }
                static var confirm: String { NSLocalizedString("users.recent.clearAlert.confirm", comment: "Confirm clearing history") }
            }
        }
        
        enum UserDetails {
            static var title: String { NSLocalizedString("user.details.title", comment: "User details screen title") }
            static var name: String { NSLocalizedString("user.details.name", comment: "User name field") }
            static var username: String { NSLocalizedString("user.details.username", comment: "Username field") }
            static var email: String { NSLocalizedString("user.details.email", comment: "Email field") }
            static var phone: String { NSLocalizedString("user.details.phone", comment: "Phone field") }
            static var website: String { NSLocalizedString("user.details.website", comment: "Website field") }
            static var company: String { NSLocalizedString("user.details.company", comment: "Company field") }
            static var address: String { NSLocalizedString("user.details.address", comment: "Address field") }
            
            enum Contact {
                static var header: String { NSLocalizedString("user.details.sections.contact", comment: "Contact section header") }
            }
            
            enum Address {
                static var header: String { NSLocalizedString("user.details.sections.address", comment: "Address section header") }
            }
            
            enum Company {
                static var header: String { NSLocalizedString("user.details.sections.company", comment: "Company section header") }
            }
            
            static func detailsTab(name: String) -> String {
                String(format: NSLocalizedString("user.details.tab.details", comment: "%@'s Details tab title"), name)
            }
            
            static func postsTab(name: String) -> String {
                String(format: NSLocalizedString("user.details.tab.posts", comment: "%@'s Posts tab title"), name)
            }
            
            static var noPosts: String { NSLocalizedString("user.details.noPosts", comment: "No posts available message") }
        }
        
        enum Error {
            static var title: String { NSLocalizedString("users.error.title", comment: "Error alert title") }
            static var ok: String { NSLocalizedString("users.error.ok", comment: "Error alert OK button") }
        }
    }
    
    enum Error {
        static var general: String { NSLocalizedString("error.general", comment: "General error message") }
        
        enum Network {
            static var noConnection: String { NSLocalizedString("error.network.noConnection", comment: "No internet connection error message") }
            static var timeout: String { NSLocalizedString("error.network.timeout", comment: "Request timeout error message") }
            static var general: String { NSLocalizedString("error.general", comment: "General error message") }
            static var invalidResponse: String { NSLocalizedString("error.invalidResponse", comment: "Invalid server response error message") }
        }

        enum Posts {
            static var loadFailed: String { NSLocalizedString("error.posts.loadFailed", comment: "Failed to load posts error message") }
            static var processingFailed: String { NSLocalizedString("error.posts.processingFailed", comment: "Failed to process posts error message") }
        }
        
        enum Users {
            static var loadFailed: String { NSLocalizedString("error.users.loadFailed", comment: "Failed to load users error message") }
            static var processingFailed: String { NSLocalizedString("error.users.processingFailed", comment: "Failed to process users error message") }
        }
    }
}

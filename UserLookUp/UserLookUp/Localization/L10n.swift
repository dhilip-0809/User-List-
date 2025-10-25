import Foundation

enum L10n {
    enum Common {
        static let ok = NSLocalizedString("common.ok", comment: "OK button title")
        static let cancel = NSLocalizedString("common.cancel", comment: "Cancel button title")
        static let done = NSLocalizedString("common.done", comment: "Done button title")
        static let delete = NSLocalizedString("common.delete", comment: "Delete button title")
        static let edit = NSLocalizedString("common.edit", comment: "Edit button title")
        static let save = NSLocalizedString("common.save", comment: "Save button title")
        static let close = NSLocalizedString("common.close", comment: "Close button title")
        static let search = NSLocalizedString("common.search", comment: "Search button title")
        static let loading = NSLocalizedString("common.loading", comment: "Loading indicator text")
        static let error = NSLocalizedString("common.error", comment: "Error title")
        static let retry = NSLocalizedString("common.retry", comment: "Retry button title")
    }
    
    enum Navigation {
        static let users = NSLocalizedString("navigation.users", comment: "Users navigation title")
        static let back = NSLocalizedString("navigation.back", comment: "Back button title")
    }
    
    enum Users {
        static let title = NSLocalizedString("users.title", comment: "Users screen title")
        
        enum Search {
            static let placeholder = NSLocalizedString("users.search.placeholder", comment: "Search users placeholder")
        }
        
        enum Welcome {
            static let title = NSLocalizedString("users.welcome.title", comment: "Welcome screen title")
            static let message = NSLocalizedString("users.welcome.message", comment: "Welcome screen message")
        }
        
        enum NoResults {
            static let title = NSLocalizedString("users.noResults.title", comment: "No results found title")
            static let message = NSLocalizedString("users.noResults.message", comment: "No results found message")
        }
        
        enum Recent {
            static let header = NSLocalizedString("users.recent.header", comment: "Recent searches header")
            static let clearButton = NSLocalizedString("users.recent.clearButton", comment: "Clear history button")
            static let delete = NSLocalizedString("users.recent.delete", comment: "Delete recent search")
            
            enum ClearAlert {
                static let title = NSLocalizedString("users.recent.clearAlert.title", comment: "Clear history alert title")
                static let message = NSLocalizedString("users.recent.clearAlert.message", comment: "Clear history alert message")
                static let cancel = NSLocalizedString("users.recent.clearAlert.cancel", comment: "Clear history alert cancel")
                static let confirm = NSLocalizedString("users.recent.clearAlert.confirm", comment: "Clear history alert confirm")
            }
        }
    }
    
    enum UserDetails {
        static let title = NSLocalizedString("user.details.title", comment: "User details screen title")
        static let name = NSLocalizedString("user.details.name", comment: "User name field")
        static let username = NSLocalizedString("user.details.username", comment: "Username field")
        static let email = NSLocalizedString("user.details.email", comment: "Email field")
        static let phone = NSLocalizedString("user.details.phone", comment: "Phone field")
        static let website = NSLocalizedString("user.details.website", comment: "Website field")
        static let company = NSLocalizedString("user.details.company", comment: "Company field")
        static let address = NSLocalizedString("user.details.address", comment: "Address field")
    }
    
    enum Error {
        static let general = NSLocalizedString("error.general", comment: "General error message")
        static let network = NSLocalizedString("error.network", comment: "Network error message")
        static let noData = NSLocalizedString("error.noData", comment: "No data error message")
        static let invalidResponse = NSLocalizedString("error.invalidResponse", comment: "Invalid response error message")
        static let timeout = NSLocalizedString("error.timeout", comment: "Timeout error message")
    }
}
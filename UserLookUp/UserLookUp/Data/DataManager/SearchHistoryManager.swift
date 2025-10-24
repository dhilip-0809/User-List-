import Foundation

final class SearchHistoryManager {
    
    static let shared = SearchHistoryManager()
    
    private let userDefaults = UserDefaults.standard
    private let searchHistoryKey = "com.userlookup.searchHistory"
    private let maxHistoryCount = 5
    
    private init() {}
    
    func getSearchHistory() -> [String] {
        return userDefaults.stringArray(forKey: searchHistoryKey) ?? []
    }
    
    func addSearch(_ term: String) {
        let trimmedTerm = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTerm.isEmpty else { return }
        
        var history = getSearchHistory()
        history.removeAll { $0.lowercased() == trimmedTerm.lowercased() }
        history.insert(trimmedTerm, at: 0)
        
        if history.count > maxHistoryCount {
            history = Array(history.prefix(maxHistoryCount))
        }
        
        userDefaults.set(history, forKey: searchHistoryKey)
        userDefaults.synchronize()
    }
    
    func clearHistory() {
        userDefaults.removeObject(forKey: searchHistoryKey)
        userDefaults.synchronize()
    }
    
    func removeSearch(_ term: String) {
        var history = getSearchHistory()
        history.removeAll { $0 == term }
        userDefaults.set(history, forKey: searchHistoryKey)
        userDefaults.synchronize()
    }
}

import Foundation

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    private let userDefaults = UserDefaults.standard
    private let themesKey = "saved_themes"
    
    @Published private(set) var themes: [CustomTheme] = []
    
    private init() {
        loadThemes()
    }
    
    private func loadThemes() {
        guard let data = userDefaults.data(forKey: themesKey),
              let decoded = try? JSONDecoder().decode([CustomTheme].self, from: data) else {
            return
        }
        themes = decoded
    }
    
    func saveTheme(_ theme: CustomTheme) {
        themes.append(theme)
        saveToUserDefaults()
    }
    
    func deleteTheme(_ theme: CustomTheme) {
        themes.removeAll { $0.id == theme.id }
        saveToUserDefaults()
    }
    
    private func saveToUserDefaults() {
        guard let encoded = try? JSONEncoder().encode(themes) else { return }
        userDefaults.set(encoded, forKey: themesKey)
    }
}
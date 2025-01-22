import Foundation

struct HomeModel {
    struct Template: Identifiable {
        let id: UUID = UUID()
        var name: String
        var previewImage: String?
        var layout: String
    }
}


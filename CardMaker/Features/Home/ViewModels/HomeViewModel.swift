import Foundation

class HomeViewModel: ObservableObject {
    @Published var templates: [HomeModel.Template] = []
    @Published var selectedTemplate: HomeModel.Template?
    @Published var showingEditor = false
    
    init() {
        loadTemplates()
    }
    
    private func loadTemplates() {
        templates = [
            .init(
                name: "基础卡片",
                previewImage: "BaseCard",
                layout: "baseCard"
            ),
            .init(
                name: "文章卡片",
                previewImage: "ArticleCard",
                layout: "articleCard"
            ),
            .init(
                name: "层叠卡片",
                previewImage: "LayeredCard",
                layout: "layeredCard"
            ),
            .init(
                name: "语录卡片",
                previewImage: "MovieCard",
                layout: "movieCard"
            )
        ]
    }
    
    func onTemplateSelected(_ template: HomeModel.Template) {
        selectedTemplate = template
        showingEditor = true
    }
}

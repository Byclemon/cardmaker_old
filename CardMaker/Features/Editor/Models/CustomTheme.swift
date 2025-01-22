// 自定义主题
import SwiftUI
import Foundation

struct CustomTheme: Codable, Identifiable {
    let id: UUID
    let name: String
    let layout: String
    let createdAt: Date
    
    // 基础卡片样式
    var baseStyle: BaseCardStyle?
    
    // 文章卡片样式
    var articleStyle: ArticleCardStyle?
    
    // 层叠卡片样式
    var layeredStyle: LayeredCardStyle?
    
    // 电影卡片样式
    var movieStyle: MovieCardStyle?
}
import SwiftUI

class ArticleCardViewModel: ObservableObject {
    // 背景相关
    @Published var useGradient: Bool = true
    @Published var gradientColors: [Color] = [Color(hex: "#dbdcd7"), Color(hex: "#dddcd7"), Color(hex: "#e2c9cc")]
    @Published var gradientAngle: Double = 45
    @Published var backgroundColor: Color = Color(hex: "#f6d365")
    
    // 卡片相关
    @Published var cardBackgroundColor: Color = Color(hex: "#f5f4f7")
    @Published var cardOpacity: Double = 0.4
    @Published var cornerRadius: CGFloat = 15
    @Published var edgePadding: CGFloat = 20
    @Published var innerPadding: CGFloat = 15
    @Published var moduleHeight: CGFloat = 40
    
    // 模块显示控制
    @Published var showIcon: Bool = true
    @Published var showDate: Bool = true
    @Published var showTitle: Bool = true
    @Published var showContent: Bool = true
    @Published var showAuthor: Bool = true
    @Published var showWordCount: Bool = true
    @Published var showQRCode: Bool = true
    @Published var showWatermark: Bool = true
     
    // 内容相关
    @Published var icon: String = "doc.text"
    @Published var date: Date = Date()
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var author: String = ""
    @Published var qrCodeData: String = "https://cardmaker.byclemon.com"
    @Published var watermarkText: String = "CardMaker"
    @Published var dateFormat: DateFormat = .longDate   
    
    // 样式相关
    @Published var titleFont: String = "TsangerYuMo"
    @Published var contentFont: String = "TsangerYuMo"
    @Published var titleSize: CGFloat = 16
    @Published var contentSize: CGFloat = 15
    @Published var titleColor: Color = Color(hex: "#333333")
    @Published var contentColor: Color = Color(hex: "#333333")
    @Published var authorColor: Color = Color(hex: "#a1a1a1")
    @Published var wordCountColor: Color = Color(hex: "#a1a1a1")
    @Published var qrCodeColor: Color = Color(hex: "#a1a1a1")
    @Published var dataColor: Color = Color(hex: "#a1a1a1")
    @Published var watermarkColor: Color = Color(hex: "#a1a1a1")
    @Published var watermarkOpacity: Double = 0.5
    @Published var moduleBackgroundColor: Color = .white
} 

struct ArticleCardStyle: Codable, Identifiable {
    var id: UUID
    let name: String
    
    // 背景相关
    let useGradient: Bool
    let gradientColors: [Color]
    let gradientAngle: Double
    let backgroundColor: Color
    
    // 卡片相关
    let cardBackgroundColor: Color
    let cardOpacity: Double
    let cornerRadius: CGFloat
    let edgePadding: CGFloat
    let innerPadding: CGFloat
    let moduleHeight: CGFloat
    let moduleBackgroundColor: Color
    
    // 字体相关
    let titleFont: String
    let contentFont: String
    let titleSize: CGFloat
    let contentSize: CGFloat
    let titleColor: Color
    let contentColor: Color
    
    // 模块颜色
    let authorColor: Color
    let wordCountColor: Color
    let qrCodeColor: Color
    let dataColor: Color
    let watermarkColor: Color
    let watermarkOpacity: Double
    
    init(
        id: UUID = UUID(),
        name: String,
        useGradient: Bool,
        gradientColors: [Color],
        gradientAngle: Double,
        backgroundColor: Color,
        cardBackgroundColor: Color,
        cardOpacity: Double,
        cornerRadius: CGFloat,
        edgePadding: CGFloat,
        innerPadding: CGFloat,
        moduleHeight: CGFloat,
        moduleBackgroundColor: Color,
        titleFont: String,
        contentFont: String,
        titleSize: CGFloat,
        contentSize: CGFloat,
        titleColor: Color,
        contentColor: Color,
        authorColor: Color,
        wordCountColor: Color,
        qrCodeColor: Color,
        dataColor: Color,
        watermarkColor: Color,
        watermarkOpacity: Double
    ) {
        self.id = id
        self.name = name
        self.useGradient = useGradient
        self.gradientColors = gradientColors
        self.gradientAngle = gradientAngle
        self.backgroundColor = backgroundColor
        self.cardBackgroundColor = cardBackgroundColor
        self.cardOpacity = cardOpacity
        self.cornerRadius = cornerRadius
        self.edgePadding = edgePadding
        self.innerPadding = innerPadding
        self.moduleHeight = moduleHeight
        self.moduleBackgroundColor = moduleBackgroundColor
        self.titleFont = titleFont
        self.contentFont = contentFont
        self.titleSize = titleSize
        self.contentSize = contentSize
        self.titleColor = titleColor
        self.contentColor = contentColor
        self.authorColor = authorColor
        self.wordCountColor = wordCountColor
        self.qrCodeColor = qrCodeColor
        self.dataColor = dataColor
        self.watermarkColor = watermarkColor
        self.watermarkOpacity = watermarkOpacity
    }
}

// MARK: - 预设样式
extension ArticleCardStyle {
    static let presets: [ArticleCardStyle] = [
        // 1. 暖阳橙 (Sunny Morning)
        ArticleCardStyle(
            name: "暖阳橙",
            useGradient: true,
            gradientColors: [Color(hex: "#f6d365"), Color(hex: "#fda085")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#f6d365"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        ),
        
        // 2. 清新绿 (Summer)
        ArticleCardStyle(
            name: "清新绿",
            useGradient: true,
            gradientColors: [Color(hex: "#22c1c3"), Color(hex: "#fdbb2d")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#22c1c3"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        ),
        
        // 3. 晨光粉 (Soft Cherish)
        ArticleCardStyle(
            name: "晨光粉",
            useGradient: true,
            gradientColors: [Color(hex: "#dbdcd7"), Color(hex: "#dddcd7"), Color(hex: "#e2c9cc")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#dbdcd7"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        ),
        
        // 4. 薄荷蓝 (Winter Neva)
        ArticleCardStyle(
            name: "薄荷蓝",
            useGradient: true,
            gradientColors: [Color(hex: "#a1c4fd"), Color(hex: "#c2e9fb")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#a1c4fd"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        ),
        
        // 5. 梦幻紫 (Plum Plate)
        ArticleCardStyle(
            name: "梦幻紫",
            useGradient: true,
            gradientColors: [Color(hex: "#667eea"), Color(hex: "#764ba2")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#667eea"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        ),
        
        // 6. 玫瑰粉 (Lady Lips)
        ArticleCardStyle(
            name: "玫瑰粉",
            useGradient: true,
            gradientColors: [Color(hex: "#ff9a9e"), Color(hex: "#fecfef")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#ff9a9e"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        ),
        
        // 7. 海洋蓝 (Sea Lord)
        ArticleCardStyle(
            name: "海洋蓝",
            useGradient: true,
            gradientColors: [Color(hex: "#2cd8d5"), Color(hex: "#c5c1ff"), Color(hex: "#ffbac3")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#2cd8d5"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        ),
        
        // 8. 向日葵 (Sun Veggie)
        ArticleCardStyle(
            name: "向日葵",
            useGradient: true,
            gradientColors: [Color(hex: "#FFE259"), Color(hex: "#FFA751")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#FFE259"),
            cardBackgroundColor: Color(hex: "#1A1A1A"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: Color(hex: "#262626"),
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#FFFFFF"),
            contentColor: Color(hex: "#E5E5E5"),
            authorColor: Color(hex: "#A3A3A3"),
            wordCountColor: Color(hex: "#A3A3A3"),
            qrCodeColor: Color(hex: "#A3A3A3"),
            dataColor: Color(hex: "#A3A3A3"),
            watermarkColor: Color(hex: "#A3A3A3"),
            watermarkOpacity: 0.5
        ),
        
        // 9. 樱花粉 (Perfect White)
        ArticleCardStyle(
            name: "樱花粉",
            useGradient: true,
            gradientColors: [Color(hex: "#fbc2eb"), Color(hex: "#a6c1ee")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#fbc2eb"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        ),
        
        // 10. 柠檬黄 (Lemon Gate)
        ArticleCardStyle(
            name: "柠檬黄",
            useGradient: true,
            gradientColors: [Color(hex: "#96fbc4"), Color(hex: "#f9f586")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#96fbc4"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        ),
        
        // 11. 珊瑚橙 (Happy Fisher)
        ArticleCardStyle(
            name: "珊瑚橙",
            useGradient: true,
            gradientColors: [Color(hex: "#89f7fe"), Color(hex: "#66a6ff")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#89f7fe"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        ),
        
        // 12. 极光绿 (Mixed Hopes)
        ArticleCardStyle(
            name: "极光绿",
            useGradient: true,
            gradientColors: [Color(hex: "#c471f5"), Color(hex: "#fa71cd")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#c471f5"),
            cardBackgroundColor: Color(hex: "#f5f4f7"),
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 16,
            innerPadding: 16,
            moduleHeight: 44,
            moduleBackgroundColor: .white,
            titleFont: "PingFangSC-Semibold",
            contentFont: "PingFangSC-Regular",
            titleSize: 24,
            contentSize: 16,
            titleColor: Color(hex: "#333333"),
            contentColor: Color(hex: "#333333"),
            authorColor: Color(hex: "#a1a1a1"),
            wordCountColor: Color(hex: "#a1a1a1"),
            qrCodeColor: Color(hex: "#a1a1a1"),
            dataColor: Color(hex: "#a1a1a1"),
            watermarkColor: Color(hex: "#a1a1a1"),
            watermarkOpacity: 0.5
        )
    ]
}

// MARK: - 样式应用
extension ArticleCardStyle {
    func apply(to viewModel: ArticleCardViewModel) {
        viewModel.useGradient = useGradient
        viewModel.gradientColors = gradientColors
        viewModel.gradientAngle = gradientAngle
        viewModel.backgroundColor = backgroundColor
        viewModel.cardBackgroundColor = cardBackgroundColor
        viewModel.cardOpacity = cardOpacity
        viewModel.cornerRadius = cornerRadius
        viewModel.edgePadding = edgePadding
        viewModel.innerPadding = innerPadding
        viewModel.moduleHeight = moduleHeight
        viewModel.moduleBackgroundColor = moduleBackgroundColor
        viewModel.titleFont = titleFont
        viewModel.contentFont = contentFont
        viewModel.titleSize = titleSize
        viewModel.contentSize = contentSize
        viewModel.titleColor = titleColor
        viewModel.contentColor = contentColor
        viewModel.authorColor = authorColor
        viewModel.wordCountColor = wordCountColor
        viewModel.qrCodeColor = qrCodeColor
        viewModel.dataColor = dataColor
        viewModel.watermarkColor = watermarkColor
        viewModel.watermarkOpacity = watermarkOpacity
    }
}

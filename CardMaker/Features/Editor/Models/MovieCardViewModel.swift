import SwiftUI

class MovieCardViewModel: ObservableObject {
    // 基础属性
    @Published var title: String = "在细雨中呼喊"
    @Published var subtitle: String = "余华"
    @Published var content: String = "我不再装模作样地拥有很多朋友，而是回到了孤单之中，以真正的我开始了独自的生活。有时我也会因为寂寞而难以忍受空虚的折磨，但我宁愿以这样的方式来维护自己的自尊，也不愿以耻辱为代价去换取那种表面的朋友。"
    @Published var award: String = "经典语录"
    @Published var image: UIImage?
    
    // 样式属性
    @Published var backgroundColor: Color = .clear
    @Published var cardBackgroundColor: Color = .white.opacity(0.85)
    @Published var titleColor: Color = Color(hex: "#00838F")
    @Published var textColor: Color = Color(hex: "#006064")
    @Published var awardTextColor: Color = Color(hex: "#5c5c5c").opacity(0.9)
    
    // 字体属性
    @Published var titleFont: String = "SmileySans-Oblique"
    @Published var contentFont: String = "LXGWWenKai-Regular"
    @Published var titleFontSize: CGFloat = 16
    @Published var contentFontSize: CGFloat = 12
    
    // 背景效果
    @Published var blurRadius: CGFloat = 4
    @Published var darkenAmount: CGFloat = 0.05
    @Published var cardOpacity: CGFloat = 0.9
    
    // 水印属性
    @Published var watermarkText: String = "CardMaker"
    @Published var watermarkSize: CGFloat = 8
    @Published var watermarkOpacity: CGFloat = 0.9
    @Published var watermarkColor: Color = Color(hex: "#5c5c5c").opacity(0.7)
    
    // 布局控制
    @Published var showAward: Bool = true
    @Published var showWatermark: Bool = true
    
    // 卡片布局
    @Published var cornerRadius: CGFloat = 14
    @Published var contentCardPadding: CGFloat = 20
    @Published var horizontalPadding: CGFloat = 17
    @Published var bottomPadding: CGFloat = 32
    @Published var lineSpacing: CGFloat = 6
    @Published var headerPadding: CGFloat = 12
    @Published var headerHorizontalPadding: CGFloat = 16
    @Published var shadowRadius: CGFloat = 10
    @Published var shadowOpacity: CGFloat = 0.1
    @Published var contentCardOpacity: CGFloat = 0.9
    
    // 顶部栏
    @Published var awardFontSize: CGFloat = 8
    @Published var awardPrefix: String = "| "
    
    // 时间相关
    @Published var showDate: Bool = true
    @Published var date: Date = Date()
    @Published var dateFormat: DateFormat = .standard
    @Published var dateColor: Color = Color(hex: "#00ACC1")
    
    // 背景相关
    @Published var useGradient: Bool = true
    @Published var gradientColors: [Color] = [Color(hex: "#E0F7FA"), Color(hex: "#B2EBF2")]
    @Published var gradientAngle: Double = 45
}


struct MovieCardStyle: Codable, Identifiable {
    var id: UUID
    let name: String
    let useGradient: Bool
    let gradientColors: [Color]
    let gradientAngle: Double
    let backgroundColor: Color
    let cardBackgroundColor: Color
    let cardOpacity: Double
    let cornerRadius: CGFloat
    let blurRadius: CGFloat
    let darkenAmount: Double
    let titleColor: Color
    let textColor: Color
    let dateColor: Color
    let awardTextColor: Color
    let watermarkColor: Color
    let titleFont: String
    let titleFontSize: CGFloat
    let contentFont: String
    let contentFontSize: CGFloat
    let showWatermark: Bool
    let watermarkText: String
    let watermarkOpacity: Double
    let watermarkSize: CGFloat
    let topPadding: CGFloat
    let horizontalPadding: CGFloat
    let bottomPadding: CGFloat

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
        blurRadius: CGFloat,
        darkenAmount: Double,
        titleColor: Color,
        textColor: Color,
        dateColor: Color,
        awardTextColor: Color,
        watermarkColor: Color,
        titleFont: String,
        titleFontSize: CGFloat,
        contentFont: String,
        contentFontSize: CGFloat,
        showWatermark: Bool,
        watermarkText: String,
        watermarkOpacity: Double,
        watermarkSize: CGFloat,
        topPadding: CGFloat,
        horizontalPadding: CGFloat,
        bottomPadding: CGFloat
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
        self.blurRadius = blurRadius
        self.darkenAmount = darkenAmount
        self.titleColor = titleColor
        self.textColor = textColor
        self.dateColor = dateColor
        self.awardTextColor = awardTextColor
        self.watermarkColor = watermarkColor
        self.titleFont = titleFont
        self.titleFontSize = titleFontSize
        self.contentFont = contentFont
        self.contentFontSize = contentFontSize
        self.showWatermark = showWatermark
        self.watermarkText = watermarkText
        self.watermarkOpacity = watermarkOpacity
        self.watermarkSize = watermarkSize
        self.topPadding = topPadding
        self.horizontalPadding = horizontalPadding
        self.bottomPadding = bottomPadding
    }
}

// MARK: - 预设样式
extension MovieCardStyle {
   static let presets: [MovieCardStyle] = [
        // 原有的清新蓝
        MovieCardStyle(
            name: "清新蓝",
            useGradient: true,
            gradientColors: [Color(hex: "#E0F7FA"), Color(hex: "#B2EBF2")],
            gradientAngle: 45,
            backgroundColor: .clear,
            cardBackgroundColor: .white.opacity(0.85),
            cardOpacity: 0.9,
            cornerRadius: 14,
            blurRadius: 4,
            darkenAmount: 0.05,
            titleColor: Color(hex: "#00838F"),
            textColor: Color(hex: "#006064"),
            dateColor: Color(hex: "#00ACC1"),
            awardTextColor: Color(hex: "#5c5c5c").opacity(0.9),
            watermarkColor: Color(hex: "#5c5c5c").opacity(0.7),
            titleFont: "SmileySans-Oblique",
            titleFontSize: 16,
            contentFont: "LXGWWenKai-Regular",
            contentFontSize: 12,
            showWatermark: true,
            watermarkText: "CardMaker",
            watermarkOpacity: 0.9,
            watermarkSize: 8,
            topPadding: 12,
            horizontalPadding: 17,
            bottomPadding: 32
        ),
        
        // 暖阳橙
        MovieCardStyle(
            name: "暖阳橙",
            useGradient: true,
            gradientColors: [Color(hex: "#FFF3E0"), Color(hex: "#FFE0B2")],
            gradientAngle: 45,
            backgroundColor: .clear,
            cardBackgroundColor: .white.opacity(0.9),
            cardOpacity: 0.85,
            cornerRadius: 16,
            blurRadius: 5,
            darkenAmount: 0.08,
            titleColor: Color(hex: "#E65100"),
            textColor: Color(hex: "#EF6C00"),
            dateColor: Color(hex: "#F57C00"),
            awardTextColor: Color(hex: "#5c5c5c").opacity(0.85),
            watermarkColor: Color(hex: "#5c5c5c").opacity(0.65),
            titleFont: "SmileySans-Oblique",
            titleFontSize: 18,
            contentFont: "LXGWWenKai-Regular",
            contentFontSize: 13,
            showWatermark: true,
            watermarkText: "CardMaker",
            watermarkOpacity: 0.85,
            watermarkSize: 8,
            topPadding: 14,
            horizontalPadding: 18,
            bottomPadding: 34
        ),
        
        // 薄荷绿
        MovieCardStyle(
            name: "薄荷绿",
            useGradient: true,
            gradientColors: [Color(hex: "#E8F5E9"), Color(hex: "#C8E6C9")],
            gradientAngle: 45,
            backgroundColor: .clear,
            cardBackgroundColor: .white.opacity(0.88),
            cardOpacity: 0.92,
            cornerRadius: 12,
            blurRadius: 3,
            darkenAmount: 0.04,
            titleColor: Color(hex: "#2E7D32"),
            textColor: Color(hex: "#388E3C"),
            dateColor: Color(hex: "#43A047"),
            awardTextColor: Color(hex: "#5c5c5c").opacity(0.88),
            watermarkColor: Color(hex: "#5c5c5c").opacity(0.68),
            titleFont: "SmileySans-Oblique",
            titleFontSize: 17,
            contentFont: "LXGWWenKai-Regular",
            contentFontSize: 12,
            showWatermark: true,
            watermarkText: "CardMaker",
            watermarkOpacity: 0.88,
            watermarkSize: 8,
            topPadding: 13,
            horizontalPadding: 16,
            bottomPadding: 30
        ),
        
        // 浪漫紫
        MovieCardStyle(
            name: "浪漫紫",
            useGradient: true,
            gradientColors: [Color(hex: "#F3E5F5"), Color(hex: "#E1BEE7")],
            gradientAngle: 45,
            backgroundColor: .clear,
            cardBackgroundColor: .white.opacity(0.87),
            cardOpacity: 0.88,
            cornerRadius: 15,
            blurRadius: 4.5,
            darkenAmount: 0.06,
            titleColor: Color(hex: "#6A1B9A"),
            textColor: Color(hex: "#7B1FA2"),
            dateColor: Color(hex: "#8E24AA"),
            awardTextColor: Color(hex: "#5c5c5c").opacity(0.87),
            watermarkColor: Color(hex: "#5c5c5c").opacity(0.67),
            titleFont: "SmileySans-Oblique",
            titleFontSize: 16,
            contentFont: "LXGWWenKai-Regular",
            contentFontSize: 12,
            showWatermark: true,
            watermarkText: "CardMaker",
            watermarkOpacity: 0.87,
            watermarkSize: 8,
            topPadding: 13,
            horizontalPadding: 17,
            bottomPadding: 31
        ),
        
        // 深邃蓝
        MovieCardStyle(
            name: "深邃蓝",
            useGradient: true,
            gradientColors: [Color(hex: "#E3F2FD"), Color(hex: "#BBDEFB")],
            gradientAngle: 45,
            backgroundColor: .clear,
            cardBackgroundColor: .white.opacity(0.86),
            cardOpacity: 0.89,
            cornerRadius: 14,
            blurRadius: 4,
            darkenAmount: 0.07,
            titleColor: Color(hex: "#1565C0"),
            textColor: Color(hex: "#1976D2"),
            dateColor: Color(hex: "#1E88E5"),
            awardTextColor: Color(hex: "#5c5c5c").opacity(0.86),
            watermarkColor: Color(hex: "#5c5c5c").opacity(0.66),
            titleFont: "SmileySans-Oblique",
            titleFontSize: 17,
            contentFont: "LXGWWenKai-Regular",
            contentFontSize: 12,
            showWatermark: true,
            watermarkText: "CardMaker",
            watermarkOpacity: 0.86,
            watermarkSize: 8,
            topPadding: 12,
            horizontalPadding: 16,
            bottomPadding: 32
        ),
        
        // 暮光粉
        MovieCardStyle(
            name: "暮光粉",
            useGradient: true,
            gradientColors: [Color(hex: "#FCE4EC"), Color(hex: "#F8BBD0")],
            gradientAngle: 45,
            backgroundColor: .clear,
            cardBackgroundColor: .white.opacity(0.88),
            cardOpacity: 0.9,
            cornerRadius: 13,
            blurRadius: 4,
            darkenAmount: 0.05,
            titleColor: Color(hex: "#C2185B"),
            textColor: Color(hex: "#D81B60"),
            dateColor: Color(hex: "#E91E63"),
            awardTextColor: Color(hex: "#5c5c5c").opacity(0.88),
            watermarkColor: Color(hex: "#5c5c5c").opacity(0.68),
            titleFont: "SmileySans-Oblique",
            titleFontSize: 16,
            contentFont: "LXGWWenKai-Regular",
            contentFontSize: 12,
            showWatermark: true,
            watermarkText: "CardMaker",
            watermarkOpacity: 0.88,
            watermarkSize: 8,
            topPadding: 13,
            horizontalPadding: 17,
            bottomPadding: 31
        ),
        
        // 秋日棕
        MovieCardStyle(
            name: "秋日棕",
            useGradient: true,
            gradientColors: [Color(hex: "#EFEBE9"), Color(hex: "#D7CCC8")],
            gradientAngle: 45,
            backgroundColor: .clear,
            cardBackgroundColor: .white.opacity(0.87),
            cardOpacity: 0.89,
            cornerRadius: 14,
            blurRadius: 4,
            darkenAmount: 0.06,
            titleColor: Color(hex: "#4E342E"),
            textColor: Color(hex: "#5D4037"),
            dateColor: Color(hex: "#6D4C41"),
            awardTextColor: Color(hex: "#5c5c5c").opacity(0.87),
            watermarkColor: Color(hex: "#5c5c5c").opacity(0.67),
            titleFont: "SmileySans-Oblique",
            titleFontSize: 16,
            contentFont: "LXGWWenKai-Regular",
            contentFontSize: 12,
            showWatermark: true,
            watermarkText: "CardMaker",
            watermarkOpacity: 0.87,
            watermarkSize: 8,
            topPadding: 12,
            horizontalPadding: 17,
            bottomPadding: 32
        ),
        
        // 墨黑
        MovieCardStyle(
            name: "墨黑",
            useGradient: true,
            gradientColors: [Color(hex: "#ECEFF1"), Color(hex: "#CFD8DC")],
            gradientAngle: 45,
            backgroundColor: .clear,
            cardBackgroundColor: .white.opacity(0.85),
            cardOpacity: 0.88,
            cornerRadius: 14,
            blurRadius: 4,
            darkenAmount: 0.07,
            titleColor: Color(hex: "#263238"),
            textColor: Color(hex: "#37474F"),
            dateColor: Color(hex: "#455A64"),
            awardTextColor: Color(hex: "#5c5c5c").opacity(0.85),
            watermarkColor: Color(hex: "#5c5c5c").opacity(0.65),
            titleFont: "SmileySans-Oblique",
            titleFontSize: 16,
            contentFont: "LXGWWenKai-Regular",
            contentFontSize: 12,
            showWatermark: true,
            watermarkText: "CardMaker",
            watermarkOpacity: 0.85,
            watermarkSize: 8,
            topPadding: 12,
            horizontalPadding: 17,
            bottomPadding: 32
        ),
        
        // 极简白
        MovieCardStyle(
            name: "极简白",
            useGradient: false,
            gradientColors: [.white, .white],
            gradientAngle: 45,
            backgroundColor: .white,
            cardBackgroundColor: .white.opacity(0.95),
            cardOpacity: 0.95,
            cornerRadius: 12,
            blurRadius: 3,
            darkenAmount: 0.03,
            titleColor: Color(hex: "#212121"),
            textColor: Color(hex: "#424242"),
            dateColor: Color(hex: "#616161"),
            awardTextColor: Color(hex: "#5c5c5c").opacity(0.9),
            watermarkColor: Color(hex: "#5c5c5c").opacity(0.7),
            titleFont: "SmileySans-Oblique",
            titleFontSize: 16,
            contentFont: "LXGWWenKai-Regular",
            contentFontSize: 12,
            showWatermark: true,
            watermarkText: "CardMaker",
            watermarkOpacity: 0.9,
            watermarkSize: 8,
            topPadding: 12,
            horizontalPadding: 16,
            bottomPadding: 30
        )
    ]
    
    func apply(to card: MovieCardViewModel) {
        card.useGradient = useGradient
        card.gradientColors = gradientColors
        card.gradientAngle = gradientAngle
        card.backgroundColor = backgroundColor
        card.cardBackgroundColor = cardBackgroundColor
        card.contentCardOpacity = cardOpacity
        card.cornerRadius = cornerRadius
        card.blurRadius = blurRadius
        card.darkenAmount = darkenAmount
        card.titleColor = titleColor
        card.textColor = textColor
        card.dateColor = dateColor
        card.awardTextColor = awardTextColor
        card.watermarkColor = watermarkColor
        card.titleFont = titleFont
        card.titleFontSize = titleFontSize
        card.contentFont = contentFont
        card.contentFontSize = contentFontSize
        card.showWatermark = showWatermark
        card.watermarkText = watermarkText
        card.watermarkOpacity = watermarkOpacity
        card.watermarkSize = watermarkSize
        card.headerPadding = topPadding
        card.horizontalPadding = horizontalPadding
        card.bottomPadding = bottomPadding
    }
}

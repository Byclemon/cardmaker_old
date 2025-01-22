import SwiftUI

enum WatermarkPosition: String, Codable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomCenter
    case bottomRight
    case center
}

// MARK: - 基础卡片样式参数
class BaseCardViewModel: ObservableObject {
    // MARK: - 文本相关
    @Published var content: String = ""
    @Published var selectedFont: String = "HongLeiZhuoShu"
    @Published var fontSize: CGFloat = 23.0
    @Published var textColor: Color = Color(hex: "#333333")
    @Published var textAlignment: TextAlignment = .center
    @Published var lineSpacing: CGFloat = 10.0
    @Published var textSpacing: CGFloat = 0.0
    @Published var textShadowRadius: CGFloat = 2.0
    @Published var textShadowColor: Color = Color.white.opacity(0.5)
    @Published var isEditingText: Bool = false
    @Published var editingText: String = ""
    
    // MARK: - 背景相关
    @Published var useGradient: Bool = true
    @Published var gradientColors: [Color] = [Color(hex: "#FCEDCD"), Color(hex: "#83ECC6")]
    @Published var gradientAngle: Double = 82.0
    @Published var backgroundColor: Color = Color(hex: "#a18cd1")
    @Published var cardBackgroundColor: Color = .white
    @Published var cardOpacity: Double = 0.90
    
    // MARK: - 布局相关
    @Published var showWindowControls: Bool = true
    @Published var cornerRadius: CGFloat = 16.0
    @Published var edgePadding: CGFloat = 30.0
    @Published var innerPadding: CGFloat = 12.0
    @Published var selectedAspectRatioIndex: Int = 1
    
    // MARK: - 水印相关
    @Published var showWatermark: Bool = true
    @Published var watermarkText: String = "@CardMaker"
    @Published var watermarkOpacity: Double = 0.3
    @Published var watermarkColor: Color = Color.gray
    @Published var watermarkSize: CGFloat = 8.0
    @Published var watermarkPosition: WatermarkPosition = .bottomRight
    

}

struct BaseCardStyle: Codable, Identifiable {
    var id: UUID
    let name: String
    // 背景相关
    let useGradient: Bool
    let gradientColors: [Color]
    let gradientAngle: Double
    let backgroundColor: Color
    // 卡片相关
    let showWindowControls: Bool
    let cardBackgroundColor: Color
    let cardOpacity: Double
    let cornerRadius: CGFloat
    let edgePadding: CGFloat
    let innerPadding: CGFloat
    // 文字相关
    let selectedFont: String
    let fontSize: CGFloat
    let textColor: Color
    let textAlignment: TextAlignment
    let lineSpacing: CGFloat
    let textSpacing: CGFloat
    let textShadowRadius: CGFloat
    let textShadowColor: Color
    // 水印相关
    let showWatermark: Bool
    let watermarkText: String
    let watermarkOpacity: Double
    let watermarkSize: CGFloat
    let watermarkColor: Color
    let watermarkPosition: WatermarkPosition
    
    init(
        id: UUID = UUID(),
        name: String,
        useGradient: Bool,
        gradientColors: [Color],
        gradientAngle: Double,
        backgroundColor: Color,
        showWindowControls: Bool,
        cardBackgroundColor: Color,
        cardOpacity: Double,
        cornerRadius: CGFloat,
        edgePadding: CGFloat,
        innerPadding: CGFloat,
        selectedFont: String,
        fontSize: CGFloat,
        textColor: Color,
        textAlignment: TextAlignment,
        lineSpacing: CGFloat,
        textSpacing: CGFloat,
        textShadowRadius: CGFloat,
        textShadowColor: Color,
        showWatermark: Bool,
        watermarkText: String,
        watermarkOpacity: Double,
        watermarkSize: CGFloat,
        watermarkColor: Color,
        watermarkPosition: WatermarkPosition
    ) {
        self.id = id
        self.name = name
        self.useGradient = useGradient
        self.gradientColors = gradientColors
        self.gradientAngle = gradientAngle
        self.backgroundColor = backgroundColor
        self.showWindowControls = showWindowControls
        self.cardBackgroundColor = cardBackgroundColor
        self.cardOpacity = cardOpacity
        self.cornerRadius = cornerRadius
        self.edgePadding = edgePadding
        self.innerPadding = innerPadding
        self.selectedFont = selectedFont
        self.fontSize = fontSize
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.lineSpacing = lineSpacing
        self.textSpacing = textSpacing
        self.textShadowRadius = textShadowRadius
        self.textShadowColor = textShadowColor
        self.showWatermark = showWatermark
        self.watermarkText = watermarkText
        self.watermarkOpacity = watermarkOpacity
        self.watermarkSize = watermarkSize
        self.watermarkColor = watermarkColor
        self.watermarkPosition = watermarkPosition
    }
}

// MARK: - 预设样式
extension BaseCardStyle {
    static let presets: [BaseCardStyle] = [
        // 简约白
        BaseCardStyle(
            name: "简约白",
            useGradient: false,
            gradientColors: [Color.white],
            gradientAngle: 0,
            backgroundColor: Color.white,
            showWindowControls: true,
            cardBackgroundColor: Color.white,
            cardOpacity: 1.0,
            cornerRadius: 16,
            edgePadding: 25,
            innerPadding: 20,
            selectedFont: "TsangerYuMo",
            fontSize: 24,
            textColor: Color.black,
            textAlignment: .center,
            lineSpacing: 8,
            textSpacing: 0,
            textShadowRadius: 0,
            textShadowColor: Color.clear,
            showWatermark: true,
            watermarkText: "@CardMaker",
            watermarkOpacity: 0.3,
            watermarkSize: 8,
            watermarkColor: Color.gray,
            watermarkPosition: .bottomRight
        ),
        
        // 渐变紫
        BaseCardStyle(
            name: "渐变紫",
            useGradient: true,
            gradientColors: [Color(hex: "#a18cd1"), Color(hex: "#fbc2eb")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#a18cd1"),
            showWindowControls: true,
            cardBackgroundColor: .white,
            cardOpacity: 0.95,
            cornerRadius: 16,
            edgePadding: 25,
            innerPadding: 20,
            selectedFont: "TsangerYuMo",
            fontSize: 24,
            textColor: Color(hex: "#333333"),
            textAlignment: .center,
            lineSpacing: 8,
            textSpacing: 0,
            textShadowRadius: 2,
            textShadowColor: Color.white.opacity(0.5),
            showWatermark: true,
            watermarkText: "@CardMaker",
            watermarkOpacity: 0.3,
            watermarkSize: 8,
            watermarkColor: Color.gray,
            watermarkPosition: .bottomRight
        ),
        
        // 海洋蓝
        BaseCardStyle(
            name: "海洋蓝",
            useGradient: true,
            gradientColors: [Color(hex: "#0984E3"), Color(hex: "#74B9FF")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#0984E3"),
            showWindowControls: true,
            cardBackgroundColor: .white,
            cardOpacity: 0.95,
            cornerRadius: 16,
            edgePadding: 25,
            innerPadding: 20,
            selectedFont: "TsangerYuMo",
            fontSize: 24,
            textColor: Color(hex: "#333333"),
            textAlignment: .center,
            lineSpacing: 8,
            textSpacing: 0,
            textShadowRadius: 2,
            textShadowColor: Color.white.opacity(0.5),
            showWatermark: true,
            watermarkText: "@CardMaker",
            watermarkOpacity: 0.3,
            watermarkSize: 8,
            watermarkColor: Color.gray,
            watermarkPosition: .bottomRight
        ),
        
        // 清新绿
        BaseCardStyle(
            name: "清新绿",
            useGradient: true,
            gradientColors: [Color(hex: "#00B894"), Color(hex: "#55EFC4")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#00B894"),
            showWindowControls: true,
            cardBackgroundColor: .white,
            cardOpacity: 0.95,
            cornerRadius: 16,
            edgePadding: 25,
            innerPadding: 20,
            selectedFont: "TsangerYuMo",
            fontSize: 24,
            textColor: Color(hex: "#333333"),
            textAlignment: .center,
            lineSpacing: 8,
            textSpacing: 0,
            textShadowRadius: 2,
            textShadowColor: Color.white.opacity(0.5),
            showWatermark: true,
            watermarkText: "@CardMaker",
            watermarkOpacity: 0.3,
            watermarkSize: 8,
            watermarkColor: Color.gray,
            watermarkPosition: .bottomRight
        ),
        
        // 暖阳橙
        BaseCardStyle(
            name: "暖阳橙",
            useGradient: true,
            gradientColors: [Color(hex: "#F6D365"), Color(hex: "#FDA085")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#F6D365"),
            showWindowControls: true,
            cardBackgroundColor: .white,
            cardOpacity: 0.95,
            cornerRadius: 16,
            edgePadding: 25,
            innerPadding: 20,
            selectedFont: "TsangerYuMo",
            fontSize: 24,
            textColor: Color(hex: "#333333"),
            textAlignment: .center,
            lineSpacing: 8,
            textSpacing: 0,
            textShadowRadius: 2,
            textShadowColor: Color.white.opacity(0.5),
            showWatermark: true,
            watermarkText: "@CardMaker",
            watermarkOpacity: 0.3,
            watermarkSize: 8,
            watermarkColor: Color.gray,
            watermarkPosition: .bottomRight
        ),
        
        // 深邃黑
        BaseCardStyle(
            name: "深邃黑",
            useGradient: true,
            gradientColors: [Color(hex: "#434343"), Color(hex: "#000000")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#434343"),
            showWindowControls: true,
            cardBackgroundColor: .white,
            cardOpacity: 0.95,
            cornerRadius: 16,
            edgePadding: 25,
            innerPadding: 20,
            selectedFont: "TsangerYuMo",
            fontSize: 24,
            textColor: Color.black,
            textAlignment: .center,
            lineSpacing: 8,
            textSpacing: 0,
            textShadowRadius: 2,
            textShadowColor: Color.black.opacity(0.5),
            showWatermark: true,
            watermarkText: "@CardMaker",
            watermarkOpacity: 0.3,
            watermarkSize: 8,
            watermarkColor: Color.gray,
            watermarkPosition: .bottomRight
        ),
        
        // 极光紫
        BaseCardStyle(
            name: "极光紫",
            useGradient: true,
            gradientColors: [Color(hex: "#7F00FF"), Color(hex: "#E100FF")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#7F00FF"),
            showWindowControls: true,
            cardBackgroundColor: .white,
            cardOpacity: 0.95,
            cornerRadius: 16,
            edgePadding: 25,
            innerPadding: 20,
            selectedFont: "TsangerYuMo",
            fontSize: 24,
            textColor: Color(hex: "#333333"),
            textAlignment: .center,
            lineSpacing: 8,
            textSpacing: 0,
            textShadowRadius: 2,
            textShadowColor: Color.white.opacity(0.5),
            showWatermark: true,
            watermarkText: "@CardMaker",
            watermarkOpacity: 0.3,
            watermarkSize: 8,
            watermarkColor: Color.gray,
            watermarkPosition: .bottomRight
        ),
        
        // 日落金
        BaseCardStyle(
            name: "日落金",
            useGradient: true,
            gradientColors: [Color(hex: "#FFE259"), Color(hex: "#FFA751")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#FFE259"),
            showWindowControls: true,
            cardBackgroundColor: .white,
            cardOpacity: 0.95,
            cornerRadius: 16,
            edgePadding: 25,
            innerPadding: 20,
            selectedFont: "TsangerYuMo",
            fontSize: 24,
            textColor: Color(hex: "#333333"),
            textAlignment: .center,
            lineSpacing: 8,
            textSpacing: 0,
            textShadowRadius: 2,
            textShadowColor: Color.white.opacity(0.5),
            showWatermark: true,
            watermarkText: "@CardMaker",
            watermarkOpacity: 0.3,
            watermarkSize: 8,
            watermarkColor: Color.gray,
            watermarkPosition: .bottomRight
        ),
        
        // 薄荷绿
        BaseCardStyle(
            name: "薄荷绿",
            useGradient: true,
            gradientColors: [Color(hex: "#00F2FE"), Color(hex: "#4FACFE")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#00F2FE"),
            showWindowControls: true,
            cardBackgroundColor: .white,
            cardOpacity: 0.95,
            cornerRadius: 16,
            edgePadding: 25,
            innerPadding: 20,
            selectedFont: "TsangerYuMo",
            fontSize: 24,
            textColor: Color(hex: "#333333"),
            textAlignment: .center,
            lineSpacing: 8,
            textSpacing: 0,
            textShadowRadius: 2,
            textShadowColor: Color.white.opacity(0.5),
            showWatermark: true,
            watermarkText: "@CardMaker",
            watermarkOpacity: 0.3,
            watermarkSize: 8,
            watermarkColor: Color.gray,
            watermarkPosition: .bottomRight
        ),
        
        // 玫瑰粉
        BaseCardStyle(
            name: "玫瑰粉",
            useGradient: true,
            gradientColors: [Color(hex: "#FF9A9E"), Color(hex: "#FAD0C4")],
            gradientAngle: 45,
            backgroundColor: Color(hex: "#FF9A9E"),
            showWindowControls: true,
            cardBackgroundColor: .white,
            cardOpacity: 0.95,
            cornerRadius: 16,
            edgePadding: 25,
            innerPadding: 20,
            selectedFont: "TsangerYuMo",
            fontSize: 24,
            textColor: Color(hex: "#333333"),
            textAlignment: .center,
            lineSpacing: 8,
            textSpacing: 0,
            textShadowRadius: 2,
            textShadowColor: Color.white.opacity(0.5),
            showWatermark: true,
            watermarkText: "@CardMaker",
            watermarkOpacity: 0.3,
            watermarkSize: 8,
            watermarkColor: Color.gray,
            watermarkPosition: .bottomRight
        )
    ]
}

// MARK: - 样式应用
extension BaseCardStyle {
    func apply(to viewModel: BaseCardViewModel) {
        viewModel.useGradient = useGradient
        viewModel.gradientColors = gradientColors
        viewModel.gradientAngle = gradientAngle
        viewModel.backgroundColor = backgroundColor
        viewModel.showWindowControls = showWindowControls
        viewModel.cardBackgroundColor = cardBackgroundColor
        viewModel.cardOpacity = cardOpacity
        viewModel.cornerRadius = cornerRadius
        viewModel.edgePadding = edgePadding
        viewModel.innerPadding = innerPadding
        viewModel.selectedFont = selectedFont
        viewModel.fontSize = fontSize
        viewModel.textColor = textColor
        viewModel.textAlignment = textAlignment
        viewModel.lineSpacing = lineSpacing
        viewModel.textSpacing = textSpacing
        viewModel.textShadowRadius = textShadowRadius
        viewModel.textShadowColor = textShadowColor
        viewModel.showWatermark = showWatermark
        // viewModel.watermarkText = watermarkText
        viewModel.watermarkOpacity = watermarkOpacity
        viewModel.watermarkSize = watermarkSize
        viewModel.watermarkColor = watermarkColor
        viewModel.watermarkPosition = watermarkPosition
    }
}



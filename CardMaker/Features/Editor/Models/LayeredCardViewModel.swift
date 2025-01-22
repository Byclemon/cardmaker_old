import SwiftUI

class LayeredCardViewModel: ObservableObject {
    // 基础属性
    @Published var content: String = "可是我再也没遇到一个像福贵这样令我难忘的人了，对自己的经历如此清楚，又能如此精彩地讲述自己是如何衰老的。这样的老人在乡间实在是难以遇上，也许是困苦的生活损坏了他们的记忆，面对往事他们通常显得木讷，常常以不知所措的微笑搪塞过去。"
    @Published var icon: String = "doc.text"

    @Published var layerVisibility: [Bool] = [true, true, true]  // 控制每层的显示/隐藏
    
    // 层叠效果属性
    @Published var layerColors: [Color] = [
        Color(hex: "#0a3cff"),   // 最上层（深蓝）
        Color(hex: "#cdd7fc"),   // 中间层（浅蓝）
        Color(hex: "#cdd7fc")    // 最底层（浅蓝）
    ]
    @Published var layerScales: [CGFloat] = [0.7, 0.7, 0.7]
    @Published var layerOffsets: [CGFloat] = [0, 0, 0]
    @Published var layerRotations: [CGFloat] = [0, -6, 6]
    
    // 背景属性
    @Published var useGradient: Bool = false
    @Published var gradientColors: [Color] = [
            Color(hex: "#a1c4fd"),
            Color(hex: "#c2e9fb")
    ]
    @Published var gradientAngle: CGFloat = 45
    @Published var backgroundColor: Color = .white
    
    // 卡片属性
    @Published var cornerRadius: CGFloat = 24
    @Published var innerPadding: CGFloat = 16
    
    // 文字属性
    @Published var selectedFont: String = "Inter-Regular"
    @Published var fontSize: CGFloat = 14
    @Published var textColor: Color = .white
    @Published var textAlignment: TextAlignment = .leading
    @Published var lineSpacing: CGFloat = 9

}

struct LayeredCardStyle: Codable, Identifiable {
    var id: UUID
    let name: String
    
    // 层叠效果属性
    let layerColors: [Color]
    let layerScales: [CGFloat]
    let layerOffsets: [CGFloat]
    let layerRotations: [CGFloat]
    let layerVisibility: [Bool]
    
    // 背景属性
    let useGradient: Bool
    let gradientColors: [Color]
    let gradientAngle: CGFloat
    let backgroundColor: Color
    
    // 文字属性
    let selectedFont: String
    let fontSize: CGFloat
    let textColor: Color
    let textAlignment: TextAlignment
    let lineSpacing: CGFloat
    
    init(
        id: UUID = UUID(),
        name: String,
        layerColors: [Color],
        layerScales: [CGFloat],
        layerOffsets: [CGFloat],
        layerRotations: [CGFloat],
        layerVisibility: [Bool],
        useGradient: Bool,
        gradientColors: [Color],
        gradientAngle: CGFloat,
        backgroundColor: Color,
        selectedFont: String,
        fontSize: CGFloat,
        textColor: Color,
        textAlignment: TextAlignment,
        lineSpacing: CGFloat
    ) {
        self.id = id
        self.name = name
        self.layerColors = layerColors
        self.layerScales = layerScales
        self.layerOffsets = layerOffsets
        self.layerRotations = layerRotations
        self.layerVisibility = layerVisibility
        self.useGradient = useGradient
        self.gradientColors = gradientColors
        self.gradientAngle = gradientAngle
        self.backgroundColor = backgroundColor
        self.selectedFont = selectedFont
        self.fontSize = fontSize
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.lineSpacing = lineSpacing
    }
}

// MARK: - 预设主题
extension LayeredCardStyle {
    static let presets: [LayeredCardStyle] = [
        // 1. 薄荷蓝 (三层不透明)
        LayeredCardStyle(
            name: "薄荷蓝",
            layerColors: [
                Color(hex: "#a1c4fd"),
                Color(hex: "#c2e9fb"),
                Color(hex: "#c2e9fb")
            ],
            layerScales: [0.7, 0.7, 0.7],
            layerOffsets: [0, 0, 0],
            layerRotations: [0, -6, 6],
            layerVisibility: [true, true, true],
            useGradient: true,
            gradientColors: [
                Color(hex: "#a1c4fd"),
                Color(hex: "#c2e9fb")
            ],
            gradientAngle: 45,
            backgroundColor: .white,
            selectedFont: "Inter-Regular",
            fontSize: 14,
            textColor: Color(hex: "#ffffff"),
            textAlignment: .leading,
            lineSpacing: 6
        ),
        
        // 2. 淡紫 (单层半透明)
        LayeredCardStyle(
            name: "淡紫",
            layerColors: [
                Color(hex: "#a18cd1").opacity(0.75),
                Color(hex: "#fbc2eb"),
                Color(hex: "#fbc2eb")
            ],
            layerScales: [0.7, 0.7, 0.7],
            layerOffsets: [0, 0, 0],
            layerRotations: [0, 0, 0],
            layerVisibility: [true, false, false],
            useGradient: true,
            gradientColors: [
                Color(hex: "#a18cd1"),
                Color(hex: "#fbc2eb")
            ],
            gradientAngle: 45,
            backgroundColor: .white,
            selectedFont: "Inter-Regular",
            fontSize: 14,
            textColor: Color(hex: "#ffffff"),
            textAlignment: .leading,
            lineSpacing: 6
        ),
        
        // 3. 清新绿 (三层不透明)
        LayeredCardStyle(
            name: "清新绿",
            layerColors: [
                Color(hex: "#00B894"),
                Color(hex: "#55EFC4"),
                Color(hex: "#55EFC4")
            ],
            layerScales: [0.7, 0.7, 0.7],
            layerOffsets: [0, 0, 0],
            layerRotations: [0, -6, 6],
            layerVisibility: [true, true, true],
            useGradient: true,
            gradientColors: [
                Color(hex: "#00B894"),
                Color(hex: "#55EFC4")
            ],
            gradientAngle: 45,
            backgroundColor: .white,
            selectedFont: "Inter-Regular",
            fontSize: 14,
            textColor: Color(hex: "#ffffff"),
            textAlignment: .leading,
            lineSpacing: 6
        )
    ]
}

// MARK: - 样式应用
extension LayeredCardStyle {
    func apply(to viewModel: LayeredCardViewModel) {
        viewModel.layerColors = layerColors
        viewModel.layerScales = layerScales
        viewModel.layerOffsets = layerOffsets
        viewModel.layerRotations = layerRotations
        viewModel.layerVisibility = layerVisibility
        viewModel.useGradient = useGradient
        viewModel.gradientColors = gradientColors
        viewModel.gradientAngle = gradientAngle
        viewModel.backgroundColor = backgroundColor
        viewModel.selectedFont = selectedFont
        viewModel.fontSize = fontSize
        viewModel.textColor = textColor
        viewModel.textAlignment = textAlignment
        viewModel.lineSpacing = lineSpacing
    }
}

import SwiftUI

// MARK: - 主视图
struct BaseCardPreview: View {
    let width: CGFloat
    let height: CGFloat
    let scale: CGFloat
    @ObservedObject var viewModel: BaseCardViewModel
    
    var body: some View {
        ZStack {
            BaseBackgroundView(viewModel: viewModel)
            
            VStack(spacing: 0) {
                if viewModel.showWindowControls {
                    BaseWindowControlsView(scale: scale)
                }
                Spacer()
                BaseContentModule(
                    scale: scale,
                    content: $viewModel.content,
                    selectedFont: viewModel.selectedFont,
                    fontSize: viewModel.fontSize,
                    textColor: viewModel.textColor,
                    textAlignment: viewModel.textAlignment,
                    lineSpacing: viewModel.lineSpacing,
                    textSpacing: viewModel.textSpacing,
                    textShadowColor: viewModel.textShadowColor,
                    textShadowRadius: viewModel.textShadowRadius,
                    innerPadding: viewModel.innerPadding
                )
                Spacer()
                if viewModel.showWatermark {
                    BaseWatermarkModule(
                        scale: scale,
                        watermarkText: $viewModel.watermarkText,
                        watermarkColor: viewModel.watermarkColor,
                        watermarkOpacity: viewModel.watermarkOpacity,
                        watermarkPosition: viewModel.watermarkPosition,
                        watermarkSize: viewModel.watermarkSize
                    )
                    .transition(.opacity)
                }
            }
            .frame(width: width - (viewModel.edgePadding * 2 * scale),
                   height: height - (viewModel.edgePadding * 2 * scale))
            .background(
                viewModel.cardBackgroundColor
                    .opacity(viewModel.cardOpacity)
                    .allowsHitTesting(false)
            )
            .cornerRadius(viewModel.cornerRadius * scale)
            .shadow(color: .black.opacity(0.2), radius: 10 * scale, x: 0, y: 4 * scale)
            .padding(viewModel.edgePadding * scale)
        }
    }
}

// MARK: - 背景视图
private struct BaseBackgroundView: View {
    @ObservedObject var viewModel: BaseCardViewModel
    
    var body: some View {
        Group {
            if viewModel.useGradient {
                LinearGradient(
                    colors: viewModel.gradientColors,
                    startPoint: .init(x: 0.5 + 0.5 * cos(viewModel.gradientAngle * .pi / 180),
                                  y: 0.5 + 0.5 * sin(viewModel.gradientAngle * .pi / 180)),
                    endPoint: .init(x: 0.5 - 0.5 * cos(viewModel.gradientAngle * .pi / 180),
                                y: 0.5 - 0.5 * sin(viewModel.gradientAngle * .pi / 180))
                )
            } else {
                viewModel.backgroundColor
            }
        }
    }
}

// MARK: - 窗口控制按钮
private struct BaseWindowControlsView: View {
    let scale: CGFloat
    
    var body: some View {
        HStack {
            HStack(spacing: 6 * scale) { 
                Circle()
                    .fill(Color.red)
                    .frame(width: 12 * scale, height: 12 * scale)
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 12 * scale, height: 12 * scale)
                Circle()
                    .fill(Color.green)
                    .frame(width: 12 * scale, height: 12 * scale)
            }
            .padding(.horizontal, 8 * scale)
            .padding(.vertical, 6 * scale)
            Spacer()
        }
        .background(Color.black.opacity(0.05))
    }
}

// MARK: - 内容模块
private struct BaseContentModule: View {
    let scale: CGFloat
    @Binding var content: String
    let selectedFont: String
    let fontSize: CGFloat
    let textColor: Color
    let textAlignment: TextAlignment
    let lineSpacing: CGFloat
    let textSpacing: CGFloat
    let textShadowColor: Color
    let textShadowRadius: CGFloat
    let innerPadding: CGFloat
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    private var maxLines: Int {
        let availableHeight = (200 * scale) - (innerPadding * 2 * scale)
        let lineHeight = (fontSize + lineSpacing) * scale
        return max(1, Int(floor(availableHeight / lineHeight)))
    }
    
    var body: some View {
        VStack {
            if isEditing {
                TextField("点击输入内容", text: Binding(
                    get: { content },
                    set: { newValue in
                        let lines = newValue.components(separatedBy: .newlines)
                        if lines.count <= maxLines {
                            content = newValue
                        }
                    }
                ), axis: .vertical)
                    .font(.custom(selectedFont, size: fontSize * scale))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(textAlignment)
                    .lineSpacing(lineSpacing * scale)
                    .tracking(textSpacing * scale)
                    .shadow(color: textShadowColor.opacity(textShadowRadius > 0 ? 0.6 : 0),
                            radius: textShadowRadius * scale)
                    .frame(maxWidth: .infinity, alignment: textAlignment == .leading ? .leading :
                            textAlignment == .trailing ? .trailing : .center)
                    .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
            } else {
                Text(content.isEmpty ? "点击输入内容" : content)
                    .font(.custom(selectedFont, size: fontSize * scale))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(textAlignment)
                    .lineSpacing(lineSpacing * scale)
                    .tracking(textSpacing * scale)
                    .shadow(color: textShadowColor.opacity(textShadowRadius > 0 ? 0.6 : 0),
                            radius: textShadowRadius * scale)
                    .frame(maxWidth: .infinity, alignment: textAlignment == .leading ? .leading :
                            textAlignment == .trailing ? .trailing : .center)
            }
        }
        .padding(innerPadding * scale)
        .clipped()
        .onTapGesture {
            isEditing = true
        }
    }
}

// MARK: - 水印模块
private struct BaseWatermarkModule: View {
    let scale: CGFloat
    @Binding var watermarkText: String
    let watermarkColor: Color
    let watermarkOpacity: Double
    let watermarkPosition: WatermarkPosition
    let watermarkSize: CGFloat
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Group {
            if isEditing {
                TextField("输入水印", text: $watermarkText)
                    .font(.system(size: watermarkSize * scale))
                    .foregroundColor(watermarkColor)
                    .opacity(watermarkOpacity)
                    .multilineTextAlignment(textAlignment)
                    .lineLimit(1)
                    .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
            } else {
                Text(watermarkText.isEmpty ? "输入水印" : watermarkText)
                    .font(.system(size: watermarkSize * scale))
                    .foregroundColor(watermarkColor)
                    .opacity(watermarkOpacity)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: alignment)
        .padding(.horizontal, 16 * scale)
        .padding(.vertical, 8 * scale)
        .onTapGesture {
            isEditing = true
        }
    }
    
    private var textAlignment: TextAlignment {
        switch watermarkPosition {
        case .topLeft, .bottomLeft:
            return .leading
        case .center, .bottomCenter:
            return .center
        case .topRight, .bottomRight:
            return .trailing
        }
    }
    
    private var alignment: Alignment {
        switch watermarkPosition {
        case .topLeft, .bottomLeft:
            return .leading
        case .center, .bottomCenter:
            return .center
        case .topRight, .bottomRight:
            return .trailing
        }
    }
}
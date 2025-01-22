import SwiftUI

struct BaseCardToolPanel: View {
    @ObservedObject var viewModel: CardEditorViewModel
    @State private var selectedTool: ToolType = .theme
    @State private var isSettingPresented = false
    @FocusState private var isTextFieldFocused: Bool
    @Namespace private var animation
    
    enum ToolType: String, CaseIterable {
        case theme = "主题"
        case text = "文字"
        case color = "配色"
        case layout = "布局"
        case watermark = "水印"
        
        var icon: String {
            switch self {
            case .theme: return "paintbrush"
            case .text: return "character"
            case .color: return "paintpalette"
            case .layout: return "square.grid.2x2"
            case .watermark: return "signature"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 工具选项卡
            HStack {
                ForEach(ToolType.allCases, id: \.self) { tool in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if selectedTool == tool {
                                isSettingPresented.toggle()
                            } else {
                                selectedTool = tool
                                isSettingPresented = true
                            }
                        }
                    } label: {
                        VStack {
                            Image(systemName: tool.icon)
                                .font(.system(size: 16))
                            Text(tool.rawValue)
                                .font(.system(size: 12))
                        }
                        .foregroundColor(selectedTool == tool ? .accentColor : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            ZStack {
                                if selectedTool == tool {
                                    Rectangle()
                                        .fill(Color.accentColor)
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: "activeTab", in: animation)
                                        .frame(maxHeight: .infinity, alignment: .bottom)
                                }
                            }
                        )
                    }
                }
            }
            .padding(.bottom, 8)
            
            // 设置内容
            if isSettingPresented {
                VStack {
                    ScrollView {
                        VStack(spacing: 16) {
                            Group {
                                switch selectedTool {
                                case .theme: ThemeSettings(viewModel: viewModel)
                                case .text: TextSettings(viewModel: viewModel)
                                case .color: ColorSettings(viewModel: viewModel)
                                case .layout: LayoutSettings(viewModel: viewModel)
                                case .watermark: WatermarkSettings(viewModel: viewModel)
                                }
                            }
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                )
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .animation(.easeInOut(duration: 0.2), value: selectedTool)
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.25)
                }
                .background(Color(.systemGroupedBackground))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSettingPresented)
        .background(Color(.systemBackground))
    }
}

// MARK: - 设置项样式
extension View {
    func settingItemStyle() -> some View {
        self
            .padding(12)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(8)
    }
}

// MARK: - 字设置
struct TextSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 字体选择
            VStack(alignment: .leading, spacing: 8) {
                Text("字体")
                    .foregroundColor(.secondary)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.fontPresets, id: \.self) { font in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    $viewModel.baseCard.selectedFont.wrappedValue = font
                                }
                            } label: {
                                Text(viewModel.fontNames[font] ?? font)
                                    .font(.custom(font, size: 16))
                                    .foregroundColor(font == viewModel.baseCard.selectedFont ? .accentColor : .primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(font == viewModel.baseCard.selectedFont ? Color.accentColor : Color.clear)
                                    )
                            }
                        }
                    }
                }
            }
            .settingItemStyle()
            
            // 字号设置
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("字号")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.baseCard.fontSize))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.baseCard.fontSize, in: 12...48, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
           
            
            // 对齐方式
            VStack(alignment: .leading, spacing: 8) {
                Text("对齐方式")
                    .foregroundColor(.secondary)
                Picker("", selection: $viewModel.baseCard.textAlignment) {
                    Image(systemName: "text.alignleft").tag(TextAlignment.leading)
                    Image(systemName: "text.aligncenter").tag(TextAlignment.center)
                    Image(systemName: "text.alignright").tag(TextAlignment.trailing)
                }
                .pickerStyle(.segmented)
            }
            .settingItemStyle()
            
            // 行间距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("行间距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "%.1f", viewModel.baseCard.lineSpacing))
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.baseCard.lineSpacing, in: 1...40, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 字间距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("字间距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "%.1f", viewModel.baseCard.textSpacing))
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.baseCard.textSpacing, in: 0...40, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            
        }
    }
}

// MARK: - 配色设置
struct ColorSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 渐变开关
            Toggle("使用渐变", isOn: $viewModel.baseCard.useGradient)
                .settingItemStyle()
            
            if viewModel.baseCard.useGradient {
                // 渐变色
                VStack(alignment: .leading, spacing: 8) {
                    Text("渐变色")
                        .foregroundColor(.secondary)
                    HStack {
                        if !viewModel.baseCard.gradientColors.isEmpty {
                            Button(action: {
                                $viewModel.baseCard.gradientColors.wrappedValue.removeLast()
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.red)
                            }
                        }
                        Spacer()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach($viewModel.baseCard.gradientColors.indices, id: \.self) { index in
                                    ColorPicker("", selection: $viewModel.baseCard.gradientColors[index])
                                        .labelsHidden()
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.secondary, lineWidth: 1)
                                        )
                                }
                            }
                        }
                        Button(action: {
                            $viewModel.baseCard.gradientColors.wrappedValue.append(.white)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.accentColor)
                        }
                    }
                     VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("渐变角度")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(viewModel.baseCard.gradientAngle))°")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $viewModel.baseCard.gradientAngle, in: 0...360, step: 1)
                        .tint(.accentColor)
                }
                }
                .settingItemStyle()
                
            } else {
                // 背景色
                ColorPicker("背景色", selection: $viewModel.baseCard.backgroundColor)
                    .settingItemStyle()
            }

             // 文字颜色
            ColorPicker("文字颜色", selection: $viewModel.baseCard.textColor)
                .settingItemStyle()

            // 文字阴影
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("文字阴影")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.baseCard.textShadowRadius))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.baseCard.textShadowRadius, in: 0...10, step: 1)
                    .tint(.accentColor)
                
                ColorPicker("阴影颜色", selection: $viewModel.baseCard.textShadowColor)
            }
            .settingItemStyle()
            
            // 卡片背景色
            ColorPicker("卡片背景色", selection: $viewModel.baseCard.cardBackgroundColor)
                .settingItemStyle()
            
            
        }
    }
}

// MARK: - 布局设置
struct LayoutSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 窗口控制按钮
            Toggle("显示窗口按钮", isOn: $viewModel.baseCard.showWindowControls)
                .settingItemStyle()

            // 卡片透明度
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("卡片透明度")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "%.1f", viewModel.baseCard.cardOpacity))
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.baseCard.cardOpacity, in: 0...1, step: 0.1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 圆角
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("圆角")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.baseCard.cornerRadius))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.baseCard.cornerRadius, in: 0...32, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 外边距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("外边距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.baseCard.edgePadding))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.baseCard.edgePadding, in: 0...32, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 内边距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("内边距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.baseCard.innerPadding))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.baseCard.innerPadding, in: 0...32, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
        }
    }
}

// MARK: - 水印设置
struct WatermarkSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 水印开关
            Toggle("显示水印", isOn: $viewModel.baseCard.showWatermark)
                .settingItemStyle()
            
            if viewModel.baseCard.showWatermark {
                // 水印颜色
                ColorPicker("水印颜色", selection: $viewModel.baseCard.watermarkColor)
                    .settingItemStyle()
                
                // 透明度
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("透明度")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.1f", viewModel.baseCard.watermarkOpacity))
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $viewModel.baseCard.watermarkOpacity, in: 0...1, step: 0.1)
                        .tint(.accentColor)
                }
                .settingItemStyle()
                
                // 大小
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("水印大小")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(viewModel.baseCard.watermarkSize))")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $viewModel.baseCard.watermarkSize, in: 8...24, step: 1)
                        .tint(.accentColor)
                }
                .settingItemStyle()
                
                // 位置
                VStack(alignment: .leading, spacing: 8) {
                    Text("水印位置")
                        .foregroundColor(.secondary)
                    Picker("", selection: $viewModel.baseCard.watermarkPosition) {
                        Text("左下").tag(WatermarkPosition.bottomLeft)
                        Text("中下").tag(WatermarkPosition.bottomCenter)
                        Text("右下").tag(WatermarkPosition.bottomRight)
                    }
                    .pickerStyle(.segmented)
                }
                .settingItemStyle()
            }
        }
    }
}

// MARK: - 主题设置
struct ThemeSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(BaseCardStyle.presets) { style in
                    Button {
                        withAnimation {
                            $viewModel.baseCard.useGradient.wrappedValue = style.useGradient
                            $viewModel.baseCard.gradientColors.wrappedValue = style.gradientColors
                            $viewModel.baseCard.gradientAngle.wrappedValue = style.gradientAngle
                            $viewModel.baseCard.backgroundColor.wrappedValue = style.backgroundColor
                            $viewModel.baseCard.cardBackgroundColor.wrappedValue = style.cardBackgroundColor
                            $viewModel.baseCard.cardOpacity.wrappedValue = style.cardOpacity
                            $viewModel.baseCard.cornerRadius.wrappedValue = style.cornerRadius
                            $viewModel.baseCard.selectedFont.wrappedValue = style.selectedFont
                            $viewModel.baseCard.fontSize.wrappedValue = style.fontSize
                            $viewModel.baseCard.textColor.wrappedValue = style.textColor
                            $viewModel.baseCard.textAlignment.wrappedValue = style.textAlignment
                            $viewModel.baseCard.lineSpacing.wrappedValue = style.lineSpacing
                            $viewModel.baseCard.textSpacing.wrappedValue = style.textSpacing
                            $viewModel.baseCard.textShadowRadius.wrappedValue = style.textShadowRadius
                            $viewModel.baseCard.textShadowColor.wrappedValue = style.textShadowColor
                            $viewModel.baseCard.showWatermark.wrappedValue = style.showWatermark
                            // $viewModel.baseCard.watermarkText.wrappedValue = style.watermarkText
                            $viewModel.baseCard.watermarkOpacity.wrappedValue = style.watermarkOpacity
                            $viewModel.baseCard.watermarkSize.wrappedValue = style.watermarkSize
                            $viewModel.baseCard.watermarkColor.wrappedValue = style.watermarkColor
                            $viewModel.baseCard.watermarkPosition.wrappedValue = style.watermarkPosition
                            $viewModel.baseCard.showWindowControls.wrappedValue = style.showWindowControls
                            $viewModel.baseCard.edgePadding.wrappedValue = style.edgePadding
                            $viewModel.baseCard.innerPadding.wrappedValue = style.innerPadding
                        }
                    } label: {
                        VStack(spacing: 6) {
                            // 预览卡片
                            ZStack {
                                if style.useGradient {
                                    LinearGradient(
                                        colors: style.gradientColors,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                } else {
                                    style.backgroundColor
                                }
                                
                                RoundedRectangle(cornerRadius: style.cornerRadius)
                                    .fill(style.cardBackgroundColor)
                                    .opacity(style.cardOpacity)
                                    .padding(6)
                                
                                Text(style.name)
                                    .font(.custom(style.selectedFont, size: 14))
                                    .foregroundColor(style.textColor)
                                    .shadow(color: style.textShadowColor, radius: style.textShadowRadius)
                            }
                            .frame(height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 0.5)
                            )
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
        }
        .settingItemStyle()
    }
}
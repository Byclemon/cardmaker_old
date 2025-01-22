import SwiftUI

struct MovieCardToolPanel: View {
    @ObservedObject var viewModel: CardEditorViewModel
    @State private var selectedTool: ToolType = .theme
    @State private var isSettingPresented = false
    @Namespace private var animation
    
    enum ToolType: String, CaseIterable {
        case theme = "主题"
        case content = "内容"
        case color = "配色"
        case layout = "布局"
        case module = "模块"
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
                            Image(systemName: toolIcon(for: tool))
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
            
            if isSettingPresented {
                VStack {
                    ScrollView {
                        VStack(spacing: 16) {
                            Group {
                                switch selectedTool {
                                case .theme:  MovieThemeSettings(viewModel: viewModel)
                                case .content: MovieContentSettings(viewModel: viewModel)
                                case .color: MovieColorSettings(viewModel: viewModel)
                                case .layout: MovieLayoutSettings(viewModel: viewModel)
                                case .module: MovieModuleSettings(viewModel: viewModel)
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
    
    private func toolIcon(for tool: ToolType) -> String {
        switch tool {
        case .theme: return "paintpalette"
        case .content: return "character"
        case .color: return "paintpalette"
        case .layout: return "square.grid.2x2"
        case .module: return "square.stack"
        }
    }
}

// MARK: - 模块设置
struct MovieModuleSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 水印设置
            VStack(alignment: .leading, spacing: 8) {
                Toggle("显示水印", isOn: $viewModel.movieCard.showWatermark)
                
                if viewModel.movieCard.showWatermark {
                    // 水印文本
                    TextField("水印文本", text: $viewModel.movieCard.watermarkText)
                        .textFieldStyle(.roundedBorder)
                    
                    // 水印透明度
                    VStack(alignment: .leading) {
                        HStack {
                            Text("透明度")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(String(format: "%.1f", viewModel.movieCard.watermarkOpacity))
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $viewModel.movieCard.watermarkOpacity, in: 0...1, step: 0.1)
                            .tint(.accentColor)
                    }
                    
                    // 水印大小
                    VStack(alignment: .leading) {
                        HStack {
                            Text("大小")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(Int(viewModel.movieCard.watermarkSize))")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $viewModel.movieCard.watermarkSize, in: 8...24, step: 1)
                            .tint(.accentColor)
                    }
                }
            }
            .settingItemStyle()
        }
    }
}

// MARK: - 内容设置
struct MovieContentSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题设置
            VStack(alignment: .leading, spacing: 8) {
                Text("标题设置")
                    .foregroundColor(.secondary)
                
                // 标题字体选择
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.fontPresets, id: \.self) { font in
                            Button {
                                $viewModel.movieCard.titleFont.wrappedValue = font
                            } label: {
                                Text(viewModel.fontNames[font] ?? font)
                                    .font(.custom(font, size: 16))
                                    .foregroundColor(font == viewModel.movieCard.titleFont ? .accentColor : .primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(font == viewModel.movieCard.titleFont ? Color(.systemGray6) : Color.clear)
                                    )
                            }
                        }
                    }
                }
                
                // 标题字号
                VStack(alignment: .leading) {
                    HStack {
                        Text("字号")
                        Spacer()
                        Text("\(Int(viewModel.movieCard.titleFontSize))")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $viewModel.movieCard.titleFontSize, in: 10...36, step: 1)
                        .tint(.accentColor)
                }
            }
            .settingItemStyle()
            
            // 内容设置
            VStack(alignment: .leading, spacing: 8) {
                Text("内容设置")
                    .foregroundColor(.secondary)
                
                // 内容字体选择
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.fontPresets, id: \.self) { font in
                            Button {
                                $viewModel.movieCard.contentFont.wrappedValue = font
                            } label: {
                                Text(viewModel.fontNames[font] ?? font)
                                    .font(.custom(font, size: 16))
                                    .foregroundColor(font == viewModel.movieCard.contentFont ? .accentColor : .primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(font == viewModel.movieCard.contentFont ? Color(.systemGray6) : Color.clear)
                                    )
                            }
                        }
                    }
                }
                
                // 内容字号
                VStack(alignment: .leading) {
                    HStack {
                        Text("字号")
                        Spacer()
                        Text("\(Int(viewModel.movieCard.contentFontSize))")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $viewModel.movieCard.contentFontSize, in: 8...24, step: 1)
                        .tint(.accentColor)
                }
            }
            .settingItemStyle()
        }
    }
}

// MARK: - 颜色设置
struct MovieColorSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 文字颜色设置组
            VStack(alignment: .leading, spacing: 12) {
                Text("文字颜色")
                    .foregroundColor(.secondary)
                    .font(.system(size: 13))
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ColorItemView(title: "标题", color: $viewModel.movieCard.titleColor)
                    ColorItemView(title: "副标题", color: $viewModel.movieCard.textColor)
                    ColorItemView(title: "内容", color: $viewModel.movieCard.textColor)
                    ColorItemView(title: "日期", color: $viewModel.movieCard.dateColor)
                    ColorItemView(title: "分类", color: $viewModel.movieCard.awardTextColor)
                    ColorItemView(title: "水印", color: $viewModel.movieCard.watermarkColor)
                }
            }
            .settingItemStyle()
            
            // 背景色设置组
            VStack(alignment: .leading, spacing: 12) {
                Text("背景设置")
                    .foregroundColor(.secondary)
                    .font(.system(size: 13))
                
                Toggle("使用渐变", isOn: $viewModel.movieCard.useGradient)
                
                if viewModel.movieCard.useGradient {
                    Divider()
                    
                    // 渐变色设置
                    VStack(alignment: .leading, spacing: 8) {
                        Text("渐变色")
                            .foregroundColor(.secondary)
                            .font(.system(size: 13))
                        
                        HStack(spacing: 16) {
                            if !viewModel.movieCard.gradientColors.isEmpty {
                                Button {
                                    $viewModel.movieCard.gradientColors.wrappedValue.removeLast()
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.red)
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.movieCard.gradientColors.indices, id: \.self) { index in
                                        ColorPicker("", selection: $viewModel.movieCard.gradientColors[index])
                                            .labelsHidden()
                                    }
                                }
                            }
                            
                            Button {
                                $viewModel.movieCard.gradientColors.wrappedValue.append(.white)
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.accentColor)
                            }
                        }
                        
                        // 渐变角度
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("渐变角度")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 13))
                                Spacer()
                                Text("\(Int(viewModel.movieCard.gradientAngle))°")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 13))
                            }
                            Slider(value: $viewModel.movieCard.gradientAngle, in: 0...360, step: 1)
                                .tint(.accentColor)
                        }
                    }
                } else {
                    ColorPicker("背景色", selection: $viewModel.movieCard.backgroundColor)
                }
                
                ColorPicker("卡片背景", selection: $viewModel.movieCard.cardBackgroundColor)
                
                // 模糊度
                VStack(alignment: .leading) {
                    HStack {
                        Text("模糊度")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(viewModel.movieCard.blurRadius))")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $viewModel.movieCard.blurRadius, in: 0...20, step: 1)
                        .tint(.accentColor)
                }
                
                // 暗化程度
                VStack(alignment: .leading) {
                    HStack {
                        Text("暗化程度")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.1f", viewModel.movieCard.darkenAmount))
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $viewModel.movieCard.darkenAmount, in: 0...1, step: 0.1)
                        .tint(.accentColor)
                }
            }
            .settingItemStyle()
        }
    }
}

// MARK: - 主题设置
struct MovieThemeSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(MovieCardStyle.presets) { style in
                    Button {
                        withAnimation {
                            style.apply(to: viewModel.movieCard)
                        }
                    } label: {
                        VStack(spacing: 12) {
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
                            }
                            .frame(height: 60)
                            .cornerRadius(8)
                            
                            Text(style.name)
                                .font(.system(size: 12))
                                .foregroundColor(.primary)
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
    
    private func isSelected(_ style: MovieCardStyle) -> Bool {
        viewModel.movieCard.useGradient == style.useGradient &&
        viewModel.movieCard.gradientColors == style.gradientColors &&
        viewModel.movieCard.gradientAngle == style.gradientAngle &&
        viewModel.movieCard.backgroundColor == style.backgroundColor &&
        viewModel.movieCard.cardBackgroundColor == style.cardBackgroundColor &&
        viewModel.movieCard.contentCardOpacity == style.cardOpacity &&
        viewModel.movieCard.cornerRadius == style.cornerRadius &&
        viewModel.movieCard.blurRadius == style.blurRadius &&
        viewModel.movieCard.darkenAmount == style.darkenAmount &&
        viewModel.movieCard.titleColor == style.titleColor &&
        viewModel.movieCard.textColor == style.textColor &&
        viewModel.movieCard.dateColor == style.dateColor &&
        viewModel.movieCard.awardTextColor == style.awardTextColor &&
        viewModel.movieCard.watermarkColor == style.watermarkColor
    }
}

// MARK: - 布局设置
struct MovieLayoutSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 卡片透明度
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("卡片透明度")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "%.1f", viewModel.movieCard.contentCardOpacity))
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.movieCard.contentCardOpacity, in: 0...1, step: 0.1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 圆角
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("圆角")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.movieCard.cornerRadius))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.movieCard.cornerRadius, in: 0...50, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 行间距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("行间距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.movieCard.lineSpacing))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.movieCard.lineSpacing, in: 0...32, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 内容边距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("内容边距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.movieCard.contentCardPadding))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.movieCard.contentCardPadding, in: 0...50, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 水平边距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("水平边距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.movieCard.horizontalPadding))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.movieCard.horizontalPadding, in: 0...50, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 底部边距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("底部边距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.movieCard.bottomPadding))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.movieCard.bottomPadding, in: 0...60, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
        }
    }
}

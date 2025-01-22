import SwiftUI

struct ArticleCardToolPanel: View {
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
                                case .theme: ArticleThemeSettings(viewModel: viewModel)
                                case .content: ArticleContentSettings(viewModel: viewModel)
                                case .color: ArticleColorSettings(viewModel: viewModel)
                                case .layout: ArticleLayoutSettings(viewModel: viewModel)
                                case .module: ArticleModuleSettings(viewModel: viewModel)
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



// MARK: - 配色设置
struct ArticleColorSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 渐变设置组
            VStack(alignment: .leading, spacing: 12) {
                Toggle("使用渐变", isOn: $viewModel.articleCard.useGradient)
                
                if viewModel.articleCard.useGradient {
                    Divider()
                    
                    // 渐变色设置
                    VStack(alignment: .leading, spacing: 8) {
                        Text("渐变色")
                            .foregroundColor(.secondary)
                            .font(.system(size: 13))
                        
                        HStack(spacing: 16) {
                            if !viewModel.articleCard.gradientColors.isEmpty {
                                Button {
                                    $viewModel.articleCard.gradientColors.wrappedValue.removeLast()
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.red)
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.articleCard.gradientColors.indices, id: \.self) { index in
                                        ColorPicker("", selection: $viewModel.articleCard.gradientColors[index])
                                            .labelsHidden()
                                    }
                                }
                            }
                            
                            Button {
                                $viewModel.articleCard.gradientColors.wrappedValue.append(.white)
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
                                Text("\(Int(viewModel.articleCard.gradientAngle))°")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 13))
                            }
                            Slider(value: $viewModel.articleCard.gradientAngle, in: 0...360, step: 1)
                                .tint(.accentColor)
                        }
                    }
                }
            }
            .settingItemStyle()
            
            // 背景色设置组
            VStack(alignment: .leading, spacing: 12) {
                Text("背景设置")
                    .foregroundColor(.secondary)
                    .font(.system(size: 13))
                
                if !viewModel.articleCard.useGradient {
                    ColorPicker("背景色", selection: $viewModel.articleCard.backgroundColor)
                }
                ColorPicker("卡片背景", selection: $viewModel.articleCard.cardBackgroundColor)
                ColorPicker("模块背景", selection: $viewModel.articleCard.moduleBackgroundColor)
            }
            .settingItemStyle()
            
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
                    // 标题颜色
                    ColorItemView(title: "标题", color: $viewModel.articleCard.titleColor)
                    
                    // 内容颜色
                    ColorItemView(title: "内容", color: $viewModel.articleCard.contentColor)
                    
                    // 日期颜色
                    ColorItemView(title: "日期", color: $viewModel.articleCard.dataColor)
                    
                    // 作者颜色
                    ColorItemView(title: "作者", color: $viewModel.articleCard.authorColor)
                    
                    // 字数颜色
                    ColorItemView(title: "字数", color: $viewModel.articleCard.wordCountColor)
                    
                    // 二维码颜色
                    ColorItemView(title: "二维码", color: $viewModel.articleCard.qrCodeColor)
                }
            }
            .settingItemStyle()
            
            // 水印设置组
            VStack(alignment: .leading, spacing: 8) {
                Text("水印设置")
                    .foregroundColor(.secondary)
                    .font(.system(size: 13))
                
                ColorPicker("水印颜色", selection: $viewModel.articleCard.watermarkColor)
                
                HStack {
                    Text("不透明度")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "%.1f", viewModel.articleCard.watermarkOpacity))
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.articleCard.watermarkOpacity, in: 0...1, step: 0.1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
        }
    }
}

// 辅助视图
struct ColorItemView: View {
    let title: String
    @Binding var color: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ColorPicker("", selection: $color)
                .labelsHidden()
            Text(title)
                .foregroundColor(.secondary)
                .font(.system(size: 13))
        }
        .frame(height: 70)
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(8)
    }
}

// MARK: - 布局设置
struct ArticleLayoutSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("模块高度")
                    .foregroundColor(.secondary)
                
                HStack {
                    Slider(value: $viewModel.articleCard.moduleHeight, in: 32...64, step: 2)
                        .frame(maxWidth: .infinity)
                    
                    Text("\(Int(viewModel.articleCard.moduleHeight))")
                        .foregroundColor(.secondary)
                        .frame(width: 30)
                }
            }
            .settingItemStyle()
            // 卡片透明度
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("卡片透明度")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "%.1f", viewModel.articleCard.cardOpacity))
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.articleCard.cardOpacity, in: 0...1, step: 0.1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 圆角
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("圆角")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.articleCard.cornerRadius))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.articleCard.cornerRadius, in: 0...32, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 外边距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("外边距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.articleCard.edgePadding))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.articleCard.edgePadding, in: 0...32, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 内边距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("内边距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.articleCard.innerPadding))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.articleCard.innerPadding, in: 0...32, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
        }
    }
}

// MARK: - 模块设置
struct ArticleModuleSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    private let modules: [(String, String, WritableKeyPath<ArticleCardViewModel, Bool>)] = [
        ("doc.fill", "图标", \.showIcon),
        ("calendar.circle.fill", "日期", \.showDate),
        ("text.bubble.fill", "标题", \.showTitle),
        ("doc.text.fill", "内容", \.showContent),
        ("person.circle.fill", "作者", \.showAuthor),
        ("number.circle.fill", "字数", \.showWordCount),
        ("qrcode.viewfinder", "二维码", \.showQRCode),
        ("signature", "水印", \.showWatermark)
    ]
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 25) {
            ForEach(modules, id: \.1) { icon, title, keyPath in
                let binding = Binding(
                    get: { viewModel.articleCard[keyPath: keyPath] },
                    set: { newValue in
                        withAnimation {
                            viewModel.articleCard[keyPath: keyPath] = newValue
                        }
                    }
                )
                
                Button {
                    withAnimation {
                        binding.wrappedValue.toggle()
                    }
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(binding.wrappedValue ? .primary : .secondary.opacity(0.3))
                        Text(title)
                            .font(.system(size: 12))
                            .foregroundColor(binding.wrappedValue ? .primary : .secondary.opacity(0.3))
                    }
                    .frame(height: 70)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(binding.wrappedValue ? 
                                 Color(.systemGray5) : 
                                 Color(.systemGray6))
                    )
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - 主题设置
struct ArticleThemeSettings: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(ArticleCardStyle.presets) { style in
                    Button {
                        withAnimation {
                            style.apply(to: viewModel.articleCard)
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
                                
                                VStack(spacing: 8) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(style.moduleBackgroundColor)
                                        .frame(height: 20)
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(style.moduleBackgroundColor)
                                        .frame(height: 40)
                                }
                                .padding(8)
                            }
                            .frame(width: 90, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 0.5)
                            )
                            
                            Text(style.name)
                                .font(.system(size: 14))
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
}



// MARK: - 内容设置
struct ArticleContentSettings: View {
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
                                $viewModel.articleCard.titleFont.wrappedValue = font
                            } label: {
                                Text(viewModel.fontNames[font] ?? font)
                                    .font(.custom(font, size: 16))
                                    .foregroundColor(font == viewModel.articleCard.titleFont ? .accentColor : .primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(font == viewModel.articleCard.titleFont ? 
                                                 Color(.systemGray6) : Color.clear)
                                    )
                            }
                        }
                    }
                }
                
                // 标题字号
                VStack(alignment: .leading) {
                    HStack {
                        Text("字号")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(viewModel.articleCard.titleSize))")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $viewModel.articleCard.titleSize, in: 16...36, step: 1)
                        .tint(.accentColor)
                }
                
                // 标题颜色
                ColorPicker("颜色", selection: $viewModel.articleCard.titleColor)
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
                                $viewModel.articleCard.contentFont.wrappedValue = font
                            } label: {
                                Text(viewModel.fontNames[font] ?? font)
                                    .font(.custom(font, size: 16))
                                    .foregroundColor(font == viewModel.articleCard.contentFont ? .accentColor : .primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(font == viewModel.articleCard.contentFont ? 
                                                 Color(.systemGray6) : Color.clear)
                                    )
                            }
                        }
                    }
                }
                
                // 内容字号
                VStack(alignment: .leading) {
                    HStack {
                        Text("字号")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(viewModel.articleCard.contentSize))")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $viewModel.articleCard.contentSize, in: 12...24, step: 1)
                        .tint(.accentColor)
                }
                
                // 内容颜色
                ColorPicker("颜色", selection: $viewModel.articleCard.contentColor)
            }
            .settingItemStyle()
        }
    }
}
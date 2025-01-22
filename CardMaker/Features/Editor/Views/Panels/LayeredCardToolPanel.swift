import SwiftUI

struct LayeredCardToolPanel: View {
    @ObservedObject var viewModel: CardEditorViewModel
    @State private var selectedTool: ToolType = .layer
    @State private var isSettingPresented = false
    @Namespace private var animation
    
    enum ToolType: String, CaseIterable {
        case theme = "主题"
        case layer = "层叠"
        case text = "文本"
        case color = "配色"
        case layout = "布局"
        
        var icon: String {
            switch self {
            case .theme: return "paintpalette.fill"
            case .layer: return "square.3.stack.3d"
            case .text: return "character"
            case .color: return "paintpalette"
            case .layout: return "square.grid.2x2"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 工具栏
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
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
                            VStack(spacing: 4) {
                                Image(systemName: tool.icon)
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedTool == tool ? .accentColor : .primary)
                                    .frame(height: 24)
                                    .matchedGeometryEffect(id: tool.rawValue + "_icon", in: animation)
                                
                                Text(tool.rawValue)
                                    .font(.system(size: 12))
                                    .foregroundColor(selectedTool == tool ? .accentColor : .primary)
                                    .matchedGeometryEffect(id: tool.rawValue + "_text", in: animation)
                            }
                            .frame(width: 44)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(Color(UIColor.systemBackground))
            
            
            if isSettingPresented {
                ScrollView {
                    VStack(spacing: 20) {
                        Group {
                            switch selectedTool {
                            case .theme:
                                LayeredThemeSettingsView(viewModel: viewModel)
                            case .layer:
                                LayeredLayerSettingsView(viewModel: viewModel)
                            case .text:
                                LayeredTextSettingsView(viewModel: viewModel)
                            case .color:
                                LayeredColorSettingsView(viewModel: viewModel)
                            case .layout:
                                LayeredLayoutSettingsView(viewModel: viewModel)
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    }
                    .padding(16)
                }
                .frame(height: UIScreen.main.bounds.height * 0.25)
                .background(Color(.systemGroupedBackground))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSettingPresented)
        .background(Color(.systemBackground))
    }
}

// MARK: - 层叠设置
private struct LayeredLayerSettingsView: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(0..<3) { index in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("层 \(index + 1)")
                            .font(.headline)
                        Spacer()
                        if index > 0 {
                            Toggle("", isOn: $viewModel.layeredCard.layerVisibility[index])
                        }
                    }
                    
                    if index == 0 || viewModel.layeredCard.layerVisibility[index] {
                        // 颜色选择
                        ColorItemView(
                            title: "颜色",
                            color: $viewModel.layeredCard.layerColors[index]
                        )
                        
                        // 缩放控制
                        HStack {
                            Text("缩放")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(String(format: "%.2f", viewModel.layeredCard.layerScales[index]))
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $viewModel.layeredCard.layerScales[index], in: 0.5...1, step: 0.01)
                            .tint(.accentColor)
                        
                        // 偏移控制
                        HStack {
                            Text("偏移")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(Int(viewModel.layeredCard.layerOffsets[index]))")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $viewModel.layeredCard.layerOffsets[index], in: -40...40, step: 1)
                            .tint(.accentColor)
                        
                        // 旋转控制
                        HStack {
                            Text("旋转")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(Int(viewModel.layeredCard.layerRotations[index]))°")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $viewModel.layeredCard.layerRotations[index], in: -15...15, step: 1)
                            .tint(.accentColor)
                    }
                }
                .settingItemStyle()
            }
        }
    }
}

// MARK: - 文本设置
private struct LayeredTextSettingsView: View {
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
                                    $viewModel.layeredCard.selectedFont.wrappedValue = font
                                }
                            } label: {
                                Text(viewModel.fontNames[font] ?? font)
                                    .font(.custom(font, size: 16))
                                    .foregroundColor(font == viewModel.layeredCard.selectedFont ? .accentColor : .primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(font == viewModel.layeredCard.selectedFont ? 
                                                 Color(.systemGray6) : Color.clear)
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
                    Text("\(Int(viewModel.layeredCard.fontSize))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.layeredCard.fontSize, in: 12...32, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 行间距
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("行间距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.layeredCard.lineSpacing))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.layeredCard.lineSpacing, in: 0...20, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            // 对齐方式
            VStack(alignment: .leading, spacing: 8) {
                Text("对齐方式")
                    .foregroundColor(.secondary)
                
                Picker("", selection: $viewModel.layeredCard.textAlignment) {
                    Image(systemName: "text.alignleft").tag(TextAlignment.leading)
                    Image(systemName: "text.aligncenter").tag(TextAlignment.center)
                    Image(systemName: "text.alignright").tag(TextAlignment.trailing)
                }
                .pickerStyle(.segmented)
            }
            .settingItemStyle()
        }
    }
}

// MARK: - 配色设置
private struct LayeredColorSettingsView: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 渐变设置组
            VStack(alignment: .leading, spacing: 12) {
                Text("背景设置")
                    .foregroundColor(.secondary)
                    .font(.system(size: 13))
                
                Toggle("使用渐变", isOn: $viewModel.layeredCard.useGradient)
                
                if viewModel.layeredCard.useGradient {
                    // 渐变色选择
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ColorItemView(
                            title: "渐变色 1",
                            color: $viewModel.layeredCard.gradientColors[0]
                        )
                        ColorItemView(
                            title: "渐变色 2",
                            color: $viewModel.layeredCard.gradientColors[1]
                        )
                    }
                    
                    // 渐变角度
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("渐变角度")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(Int(viewModel.layeredCard.gradientAngle))°")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $viewModel.layeredCard.gradientAngle, in: 0...360, step: 1)
                            .tint(.accentColor)
                    }
                } else {
                    ColorPicker("背景色", selection: $viewModel.layeredCard.backgroundColor)
                }
            }
            .settingItemStyle()
            
            // 层叠颜色设置
            VStack(alignment: .leading, spacing: 8) {
                Text("层叠颜色")
                    .foregroundColor(.secondary)
                    .font(.system(size: 13))
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(0..<3) { index in
                        ColorItemView(
                            title: "层 \(index + 1)",
                            color: $viewModel.layeredCard.layerColors[index]
                        )
                    }
                }
            }
            .settingItemStyle()
            
            // 文字颜色
            ColorPicker("文字颜色", selection: $viewModel.layeredCard.textColor)
                .settingItemStyle()
        }
    }
}

// MARK: - 布局设置
private struct LayeredLayoutSettingsView: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 圆角设置
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("圆角")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.layeredCard.cornerRadius))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.layeredCard.cornerRadius, in: 0...40, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
            
            
            // 内边距设置
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("内边距")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(viewModel.layeredCard.innerPadding))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $viewModel.layeredCard.innerPadding, in: 0...40, step: 1)
                    .tint(.accentColor)
            }
            .settingItemStyle()
        }
    }
}


// MARK: - 主题设置
private struct LayeredThemeSettingsView: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(LayeredCardStyle.presets) { style in
                    Button {
                        withAnimation {
                            style.apply(to: viewModel.layeredCard)
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
                            .frame(height: 120)
                            .overlay {
                                // 层叠效果预览
                                ZStack {
                                    ForEach((0..<style.layerColors.count).reversed(), id: \.self) { index in
                                        if style.layerVisibility[index] {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(style.layerColors[index])
                                                .scaleEffect(style.layerScales[index])
                                                .offset(y: style.layerOffsets[index] * 0.5)
                                                .rotationEffect(.degrees(style.layerRotations[index]))
                                        }
                                    }
                                }
                                .padding(20)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Text(style.name)
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
#Preview {
    LayeredCardToolPanel(viewModel: CardEditorViewModel())
}
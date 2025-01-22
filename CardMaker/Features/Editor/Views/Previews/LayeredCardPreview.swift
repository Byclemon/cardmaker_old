import SwiftUI

struct LayeredCardPreview: View {
    let width: CGFloat
    let height: CGFloat
    let scale: CGFloat
    @ObservedObject var viewModel: LayeredCardViewModel
    @State private var isEditing = false
    @State private var showIconPicker = false
    
    var body: some View {
        ZStack {
            // 背景
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
            
            VStack {
                ZStack {
                    // 层叠背景 (从后往前渲染)
                    ForEach((0..<viewModel.layerColors.count).reversed(), id: \.self) { index in
                        if viewModel.layerVisibility[index] {
                            ZStack {
                                RoundedRectangle(cornerRadius: viewModel.cornerRadius * scale)
                                    .fill(viewModel.layerColors[index])
                                
                                // 只在第一层显示内容
                                if index == 0 {
                                    VStack(spacing: 0) {
                                        // 图标部分 - 固定边距
                                        HStack {
                                            Image(systemName: viewModel.icon)
                                                .font(.system(size: 28 * scale))
                                                .foregroundColor(.white.opacity(0.8))
                                                .symbolRenderingMode(.palette)  // 使用 palette 渲染模式
                                                .foregroundStyle(.white.opacity(0.8))  // 使用 foregroundStyle 替代 foregroundColor
                                                .onTapGesture {
                                                    showIconPicker = true
                                                }
                                            Spacer()
                                        }
                                        .padding(.horizontal, 16 * scale)
                                        .padding(.top, 16 * scale)
                                        .padding(.bottom, 12 * scale)
                                        
                                        // 内容部分 - 可调整内边距
                                        VStack {
                                            if isEditing {
                                                TextField("输入内容", text: $viewModel.content, axis: .vertical)
                                                    .font(.custom(viewModel.selectedFont, size: viewModel.fontSize * scale))
                                                    .foregroundColor(viewModel.textColor)
                                                    .multilineTextAlignment(viewModel.textAlignment)
                                                    .lineSpacing(viewModel.lineSpacing * scale)
                                                    .frame(maxWidth: .infinity, alignment: viewModel.textAlignment == .leading ? .leading :
                                                            viewModel.textAlignment == .trailing ? .trailing : .center)
                                                    .focused($isFocused)
                                                    .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
                                            } else {
                                                Text(viewModel.content.isEmpty ? "点击输入内容" : viewModel.content)
                                                    .font(.custom(viewModel.selectedFont, size: viewModel.fontSize * scale))
                                                    .foregroundColor(viewModel.textColor)
                                                    .multilineTextAlignment(viewModel.textAlignment)
                                                    .lineSpacing(viewModel.lineSpacing * scale)
                                                    .frame(maxWidth: .infinity, alignment: viewModel.textAlignment == .leading ? .leading :
                                                            viewModel.textAlignment == .trailing ? .trailing : .center)
                                                    .onTapGesture {
                                                        isEditing = true
                                                    }
                                            }
                                        }
                                        .padding(.horizontal, viewModel.innerPadding * scale)
                                        .padding(.vertical, viewModel.innerPadding * scale)
                                        
                                        Spacer()
                                        
                                        // 日期和字数 - 固定在底部，使用固定边距
                                        HStack {
                                            Text(Date(), style: .date)
                                                .font(.system(size: 13 * scale))
                                                .foregroundColor(.white.opacity(0.6))
                                            Spacer()
                                            Text("\(viewModel.content.count) 字")
                                                .font(.system(size: 13 * scale))
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        .padding(.horizontal, 16 * scale)
                                        .padding(.bottom, 16 * scale)
                                    }
                                }
                            }
                            .scaleEffect(viewModel.layerScales[index])
                            .offset(y: viewModel.layerOffsets[index] * scale)
                            .rotationEffect(.degrees(viewModel.layerRotations[index]), anchor: .bottomTrailing)
                        }
                    }
                }
                .frame(width: width, height: height)
            }
        }
        .frame(width: width, height: height)
        .sheet(isPresented: $showIconPicker) {
            IconPickerView(selectedIcon: $viewModel.icon)
             .presentationDetents([.medium])
        }
    }
    
    @FocusState private var isFocused: Bool
}


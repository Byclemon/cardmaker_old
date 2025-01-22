import SwiftUI
import PhotosUI

// MARK: - 标题模块
struct MovieTitleModule: View {
    let scale: CGFloat
    @Binding var title: String
    let titleFont: String
    let titleFontSize: CGFloat
    let titleColor: Color
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        if isEditing {
            TextField("输入标题", text: $title)
                .font(.custom(titleFont, size: titleFontSize * scale))
                .foregroundColor(titleColor)
                .lineLimit(1)  // 限制一行
                .focused($isFocused)
                .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
        } else {
            Text(title.isEmpty ? "输入标题" : title)
                .font(.custom(titleFont, size: titleFontSize * scale))
                .foregroundColor(titleColor)
                .lineLimit(1)  // 限制一行
                .onTapGesture {
                    isEditing = true
                    isFocused = true
                }
        }
    }
}

// MARK: - 副标题模块
struct MovieSubtitleModule: View {
    let scale: CGFloat
    @Binding var subtitle: String
    let contentFont: String
    let contentFontSize: CGFloat
    let textColor: Color
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8 * scale) {
            Image(systemName: "text.quote")
                .font(.system(size: contentFontSize * scale))
                .foregroundColor(textColor)
                .frame(width: contentFontSize * scale)
            
            if isEditing {
                TextField("输入副标题", text: $subtitle)
                    .font(.custom(contentFont, size: contentFontSize * scale))
                    .foregroundColor(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .focused($isFocused)
                    .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
            } else {
                Text(subtitle.isEmpty ? "输入副标题" : subtitle)
                    .font(.custom(contentFont, size: contentFontSize * scale))
                    .foregroundColor(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
        }
        .onTapGesture {
            isEditing = true
            isFocused = true
        }
    }
}

// MARK: - 内容模块
struct MovieContentModule: View {
    let scale: CGFloat
    @Binding var content: String
    let contentFont: String
    let contentFontSize: CGFloat
    let textColor: Color
    let lineSpacing: CGFloat
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        if isEditing {
            TextField("输入内容", text: $content, axis: .vertical)
                .font(.custom(contentFont, size: contentFontSize * scale))
                .foregroundColor(textColor)
                .lineSpacing(lineSpacing * scale)  // 在这里进行缩放
                .focused($isFocused)
                .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
        } else {
            Text(content.isEmpty ? "输入内容" : content)
                .font(.custom(contentFont, size: contentFontSize * scale))
                .foregroundColor(textColor)
                .lineSpacing(lineSpacing * scale)  // 在这里进行缩放
                .onTapGesture {
                    isEditing = true
                    isFocused = true
                }
        }
    }
}

// MARK: - 日期模块
struct MovieDateModule: View {
    let scale: CGFloat
    let date: Date
    let dateColor: Color
    let contentFont: String
    let contentFontSize: CGFloat
    @Binding var selectedFormat: DateFormat
    @State private var isEditing = false
    
    private let dateFormats: [DateFormat] = [
        .standard,
        .shortDate,
        .longDate,
        .withTime,
        .withWeekday
    ]
    
    var body: some View {
        Text(selectedFormat.format(date))
            .font(.custom(contentFont, size: contentFontSize * scale))
            .foregroundColor(dateColor)
            .lineLimit(1)
            .overlay(
                Rectangle()
                    .frame(height: 1 * scale)
                    .foregroundColor(dateColor)
                    .offset(y: 2 * scale),
                alignment: .bottom
            )
            .onTapGesture {
                isEditing = true
            }
            .sheet(isPresented: $isEditing) {
                NavigationView {
                    List {
                        ForEach(dateFormats, id: \.self) { format in
                            HStack {
                                Text(format.format(date))
                                Spacer()
                                if format == selectedFormat {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedFormat = format
                                isEditing = false
                            }
                        }
                    }
                    .navigationTitle("选择时间格式")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("完成") {
                                isEditing = false
                            }
                        }
                    }
                }
                .presentationDetents([.medium])
            }
    }
}

// MARK: - 奖项模块
struct MovieAwardModule: View {
    let scale: CGFloat
    @Binding var award: String
    @Binding var awardPrefix: String
    let awardFontSize: CGFloat
    let awardTextColor: Color
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        if isEditing {
            TextField("输入奖项", text: $award)
                .font(.system(size: awardFontSize * scale))
                .foregroundColor(awardTextColor)
                .frame(width: 160 * scale, alignment: .leading)
                .lineLimit(1)
                .focused($isFocused)
                .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
        } else {
            Text("\(awardPrefix)\(award)")
                .font(.system(size: awardFontSize * scale))
                .foregroundColor(awardTextColor)
                .frame(width: 160 * scale, alignment: .leading)
                .lineLimit(1)
                .onTapGesture {
                    isEditing = true
                    isFocused = true
                }
        }
    }
}

// MARK: - 水印模块
struct MovieWatermarkModule: View {
    let scale: CGFloat
    @Binding var watermarkText: String
    let watermarkSize: CGFloat
    let watermarkColor: Color
    let watermarkOpacity: CGFloat
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 0) {
        
            
            Group {
                if isEditing {
                    TextField("输入水印", text: $watermarkText)
                        .font(.system(size: watermarkSize * scale))
                        .foregroundColor(watermarkColor)
                        .opacity(watermarkOpacity)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                        .focused($isFocused)
                        .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
                } else {
                    Text(watermarkText.isEmpty ? "输入水印" : watermarkText)
                        .font(.system(size: watermarkSize * scale))
                        .foregroundColor(watermarkColor)
                        .opacity(watermarkOpacity)
                        .lineLimit(1)
                }
            }
            .frame(width: 100 * scale, alignment: .trailing)
        }
        .onTapGesture {
            isEditing = true
            isFocused = true
        }
    }
}

// MARK: - 背景视图
private struct MovieCardBackground: View {
    @ObservedObject var viewModel: MovieCardViewModel
    let width: CGFloat
    let height: CGFloat
    
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
        .frame(width: width, height: height)
    }
}

// MARK: - 主视图
struct MovieCardPreview: View {
    let width: CGFloat
    let height: CGFloat
    let scale: CGFloat
    @ObservedObject var viewModel: MovieCardViewModel
    @State private var showImagePicker = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景部分
                Group {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: height)
                            .blur(radius: viewModel.blurRadius)
                            .overlay(
                                Rectangle()
                                    .fill(.black.opacity(viewModel.darkenAmount))
                            )
                            .onTapGesture {
                                showImagePicker = true
                            }
                    } else {
                        // 如果没有图片，显示颜色背景
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
                        .onTapGesture {
                            showImagePicker = true
                        }
                    }
                }
                .frame(width: width, height: height)
                
                // 内容部分
                VStack {
                    // 顶部栏
                    HStack {
                        if viewModel.showAward {
                            MovieAwardModule(
                                scale: scale,
                                award: $viewModel.award,
                                awardPrefix: $viewModel.awardPrefix,
                                awardFontSize: viewModel.awardFontSize,
                                awardTextColor: viewModel.awardTextColor
                            )
                        }
                        Spacer()
                        if viewModel.showWatermark {
                            MovieWatermarkModule(
                                scale: scale,
                                watermarkText: $viewModel.watermarkText,
                                watermarkSize: viewModel.watermarkSize,
                                watermarkColor: viewModel.watermarkColor,
                                watermarkOpacity: viewModel.watermarkOpacity
                            )
                        }
                    }
                    .padding(.horizontal, viewModel.headerHorizontalPadding * scale)
                    .padding(.vertical, viewModel.headerPadding * scale)
                    
                    Spacer()
                    
                    // 内容卡片
                    VStack(alignment: .leading) {
                        MovieTitleModule(
                            scale: scale,
                            title: $viewModel.title,
                            titleFont: viewModel.titleFont,
                            titleFontSize: viewModel.titleFontSize,
                            titleColor: viewModel.titleColor
                        )
                        .padding(.bottom, 4 * scale)
                        
                        HStack {
                            MovieSubtitleModule(
                                scale: scale,
                                subtitle: $viewModel.subtitle,
                                contentFont: viewModel.contentFont,
                                contentFontSize: viewModel.contentFontSize,
                                textColor: viewModel.textColor
                            )
                            
                            Spacer()
                            
                            if viewModel.showDate {
                                MovieDateModule(
                                    scale: scale,
                                    date: viewModel.date,
                                    dateColor: viewModel.dateColor,
                                    contentFont: viewModel.contentFont,
                                    contentFontSize: viewModel.contentFontSize,
                                    selectedFormat: $viewModel.dateFormat
                                )
                            }
                        }
                        .padding(.bottom, 16 * scale)
                        
                        // 内容部分使用 lineSpacing
                        MovieContentModule(
                            scale: scale,
                            content: $viewModel.content,
                            contentFont: viewModel.contentFont,
                            contentFontSize: viewModel.contentFontSize,
                            textColor: viewModel.textColor,
                            lineSpacing: viewModel.lineSpacing
                        )
                    }
                    .padding(viewModel.contentCardPadding * scale)
                    .background(
                        viewModel.cardBackgroundColor
                            .opacity(viewModel.contentCardOpacity)
                            .shadow(color: .black.opacity(viewModel.shadowOpacity), 
                                   radius: viewModel.shadowRadius * scale)
                    )
                    .cornerRadius(viewModel.cornerRadius * scale)
                    .padding(.horizontal, viewModel.horizontalPadding * scale)
                    .padding(.bottom, viewModel.bottomPadding * scale)
                }
            }
        }
        .frame(width: width, height: height)
        .clipShape(Rectangle())
        .photosPicker(
            isPresented: $showImagePicker,
            selection: Binding(
                get: { nil },
                set: { item in
                    if let item = item {
                        Task {
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                await MainActor.run {
                                    viewModel.image = image
                                }
                            }
                        }
                    }
                }
            ),
            matching: .images
        )
    }
}
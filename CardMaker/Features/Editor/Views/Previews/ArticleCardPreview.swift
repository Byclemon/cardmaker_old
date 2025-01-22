import SwiftUI
import CoreImage.CIFilterBuiltins
// MARK: - 图标模块
struct ArticleIconModule: View {
    let scale: CGFloat
    let showDate: Bool
    @Binding var icon: String
    let moduleBackgroundColor: Color
    let moduleHeight: CGFloat
    @State private var showIconPicker = false
    @ObservedObject var viewModel: ArticleCardViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 20 * scale, weight: .semibold))
                .symbolRenderingMode(.palette)  // 使用 palette 渲染模式
                .foregroundStyle(iconGradient)
                .frame(width: moduleHeight * 0.8 * scale, height: moduleHeight * 0.8 * scale)
            Spacer()
        }
        .frame(width: showDate ? moduleHeight * scale : nil, height: moduleHeight * scale)
        .background(
            moduleBackgroundColor
                .opacity(0.95)
                .shadow(color: .black.opacity(0.05), radius: 5 * scale)
        )
        .cornerRadius(10 * scale)
        .onTapGesture {
            showIconPicker = true
        }
        .sheet(isPresented: $showIconPicker) {
            IconPickerView(selectedIcon: $icon)
                .presentationDetents([.medium])
        }
    }
    
    private var iconGradient: LinearGradient {
        if viewModel.useGradient {
            return LinearGradient(
                colors: viewModel.gradientColors,
                startPoint: .init(x: 0.5 + 0.5 * cos(viewModel.gradientAngle * .pi / 180),
                              y: 0.5 + 0.5 * sin(viewModel.gradientAngle * .pi / 180)),
                endPoint: .init(x: 0.5 - 0.5 * cos(viewModel.gradientAngle * .pi / 180),
                            y: 0.5 - 0.5 * sin(viewModel.gradientAngle * .pi / 180))
            )
        } else {
            return LinearGradient(
                colors: [viewModel.backgroundColor],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}

// MARK: - 日期模块
struct ArticleDateModule: View {
    let scale: CGFloat
    let date: Date
    let dataColor: Color
    let moduleBackgroundColor: Color
    let moduleHeight: CGFloat
    @State private var isEditing = false
    @Binding var selectedFormat: DateFormat
    
    private let dateFormats: [DateFormat] = [
        .standard,
        .shortDate,
        .longDate,
        .fullDate,
        .withTime,
        .withWeekday
    ]
    
    var body: some View {
        Text(selectedFormat.format(date))
            .font(.system(size: 16 * scale, weight: .medium))
            .foregroundColor(dataColor)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(height: moduleHeight * scale)
            .background(
                moduleBackgroundColor
                    .opacity(0.95)
                    .shadow(color: .black.opacity(0.05), radius: 5 * scale)
            )
            .cornerRadius(10 * scale)
            .onTapGesture {
                isEditing = true
            }
            .sheet(isPresented: $isEditing) {
                NavigationView {
                    List(dateFormats, id: \.rawValue) { format in
                        Button {
                            selectedFormat = format
                            isEditing = false
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(format.name)
                                        .foregroundColor(.primary)
                                    Text(format.format(date))
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if format == selectedFormat {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
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
                .presentationDragIndicator(.visible)
            }
    }
}

enum DateFormat: String {
    case standard = "standard"
    case shortDate = "shortDate"
    case longDate = "longDate"
    case fullDate = "fullDate"
    case withTime = "withTime"
    case withWeekday = "withWeekday"
    
    var name: String {
        switch self {
        case .standard: return "标准格式"
        case .shortDate: return "短日期"
        case .longDate: return "长日期"
        case .fullDate: return "完整日期"
        case .withTime: return "带时间"
        case .withWeekday: return "带星期"
        }
    }
    
    func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        
        switch self {
        case .standard:
            formatter.dateFormat = "yyyy-MM-dd"
        case .shortDate:
            formatter.dateFormat = "MM-dd"
        case .longDate:
            formatter.dateFormat = "yyyy年MM月dd日"
        case .fullDate:
            formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        case .withTime:
            formatter.dateFormat = "MM-dd HH:mm"
        case .withWeekday:
            formatter.dateFormat = "MM-dd EEEE"
        }
        
        return formatter.string(from: date)
    }
}

// MARK: - 标题模块
struct ArticleTitleModule: View {
    let scale: CGFloat
    @Binding var title: String
    let titleFont: String
    let titleSize: CGFloat
    let titleColor: Color
    let moduleBackgroundColor: Color
    let moduleHeight: CGFloat
    @ObservedObject var viewModel: ArticleCardViewModel
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            if isEditing {
                TextField("输入标题", text: $title)
                    .font(.custom(titleFont, size: titleSize * scale))
                    .foregroundStyle(titleGradient)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
            } else {
                Text(title.isEmpty ? "输入标题" : title)
                    .font(.custom(titleFont, size: titleSize * scale))
                    .foregroundStyle(titleGradient)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
        }
        .frame(height: moduleHeight * scale)
        .padding(.horizontal, 16 * scale)
        .background(
            moduleBackgroundColor
                .opacity(0.95)
                .shadow(color: .black.opacity(0.05), radius: 5 * scale)
        )
        .cornerRadius(10 * scale)
        .onTapGesture {
            isEditing = true
        }
    }
    
    private var titleGradient: LinearGradient {
        if viewModel.useGradient {
            return LinearGradient(
                colors: viewModel.gradientColors,
                startPoint: .init(x: 0.5 + 0.5 * cos(viewModel.gradientAngle * .pi / 180),
                              y: 0.5 + 0.5 * sin(viewModel.gradientAngle * .pi / 180)),
                endPoint: .init(x: 0.5 - 0.5 * cos(viewModel.gradientAngle * .pi / 180),
                            y: 0.5 - 0.5 * sin(viewModel.gradientAngle * .pi / 180))
            )
        } else {
            return LinearGradient(
                colors: [titleColor],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}

// MARK: - 内容模块
struct ArticleContentModule: View {
    let scale: CGFloat
    @Binding var content: String
    let contentFont: String
    let contentSize: CGFloat
    let contentColor: Color
    let moduleBackgroundColor: Color
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            if isEditing {
                TextField("输入内容", text: $content, axis: .vertical)
                    .font(.custom(contentFont, size: contentSize * scale))
                    .foregroundColor(contentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
            } else {
                Text(content.isEmpty ? "输入内容" : content)
                    .font(.custom(contentFont, size: contentSize * scale))
                    .foregroundColor(contentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 16 * scale)
        .padding(.vertical, 12 * scale)
        .background(
            moduleBackgroundColor
                .opacity(0.95)
                .shadow(color: .black.opacity(0.05), radius: 5 * scale)
        )
        .cornerRadius(10 * scale)
        .onTapGesture {
            isEditing = true
        }
    }
}

// MARK: - 作者模块
struct ArticleAuthorModule: View {
    let scale: CGFloat
    @Binding var author: String
    let authorColor: Color
    let moduleBackgroundColor: Color
    let moduleHeight: CGFloat
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8 * scale) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 14 * scale))
                .foregroundColor(authorColor)
                .frame(width: 16 * scale)
            
            if isEditing {
                TextField("输入作者", text: $author)
                    .font(.system(size: 14 * scale))
                    .foregroundColor(authorColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
            } else {
                Text(author.isEmpty ? "输入作者" : author)
                    .font(.system(size: 14 * scale))
                    .foregroundColor(authorColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
        }
        
        .frame(height: moduleHeight * scale)
        .padding(.horizontal, 16 * scale)
        .background(
            moduleBackgroundColor
                .opacity(0.95)
                .shadow(color: .black.opacity(0.05), radius: 5 * scale)
        )
        .cornerRadius(10 * scale)
        .onTapGesture {
            isEditing = true
        }
    }
}

// MARK: - 字数模块
struct ArticleWordCountModule: View {
    let scale: CGFloat
    let wordCount: Int
    let wordCountColor: Color
    let moduleBackgroundColor: Color
    let moduleHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 8 * scale) {
            Image(systemName: "character.textbox")
                .font(.system(size: 14 * scale))
                .foregroundColor(wordCountColor)
                .frame(width: 16 * scale)
            
            Text("\(wordCount)字")
                .font(.system(size: 14 * scale, weight: .medium))
                .foregroundColor(wordCountColor)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Spacer()
        }
        .frame(height: moduleHeight * scale)
        .padding(.horizontal, 16 * scale)
        .background(
            moduleBackgroundColor
                .opacity(0.95)
                .shadow(color: .black.opacity(0.05), radius: 5 * scale)
        )
        .cornerRadius(10 * scale)
    }
}

// MARK: - 二维码模块
struct ArticleQRCodeModule: View {
    let scale: CGFloat
    @Binding var qrCodeData: String
    let moduleBackgroundColor: Color
    let moduleHeight: CGFloat
    let qrCodeColor: Color
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 16 * scale) {
            // 左侧文字部分
            VStack(alignment: .leading, spacing: 4 * scale) {
                Text("更多内容")
                    .font(.system(size: 14 * scale, weight: .medium))
                    .foregroundColor(qrCodeColor)
                 Text("扫描二维码")
                    .font(.system(size: 12 * scale))
                    .foregroundColor(qrCodeColor.opacity(0.8))
                    .lineLimit(1)
                
               
            }
            
            Spacer()
            
            // 右侧二维码部分
            if let qrCode = generateQRCode(from: qrCodeData, color: qrCodeColor) {
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: moduleHeight * 0.8 * scale, height: moduleHeight * 0.8 * scale)
            }
        }
        .frame(height: moduleHeight * 1.4 * scale)
        .padding(.horizontal, 16 * scale)
        .background(
            moduleBackgroundColor
                .opacity(0.95)
                .shadow(color: .black.opacity(0.05), radius: 5 * scale)
        )
        .cornerRadius(10 * scale)
        .onTapGesture {
            isEditing = true
        }
        .sheet(isPresented: $isEditing) {
            NavigationView {
                VStack(spacing: 24) {
                    // 输入框部分
                    VStack(alignment: .leading, spacing: 8) {
                        Text("链接地址")
                            .foregroundColor(.secondary)
                            .font(.system(size: 13))
                        TextField("输入链接地址", text: $qrCodeData)
                            .textFieldStyle(.roundedBorder)
                            .focused($isFocused)
                    }
                    .padding(.horizontal)
                    
                    // 二维码预览部分
                    VStack(spacing: 12) {
                        if let qrCode = generateQRCode(from: qrCodeData, color: qrCodeColor) {
                            Image(uiImage: qrCode)
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.1), radius: 5)
                        }
                        
                        Text(qrCodeData)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    // .background(Color(.systemGroupedBackground))
                    
                    Spacer()
                }
                .padding(.top)
                .navigationTitle("修改二维码")
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
            .presentationDragIndicator(.visible)
        }
    }
    
    private func generateQRCode(from string: String, color: Color) -> UIImage? {
        guard let data = string.data(using: .utf8),
              let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let ciImage = filter.outputImage else {
            return nil
        }
        
        // 获取颜色的 RGB 分量
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // 转换成指定颜色
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(red: red, green: green, blue: blue), forKey: "inputColor0")
        colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        guard let coloredImage = colorFilter?.outputImage else {
            return nil
        }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = coloredImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        
        // 创建一个新的渲染上下文
        UIGraphicsBeginImageContextWithOptions(uiImage.size, false, uiImage.scale)
        defer { UIGraphicsEndImageContext() }
        
        // 使用指定颜色绘制图像
        uiColor.set()
        uiImage.draw(in: CGRect(origin: .zero, size: uiImage.size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - 水印模块
struct ArticleWatermarkModule: View {
    let scale: CGFloat
    @Binding var watermarkText: String
    let watermarkColor: Color
    let watermarkOpacity: Double
    let moduleBackgroundColor: Color
    let moduleHeight: CGFloat
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Image(systemName: "signature")
                .font(.system(size: 12 * scale))
                .foregroundColor(watermarkColor)
                .opacity(watermarkOpacity)
                .frame(width: 16 * scale)
                .padding(.trailing, 4 * scale)
            
            if isEditing {
                TextField("输入水印", text: $watermarkText)
                    .font(.system(size: 12 * scale))
                    .foregroundColor(watermarkColor)
                    .opacity(watermarkOpacity)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .keyboardToolbar(isEditing: $isEditing, isFocused: _isFocused)
            } else {
                Text(watermarkText.isEmpty ? "输入水印" : watermarkText)
                    .font(.system(size: 12 * scale))
                    .foregroundColor(watermarkColor)
                    .opacity(watermarkOpacity)
                    .lineLimit(1)
            }
            Spacer()
        }
        
        .frame(height: moduleHeight * scale)
        .padding(.horizontal, 16 * scale)
        .background(
            moduleBackgroundColor
                .opacity(0.95)
                .shadow(color: .black.opacity(0.05), radius: 5 * scale)
        )
        .cornerRadius(10 * scale)
        .onTapGesture {
            isEditing = true
        }
    }
}

// MARK: - 背景视图
private struct ArticleCardBackground: View {
    @ObservedObject var viewModel: ArticleCardViewModel
    
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
        //毛玻璃效果，先不使用吧
        // .overlay {
        //     Rectangle()
        //         .fill(.ultraThinMaterial)
        // }
    }
}

// MARK: - 头部模块
private struct ArticleHeaderModules: View {
    let scale: CGFloat
    @ObservedObject var viewModel: ArticleCardViewModel
    
    var body: some View {
        HStack(spacing: 12 * scale) {
            if viewModel.showIcon {
                ArticleIconModule(scale: scale,
                    showDate: viewModel.showDate,
                    icon: $viewModel.icon,
                    moduleBackgroundColor: viewModel.moduleBackgroundColor,
                    moduleHeight: viewModel.moduleHeight,
                    viewModel: viewModel)
                    .transition(.opacity)
            }
            
            if viewModel.showDate {
                ArticleDateModule(scale: scale,
                       date: viewModel.date,
                       dataColor: viewModel.dataColor,
                       moduleBackgroundColor: viewModel.moduleBackgroundColor,
                       moduleHeight: viewModel.moduleHeight,
                       selectedFormat: $viewModel.dateFormat)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showIcon)
        .animation(.easeInOut(duration: 0.2), value: viewModel.showDate)
    }
}


// MARK: - 主视图
struct ArticleCardPreview: View {
    let width: CGFloat
    let height: CGFloat
    let scale: CGFloat
    @ObservedObject var viewModel: ArticleCardViewModel
    
    var body: some View {
        ZStack {
            ArticleCardBackground(viewModel: viewModel)
            
            VStack(spacing: 8 * scale) {
                ArticleHeaderModules(scale: scale, viewModel: viewModel)
                
                if viewModel.showTitle {
                    ArticleTitleModule(scale: scale,
                            title: $viewModel.title,
                            titleFont: viewModel.titleFont,
                            titleSize: viewModel.titleSize,
                            titleColor: viewModel.titleColor,
                            moduleBackgroundColor: viewModel.moduleBackgroundColor,
                            moduleHeight: viewModel.moduleHeight,
                            viewModel: viewModel)
                        .transition(.opacity)
                }
                
                if viewModel.showContent {
                    ArticleContentModule(scale: scale,
                                content: $viewModel.content,
                                contentFont: viewModel.contentFont,
                                contentSize: viewModel.contentSize,
                                contentColor: viewModel.contentColor,
                                moduleBackgroundColor: viewModel.moduleBackgroundColor)
                        .transition(.opacity)
                }
                
                HStack(spacing: 8 * scale) {
                    if viewModel.showAuthor {
                        ArticleAuthorModule(scale: scale,
                                   author: $viewModel.author,
                                   authorColor: viewModel.authorColor,
                                   moduleBackgroundColor: viewModel.moduleBackgroundColor,
                                   moduleHeight: viewModel.moduleHeight)
                            .transition(.opacity)
                    }
                    
                    if viewModel.showWordCount {
                        ArticleWordCountModule(scale: scale,
                                      wordCount: viewModel.content.count,
                                      wordCountColor: viewModel.wordCountColor,
                                      moduleBackgroundColor: viewModel.moduleBackgroundColor,
                                      moduleHeight: viewModel.moduleHeight)
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.showAuthor)
                .animation(.easeInOut(duration: 0.2), value: viewModel.showWordCount)
                
                if viewModel.showQRCode {
                    ArticleQRCodeModule(scale: scale,
                               qrCodeData: $viewModel.qrCodeData,
                               moduleBackgroundColor: viewModel.moduleBackgroundColor,
                               moduleHeight: viewModel.moduleHeight,
                               qrCodeColor: viewModel.qrCodeColor)
                        .transition(.opacity)
                }
                
                if viewModel.showWatermark {
                    ArticleWatermarkModule(scale: scale,
                                  watermarkText: $viewModel.watermarkText,
                                  watermarkColor: viewModel.watermarkColor,
                                  watermarkOpacity: viewModel.watermarkOpacity,
                                  moduleBackgroundColor: viewModel.moduleBackgroundColor,
                                  moduleHeight: viewModel.moduleHeight)
                        .transition(.opacity)
                }
            }
            .padding(viewModel.innerPadding * scale)
            .background(viewModel.cardBackgroundColor.opacity(viewModel.cardOpacity))
            .cornerRadius(viewModel.cornerRadius * scale)
            .padding(viewModel.edgePadding * scale)
        }
        .frame(width: width)
        .fixedSize(horizontal: false, vertical: true)
        .clipShape(Rectangle())
    }
}

#Preview {
    ArticleCardPreview(
        width: 300,
        height: 500,
        scale: 1,
        viewModel: ArticleCardViewModel()
    )
}


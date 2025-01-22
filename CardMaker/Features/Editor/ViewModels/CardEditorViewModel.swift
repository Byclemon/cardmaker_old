import SwiftUI
import LinkPresentation

class CardEditorViewModel: ObservableObject {
    @Published var baseCard: BaseCardViewModel
    @Published var articleCard: ArticleCardViewModel
    @Published var layeredCard: LayeredCardViewModel
    @Published var movieCard: MovieCardViewModel
    @Published var selectedAspectRatioIndex: Int = 0
    @Published var layout: String = ""
    
    private var theme: CustomTheme?
    
    init(theme: CustomTheme? = nil) {
        self.theme = theme
        self.baseCard = BaseCardViewModel()
        self.articleCard = ArticleCardViewModel()
        self.layeredCard = LayeredCardViewModel()
        self.movieCard = MovieCardViewModel()
         FontLoader.shared.preloadFonts(fontPresets)
    }
    
    func setLayout(_ layout: String) {
        self.layout = layout
        // 只有在没有主题的情况下才重置为默认值
        if theme == nil {
            switch layout {
            case "baseCard":
                self.baseCard = BaseCardViewModel()
            case "articleCard":
                self.articleCard = ArticleCardViewModel()
            case "layeredCard":
                self.layeredCard = LayeredCardViewModel()
            case "movieCard":
                self.movieCard = MovieCardViewModel()
            default:
                break
            }
        }
    }
    
    // MARK: - 预设数据
    private let aspectRatios: [String: [CGFloat]] = [
        "baseCard": [1.0/1.0, 4.0/3.0, 16.0/9.0, 3.0/4.0, 9.0/16.0],
        "layeredCard": [1.0/1.0, 3.0/4.0, 9.0/16.0],  // 层叠卡片只需要方形
        "movieCard": [3.0/4.0, 1.0/1.0,  9.0/16.0],  // 电影卡片只需要视频比例
    ]
    
    private let aspectRatioNames: [String: [String]] = [
        "baseCard": ["1:1", "4:3", "16:9", "3:4", "9:16"],
        "layeredCard": ["1:1", "3:4", "9:16"],
        "movieCard": ["3:4","1:1",   "9:16"],
    ]
    
    var currentAspectRatio: CGFloat {
        let ratios = aspectRatios[layout] ?? [1.0]
        let index = min(selectedAspectRatioIndex, ratios.count - 1)
        return ratios[index]
    }
    
    var currentAspectRatioNames: [String] {
        return aspectRatioNames[layout] ?? ["1:1"]
    }
    
    let fontPresets = [
        "PingFang SC",
        "AaJianHaoTi",
        "Slidefu",
        "HongLeiZhuoShu",
        "TsangerYuMo",
        "TsangerXWZ",
        "TsangerYuYangT"
    ]
    
    let fontNames: [String: String] = [
        "PingFang SC": "系统",
        "AaJianHaoTi": "建豪体",
        "Slidefu": "演示佛系",
        "HongLeiZhuoShu": "鸿雷拙书",
        "TsangerYuMo": "仓耳与墨",
        "TsangerXWZ": "仓耳行者",
        "TsangerYuYangT": "仓耳渔阳"
    ]
    
    // MARK: - 卡片尺寸计算
    func calculateCardSize(screenWidth: CGFloat, scale: CGFloat = 1.0) -> (size: CGSize, scale: CGFloat) {
        let aspectRatio = currentAspectRatio
        let baseWidth: CGFloat = 300
        let scale = screenWidth / baseWidth
        
        let width = baseWidth
        let height = width / aspectRatio
        
        return (
            CGSize(width: width * scale, height: height * scale),
            scale
        )
    }
    
    // MARK: - 图片生成与分享
    @MainActor
    func generateImage(from view: some View, size: CGSize) async -> UIImage? {
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        renderer.proposedSize = .init(size)
        
        // 强制等待视图更新
        try? await Task.sleep(nanoseconds: 100_000_000) // 等待 0.1 秒
        
        if let uiImage = renderer.uiImage {
            UIGraphicsBeginImageContextWithOptions(uiImage.size, true, uiImage.scale)
            defer { UIGraphicsEndImageContext() }
            
            UIColor.white.setFill()
            UIRectFill(CGRect(origin: .zero, size: uiImage.size))
            
            uiImage.draw(in: CGRect(origin: .zero, size: uiImage.size))
            
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
    
    @MainActor
    func shareCardAsImage(preview: some View, size: CGSize) async -> Bool {
        guard let image = await generateImage(from: preview, size: size) else { return false }
        
        return await withCheckedContinuation { continuation in
            let activityVC = UIActivityViewController(
                activityItems: [image],
                applicationActivities: nil
            )
            
            // 添加完成回调
            activityVC.completionWithItemsHandler = { _, completed, _, _ in
                continuation.resume(returning: completed)
            }
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootVC = window.rootViewController {
                rootVC.present(activityVC, animated: true)
            }
        }
    }
    

    
}



extension CardEditorViewModel {
    func createBaseCardPreview(width: CGFloat, height: CGFloat, scale: CGFloat) -> BaseCardPreview {

        return BaseCardPreview(
            width: width,
            height: height,
            scale: scale,
            viewModel: baseCard
        )
    }

    func createArticleCardPreview(width: CGFloat, height: CGFloat, scale: CGFloat) -> ArticleCardPreview {
        return ArticleCardPreview(
            width: width,
            height: height,
            scale: scale,
            viewModel: articleCard
        )
    }

    func createLayeredCardPreview(width: CGFloat, height: CGFloat, scale: CGFloat) -> LayeredCardPreview {
        return LayeredCardPreview(
            width: width,
            height: height,
            scale: scale,
            viewModel: layeredCard
        )
    }

    func createMovieCardPreview(width: CGFloat, height: CGFloat, scale: CGFloat) -> MovieCardPreview {
        return MovieCardPreview(
            width: width,
            height: height,
            scale: scale,
            viewModel: movieCard
        )
    }

}

extension CardEditorViewModel {
    // 获取当前样式
    private var currentBaseStyle: BaseCardStyle? {
        guard layout == "baseCard" else { return nil }
        return BaseCardStyle(
            name: "",
            useGradient: baseCard.useGradient,
            gradientColors: baseCard.gradientColors,
            gradientAngle: baseCard.gradientAngle,
            backgroundColor: baseCard.backgroundColor,
            showWindowControls: baseCard.showWindowControls,
            cardBackgroundColor: baseCard.cardBackgroundColor,
            cardOpacity: baseCard.cardOpacity,
            cornerRadius: baseCard.cornerRadius,
            edgePadding: baseCard.edgePadding,
            innerPadding: baseCard.innerPadding,
            selectedFont: baseCard.selectedFont,
            fontSize: baseCard.fontSize,
            textColor: baseCard.textColor,
            textAlignment: baseCard.textAlignment,
            lineSpacing: baseCard.lineSpacing,
            textSpacing: baseCard.textSpacing,
            textShadowRadius: baseCard.textShadowRadius,
            textShadowColor: baseCard.textShadowColor,
            showWatermark: baseCard.showWatermark,
            watermarkText: baseCard.watermarkText,
            watermarkOpacity: baseCard.watermarkOpacity,
            watermarkSize: baseCard.watermarkSize,
            watermarkColor: baseCard.watermarkColor,
            watermarkPosition: baseCard.watermarkPosition
        )
    }
    
    private var currentArticleStyle: ArticleCardStyle? {
        guard layout == "articleCard" else { return nil }
        return ArticleCardStyle(
  
            name: "",
            useGradient: articleCard.useGradient,
            gradientColors: articleCard.gradientColors,
            gradientAngle: articleCard.gradientAngle,
            backgroundColor: articleCard.backgroundColor,
            cardBackgroundColor: articleCard.cardBackgroundColor,
            cardOpacity: articleCard.cardOpacity,
            cornerRadius: articleCard.cornerRadius,
            edgePadding: articleCard.edgePadding,
            innerPadding: articleCard.innerPadding,
            moduleHeight: articleCard.moduleHeight,
            moduleBackgroundColor: articleCard.moduleBackgroundColor,
            titleFont: articleCard.titleFont,
            contentFont: articleCard.contentFont,
            titleSize: articleCard.titleSize,
            contentSize: articleCard.contentSize,
            titleColor: articleCard.titleColor,
            contentColor: articleCard.contentColor,
            authorColor: articleCard.authorColor,
            wordCountColor: articleCard.wordCountColor,
            qrCodeColor: articleCard.qrCodeColor,
            dataColor: articleCard.dataColor,
            watermarkColor: articleCard.watermarkColor,
            watermarkOpacity: articleCard.watermarkOpacity
        )
    }
    
    private var currentLayeredStyle: LayeredCardStyle? {
        guard layout == "layeredCard" else { return nil }
        return LayeredCardStyle(
 
            name: "",
            layerColors: layeredCard.layerColors,
            layerScales: layeredCard.layerScales,
            layerOffsets: layeredCard.layerOffsets,
            layerRotations: layeredCard.layerRotations,
            layerVisibility: layeredCard.layerVisibility,
            useGradient: layeredCard.useGradient,
            gradientColors: layeredCard.gradientColors,
            gradientAngle: layeredCard.gradientAngle,
            backgroundColor: layeredCard.backgroundColor,
            selectedFont: layeredCard.selectedFont,
            fontSize: layeredCard.fontSize,
            textColor: layeredCard.textColor,
            textAlignment: layeredCard.textAlignment,
            lineSpacing: layeredCard.lineSpacing
        )
    }
    
    private var currentMovieStyle: MovieCardStyle? {
        guard layout == "movieCard" else { return nil }
        return MovieCardStyle(
            name: "",
            useGradient: movieCard.useGradient,
            gradientColors: movieCard.gradientColors,
            gradientAngle: movieCard.gradientAngle,
            backgroundColor: movieCard.backgroundColor,
            cardBackgroundColor: movieCard.cardBackgroundColor,
            cardOpacity: movieCard.contentCardOpacity,
            cornerRadius: movieCard.cornerRadius,
            blurRadius: movieCard.blurRadius,
            darkenAmount: movieCard.darkenAmount,
            titleColor: movieCard.titleColor,
            textColor: movieCard.textColor,
            dateColor: movieCard.dateColor,
            awardTextColor: movieCard.awardTextColor,
            watermarkColor: movieCard.watermarkColor,
            titleFont: movieCard.titleFont,
            titleFontSize: movieCard.titleFontSize,
            contentFont: movieCard.contentFont,
            contentFontSize: movieCard.contentFontSize,
            showWatermark: movieCard.showWatermark,
            watermarkText: movieCard.watermarkText,
            watermarkOpacity: movieCard.watermarkOpacity,
            watermarkSize: movieCard.watermarkSize,
            topPadding: movieCard.headerPadding,
            horizontalPadding: movieCard.horizontalPadding,
            bottomPadding: movieCard.bottomPadding
        )
    }
    
    // 应用样式方法
    private func applyBaseStyle(_ style: BaseCardStyle) {
        style.apply(to: baseCard)
    }
    
    private func applyArticleStyle(_ style: ArticleCardStyle) {
        style.apply(to: articleCard)
    }
    
    private func applyLayeredStyle(_ style: LayeredCardStyle) {
        style.apply(to: layeredCard)
    }
    
    func saveCurrentTheme(name: String) {
        let theme = CustomTheme(
            id: UUID(),
            name: name,
            layout: layout,
            createdAt: Date(),
            baseStyle: currentBaseStyle,
            articleStyle: currentArticleStyle,
            layeredStyle: currentLayeredStyle,
            movieStyle: currentMovieStyle
        )
        ThemeManager.shared.saveTheme(theme)
    }
}

extension CardEditorViewModel {
    func applyTheme(_ theme: CustomTheme) {
        switch theme.layout {
        case "baseCard":
            if let style = theme.baseStyle {
                style.apply(to: baseCard)
            }
        case "articleCard":
            if let style = theme.articleStyle {
                style.apply(to: articleCard)
            }
        case "layeredCard":
            if let style = theme.layeredStyle {
                style.apply(to: layeredCard)
            }
        case "movieCard":
            if let style = theme.movieStyle {
                style.apply(to: movieCard)
            }
        default:
            break
        }
    }
}


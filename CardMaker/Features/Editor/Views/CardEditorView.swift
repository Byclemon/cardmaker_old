import SwiftUI

struct CardEditorView: View {
    let layout: String
    let theme: CustomTheme?
    let isFromTheme: Bool
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CardEditorViewModel
    
    init(layout: String, theme: CustomTheme? = nil, isFromTheme: Bool = false) {
        self.layout = layout
        self.theme = theme
        self.isFromTheme = isFromTheme
        let vm = CardEditorViewModel(theme: theme)
        vm.layout = layout
        if let theme = theme {
            vm.applyTheme(theme)
        }
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    @State private var isExporting = false
    @State private var showSuccessToast = false
    @State private var showingSaveThemeAlert = false
    @State private var newThemeName = ""
    
    var body: some View {
        CardEditorContainer(
            layout: layout,
            isFromTheme: isFromTheme,
            viewModel: viewModel
        )
        .navigationTitle("编辑卡片")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    if !isFromTheme {
                        Button {
                            showingSaveThemeAlert = true
                        } label: {
                            Image(systemName: "star")
                        }
                    }
                    
                    if layout != "articleCard" {
                        AspectRatioButton(layout: layout, viewModel: viewModel)
                    }
                    
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            isExporting = true
                        }
                        Task {
                            let success = await exportAndShareCard()
                            withAnimation(.spring(duration: 0.3)) {
                                isExporting = false
                            }
                            if success {
                                withAnimation(.spring(duration: 0.3)) {
                                    showSuccessToast = true
                                }
                                try? await Task.sleep(nanoseconds: 1_500_000_000)
                                withAnimation {
                                    showSuccessToast = false
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .scaleEffect(isExporting ? 0.8 : 1)
                            .opacity(isExporting ? 0.6 : 1)
                    }
                    .disabled(isExporting)
                }   
            }
        }
        .navigationViewStyle(.stack)
        .alert("保存主题", isPresented: $showingSaveThemeAlert) {
            TextField("主题名称", text: $newThemeName)
            Button("取消", role: .cancel) { }
            Button("保存") {
                viewModel.saveCurrentTheme(name: newThemeName)
                showSuccessToast = true
            }
        } message: {
            Text("请输入新主题的名称")
        }
        .overlay(alignment: .bottom) {
            if showSuccessToast {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                    Text("保存成功")
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(
                    Color(.systemBackground)
                        .opacity(0.98)
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .cornerRadius(12)
                .transition(
                    .asymmetric(
                        insertion: .scale(scale: 0.8)
                            .combined(with: .opacity)
                            .combined(with: .move(edge: .bottom)),
                        removal: .opacity
                    )
                )
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            viewModel.setLayout(layout)
        }
    }
    
    private func exportAndShareCard() async -> Bool {
        let exportWidth: CGFloat = 1200
        let (size, scale) = viewModel.calculateCardSize(screenWidth: exportWidth)

        switch layout { 
            case "baseCard":
                let preview = viewModel.createBaseCardPreview(width: size.width, height: size.height, scale: scale)
                return await viewModel.shareCardAsImage(preview: preview, size: size)
            case "articleCard":
                let preview = viewModel.createArticleCardPreview(width: size.width, height: size.height, scale: scale)
                return await viewModel.shareCardAsImage(preview: preview, size: size)
            case "layeredCard":
                let preview = viewModel.createLayeredCardPreview(width: size.width, height: size.height, scale: scale)
                return await viewModel.shareCardAsImage(preview: preview, size: size)
            case "movieCard":
                let preview = viewModel.createMovieCardPreview(width: size.width, height: size.height, scale: scale)
                return await viewModel.shareCardAsImage(preview: preview, size: size)
            default:
                return false
        }
    }
}

// MARK: - 子视图组件
struct CardEditorContainer: View {
    let layout: String
    let isFromTheme: Bool
    @ObservedObject var viewModel: CardEditorViewModel
    @State private var isKeyboardVisible = false
    
    var body: some View {
        ZStack {
           Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                CardPreviewSection(
                    layout: layout,
                    viewModel: viewModel
                )
                .padding(.vertical)
                 .onAppear {
                    KeyboardManager.setupKeyboardNotifications(isKeyboardVisible: $isKeyboardVisible)
                }
                
                if !isKeyboardVisible {
                    CardToolSection(
                        layout: layout,
                        viewModel: viewModel
                    )
                    .background(Color(.systemBackground))
                }
            }
        }
       
    }
}

struct CardPreviewSection: View {
    let layout: String
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                let (size, scale) = viewModel.calculateCardSize(screenWidth: proxy.size.width)
                
                VStack {
                    switch layout {
                    case "baseCard":
                        viewModel.createBaseCardPreview(width: size.width, height: size.height, scale: scale)
                    case "articleCard":
                        viewModel.createArticleCardPreview(width: size.width, height: size.height, scale: scale)
                    case "layeredCard":
                        viewModel.createLayeredCardPreview(width: size.width, height: size.height, scale: scale)
                    case "movieCard":
                        viewModel.createMovieCardPreview(width: size.width, height: size.height, scale: scale)
                    default:
                        EmptyView()
                    }
                }
                .frame(width: size.width)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
            .frame(minHeight: proxy.size.height)
        }
    }
}

struct CardToolSection: View {
    let layout: String
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            switch layout {
            case "baseCard":
                BaseCardToolPanel(viewModel: viewModel)
            case "articleCard":
                ArticleCardToolPanel(viewModel: viewModel)
            case "layeredCard":
                LayeredCardToolPanel(viewModel: viewModel)
            case "movieCard":
                MovieCardToolPanel(viewModel: viewModel)
            default:
                EmptyView()
            }
        }
    }
}

struct AspectRatioButton: View {
    let layout: String
    @ObservedObject var viewModel: CardEditorViewModel
    
    var body: some View {
        Menu {
            ForEach(0..<viewModel.currentAspectRatioNames.count, id: \.self) { index in
                Button {
                    viewModel.selectedAspectRatioIndex = index
                } label: {
                    if index == viewModel.selectedAspectRatioIndex {
                        Label(viewModel.currentAspectRatioNames[index], systemImage: "checkmark")
                    } else {
                        Text(viewModel.currentAspectRatioNames[index])
                    }
                }
            }
        } label: {
            Image(systemName: "crop")
        }
    }
}

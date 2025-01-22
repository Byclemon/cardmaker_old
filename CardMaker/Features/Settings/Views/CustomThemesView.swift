import SwiftUI
import Foundation   

struct CustomThemesView: View {
    // MARK: - Properties
    @StateObject private var themeManager = ThemeManager.shared
    @State private var showingDeleteAlert = false
    @State private var themeToDelete: CustomTheme?
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    private let themeColors = [
        Color(hex: "6C5CE7"),  // 梦幻紫
        Color(hex: "00D2D3")   // 清新蓝
    ]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            backgroundLayer
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    headerSection
                    themeList
                }
                .padding(.vertical, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("删除主题", isPresented: $showingDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                if let theme = themeToDelete {
                    themeManager.deleteTheme(theme)
                }
            }
        } message: {
            Text("确定要删除这个主题吗？此操作无法撤销。")
        }
    }
    
    // MARK: - Views
    private var themeList: some View {
        LazyVStack(spacing: 16) {
            if themeManager.themes.isEmpty {
                emptyView
            } else {
                ForEach(themeManager.themes) { theme in
                    ThemeCard(theme: theme) {
                        themeToDelete = theme
                        showingDeleteAlert = true
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.square.fill")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
                .scaleEffect(1.2)
                .animation(.easeInOut(duration: 1).repeatForever(), value: true)
            
            Text("暂无保存的主题")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
    
    private var backgroundLayer: some View {
        ZStack {
            Group {
                if isDarkMode {
                    Color.black
                } else {
                    Color(hex: "F8F9FF")
                }
            }
            .ignoresSafeArea()
            
            GeometryReader { proxy in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: themeColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: proxy.size.width * 0.7)
                    .blur(radius: 80)
                    .offset(x: -proxy.size.width * 0.3, y: -proxy.size.height * 0.2)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: themeColors.reversed(),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: proxy.size.width * 0.7)
                    .blur(radius: 80)
                    .offset(x: proxy.size.width * 0.4, y: proxy.size.height * 0.4)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("我的主题")
                .font(.system(size: 28, weight: .bold))
            Text("保存的主题样式")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }
}

// MARK: - Components
private struct ThemeCard: View {
    let theme: CustomTheme
    let onDelete: () -> Void
    
    var body: some View {
        NavigationLink {
            CardEditorView(layout: theme.layout, theme: theme, isFromTheme: true)
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(theme.name)
                            .font(.headline)
                        Text(theme.layout.layoutName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .contentTransition(.symbolEffect(.replace))
                    }
                }
                
                Text(theme.createdAt.formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - Helper Extensions
private extension String {
    var layoutName: String {
        switch self {
        case "baseCard": return "基础卡片"
        case "articleCard": return "文章卡片"
        case "layeredCard": return "层叠卡片"
        case "movieCard": return "语录卡片"
        default: return ""
        }
    }
}
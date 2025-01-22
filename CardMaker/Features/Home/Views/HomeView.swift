import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    // 主题色配置
    private let themeColors = [
        Color(hex: "6C5CE7"),  // 梦幻紫
        Color(hex: "00D2D3")   // 清新蓝
    ]
    
    var body: some View {
        ZStack {
            // 背景层
            backgroundLayer
            
            // 内容层
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    headerSection
                    templateGrid
                }
                .padding(.vertical, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                profileButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                themeToggle
            }
        }
    }
    
    // MARK: - 背景层
    private var backgroundLayer: some View {
        ZStack {
            // 基础背景
            Group {
                if isDarkMode {
                    Color.black
                } else {
                    Color(hex: "F8F9FF")
                }
            }
            .ignoresSafeArea()
            
            // 装饰性渐变球
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
    
    // MARK: - 头部区域
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("创作中心")
                .font(.system(size: 28, weight: .bold))
            
            Text("选择模板开始制作你的专属卡片")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    // MARK: - 模板网格
    private var templateGrid: some View {
        VStack(alignment: .leading, spacing: 20) {
            // SectionTitle(title: "所有模板", subtitle: "All Templates")
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20)
                ],
                spacing: 20
            ) {
                ForEach(viewModel.templates) { template in
                    NavigationLink {
                        CardEditorView(layout: template.layout)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        TemplateCard(template: template)
                    }
                    .navigationViewStyle(.stack)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - 导航栏按钮
    private var profileButton: some View {
        NavigationLink(destination: SettingsView()) {
            Image(systemName: "person.circle.fill")
                .font(.title3)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(
                    LinearGradient(
                        colors: themeColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
    
    private var themeToggle: some View {
        Button(action: { 
            withAnimation(.spring(duration: 0.3)) {
                isDarkMode.toggle() 
            }
        }) {
            Image(systemName: isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                .font(.title3)
                .symbolRenderingMode(.palette)
                .foregroundStyle(
                    isDarkMode ? Color.white : Color.orange,
                    isDarkMode ? Color.yellow : Color.orange
                )
        }
        .tint(Color.clear)
    }
}

// MARK: - 子视图组件
struct SectionTitle: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 24)
    }
}


// 模板卡片
struct TemplateCard: View {
    let template: HomeModel.Template
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let image = template.previewImage {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text(template.name)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .padding(12)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}


#Preview {
    HomeView()
}

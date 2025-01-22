import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        List {
            // 关于信息
            Section {
                VStack(spacing: 24) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 10)
                    
                    VStack(spacing: 6) {
                        Text("CardMaker")
                            .font(.title.bold())
                        Text("版本 \(Bundle.main.appVersionString)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .listRowBackground(Color.clear)
            }
            
            // 主题设置
            Section {
                Toggle(isOn: $isDarkMode) {
                    Label {
                        Text("深色模式")
                    } icon: {
                        Image(systemName: isDarkMode ? "moon.fill" : "moon")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(Color(hex: "#6b7280"))
                    }
                }
                .tint(Color(hex: "#6366f1"))
            }
            
            // 功能区
            Section {
                Button {
                    requestReview()
                } label: {
                    Label("给个好评", systemImage: "star.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color(hex: "#6b7280"))
                }
                
                ShareLink(item: URL(string: "https://apps.apple.com/app/com.byclemon.cardmaker")!) {
                    Label("分享应用", systemImage: "square.and.arrow.up.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color(hex: "#6b7280"))
                }
                
            }
            
            // 帮助与支持
            Section {
                Link(destination: URL(string: "mailto:byclemon@gmail.com")!) {
                    Label("联系我们", systemImage: "envelope.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color(hex: "#6b7280"))
                }
                
                Link(destination: URL(string: "https://cardmaker.byclemon.com/privacy")!) {
                    Label("隐私政策", systemImage: "hand.raised.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color(hex: "#6b7280"))
                }
                
                Link(destination: URL(string: "https://cardmaker.byclemon.com/terms")!) {
                    Label("用户协议", systemImage: "doc.text.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color(hex: "#6b7280"))
                }
            }
            
            Section {
                Text("© 2024 Byclemon")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("设置")
    }
}

// MARK: - Bundle Extension
extension Bundle {
    var appVersionString: String {
        let version = infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
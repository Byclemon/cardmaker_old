import SwiftUI

struct SaveThemeButton: View {
    let viewModel: CardEditorViewModel
    @State private var showingSaveSheet = false
    @State private var themeName = ""
    
    var body: some View {
        VStack {
            Button {
                showingSaveSheet = true
            } label: {
                Label("保存当前主题", systemImage: "star")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .padding(.horizontal)
        }
        .alert("保存主题", isPresented: $showingSaveSheet) {
            TextField("主题名称", text: $themeName)
            Button("取消", role: .cancel) { }
            Button("保存") {
                if !themeName.isEmpty {
                    viewModel.saveCurrentTheme(name: themeName)
                    themeName = ""
                    showingSaveSheet = false
                }
            }
        } message: {
            Text("请输入新主题的名称")
        }
    }
}
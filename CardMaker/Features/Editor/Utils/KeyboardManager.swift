import SwiftUI

// MARK: - 键盘管理器
struct KeyboardManager {
    static func setupKeyboardNotifications(isKeyboardVisible: Binding<Bool>) {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main) { _ in
                withAnimation {
                    isKeyboardVisible.wrappedValue = true
                }
            }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main) { _ in
                withAnimation {
                    isKeyboardVisible.wrappedValue = false
                }
            }
    }
}

// MARK: - 键盘工具栏修饰符
struct KeyboardToolbarModifier: ViewModifier {
    @Binding var isEditing: Bool
    @FocusState var isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onAppear { isFocused = true }
            .onChange(of: isFocused) { oldValue, newValue in
                if !newValue {
                    withAnimation {
                        isEditing = false
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button {
                            isFocused = false
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
            }
    }
}

extension View {
    func keyboardToolbar(isEditing: Binding<Bool>, isFocused: FocusState<Bool>) -> some View {
        modifier(KeyboardToolbarModifier(isEditing: isEditing, isFocused: isFocused))
    }
}
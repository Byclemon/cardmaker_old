import SwiftUI

struct IconPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedIcon: String
    
    // 添加更多系统图标分类
    private let iconCategories: [(String, [String])] = [
        ("文档与写作", [
            "doc", "doc.fill", "doc.text", "doc.text.fill",
            "doc.richtext", "doc.plaintext", "doc.append", "doc.text.image",
            "doc.text.below.ecg", "note.text", "note", "note.text.badge.plus",
            "text.book.closed", "text.book.closed.fill", "book", "book.fill",
            "books.vertical", "books.vertical.fill", "book.closed", "book.closed.fill",
            "bookmark", "bookmark.fill", "text.quote", "quote.bubble"
        ]),
        ("编辑工具", [
            "pencil", "pencil.circle", "pencil.circle.fill",
            "pencil.and.outline", "pencil.tip", "pencil.line",
            "highlighter", "scribble", "scribble.variable",
            "scissors", "scissors.circle", "scissors.circle.fill",
            "paintbrush", "paintbrush.fill", "paintbrush.pointed",
            "eraser", "eraser.fill", "lasso", "lasso.and.sparkles"
        ]),
        ("排版布局", [
            "text.justify", "text.alignleft", "text.aligncenter", "text.alignright",
            "text.redaction", "text.cursor", "text.insert", "text.append",
            "text.badge.plus", "text.badge.minus", "text.badge.checkmark",
            "character.textbox", "text.word.spacing", "text.magnifyingglass",
            "paragraph", "list.bullet", "list.number", "list.dash"
        ]),
        ("界面元素", [
            "slider.horizontal.3", "button.programmable", "button.programmable.fill",
            "slider.horizontal.below.rectangle", "dial.min", "dial.min.fill",
            "switch.2", "rotate.3d", "aspectratio", "aspectratio.fill",
            "circle.grid.3x3", "square.grid.3x3", "rectangle.grid.3x3",
            "circle.grid.2x2", "square.grid.2x2", "rectangle.grid.2x2"
        ]),
        ("通用图标", [
            "star", "star.fill", "heart", "heart.fill",
            "bell", "bell.fill", "tag", "tag.fill",
            "flag", "flag.fill", "bookmark", "bookmark.fill",
            "checkmark.circle", "checkmark.circle.fill",
            "xmark.circle", "xmark.circle.fill",
            "plus.circle", "plus.circle.fill",
            "minus.circle", "minus.circle.fill"
        ])
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(iconCategories, id: \.0) { category, icons in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(category)
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(icons, id: \.self) { icon in
                                    Button {
                                        selectedIcon = icon
                                        dismiss()
                                    } label: {
                                        Image(systemName: icon)
                                            .font(.system(size: 24))
                                            .foregroundColor(icon == selectedIcon ? .accentColor : .primary)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(icon == selectedIcon ? 
                                                         Color(.systemGray6) : Color(.systemGray5))
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("选择图标")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}
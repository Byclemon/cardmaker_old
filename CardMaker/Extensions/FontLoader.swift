import SwiftUI
import CoreText

final class FontLoader {
    static let shared = FontLoader()
    private var loadedFonts: Set<String> = []
    private let queue = DispatchQueue(label: "com.cardmaker.fontloader", qos: .utility)
    
    private init() {}
    
    func preloadFonts(_ fonts: [String]) {
        queue.async {
            for fontName in fonts {
                self.loadFont(fontName)
            }
        }
    }
    
    private func loadFont(_ fontName: String) {
        guard !loadedFonts.contains(fontName),
              fontName != "PingFang SC" else { return }
        
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
//            print("找不到字体文件：\(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
        
        if let error = error?.takeRetainedValue() {
           print("注册字体失败 \(fontName): \(error)")
        } else {
//            print("成功注册字体：\(fontName)")
            loadedFonts.insert(fontName)
        }
    }
}

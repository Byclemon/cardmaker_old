import SwiftUI

// Color 编解码扩展
extension Color: Codable {
    struct ColorComponents: Codable {
        let red: Double
        let green: Double
        let blue: Double
        let opacity: Double
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let components = UIColor(self).rgba
        try container.encode(ColorComponents(
            red: components.red,
            green: components.green,
            blue: components.blue,
            opacity: components.alpha
        ))
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let components = try container.decode(ColorComponents.self)
        self = Color(
            .sRGB,
            red: components.red,
            green: components.green,
            blue: components.blue,
            opacity: components.opacity
        )
    }
}

// TextAlignment 编解码扩展
extension TextAlignment: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .leading:
            try container.encode("leading")
        case .center:
            try container.encode("center")
        case .trailing:
            try container.encode("trailing")
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        switch string {
        case "leading":
            self = .leading
        case "center":
            self = .center
        case "trailing":
            self = .trailing
        default:
            self = .leading
        }
    }
}

// UIColor RGBA 扩展
extension UIColor {
    var rgba: (red: Double, green: Double, blue: Double, alpha: Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Double(red), Double(green), Double(blue), Double(alpha))
    }
}
import Foundation

enum CardMakerError: LocalizedError {
    case sandboxRestriction
    case entitlementMissing
    case linkMetadataDecodingFailed
    case imageGenerationFailed
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .sandboxRestriction:
            return "沙盒权限受限"
        case .entitlementMissing:
            return "缺少所需权限"
        case .linkMetadataDecodingFailed:
            return "链接元数据解码失败"
        case .imageGenerationFailed:
            return "图片生成失败"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

enum ErrorManager {
    static func handle(_ error: Error) {
        let cardMakerError: CardMakerError
        
        switch error {
        case let error as NSError where error.domain == "RBSServiceErrorDomain":
            cardMakerError = .entitlementMissing
        case let error as NSError where error.domain == "NSCocoaErrorDomain" && error.code == 4099:
            cardMakerError = .sandboxRestriction
        case let error as NSError where error.domain == "NSCocoaErrorDomain" && error.code == 4864:
            cardMakerError = .linkMetadataDecodingFailed
        default:
            cardMakerError = .unknown(error)
        }
        
        #if DEBUG
        print("错误: \(cardMakerError.errorDescription ?? "未知错误")")
        print("详细信息: \(error)")
        #endif
    }
}
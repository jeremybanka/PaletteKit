public let CHANNEL_SPECIFIC_LUM = (
    R: UInt8(077),
    G: UInt8(127),
    B: UInt8(048)
)

public struct Hex {
    public var code: String
}

public struct RGB {
    var R: UInt8
    var G: UInt8
    var B: UInt8
}

public enum Affinity {
    case lum
    case sat
}

public struct HSL {
    public let hue: Double
    public let sat: UInt8
    public let lum: Double
}

public enum Channels {
    case r
    case g
    case b
}

public protocol SwatchProtocol {
    var hsl: HSL { get set }
    var affinity: Affinity { get set }
}

public class Swatch: SwatchProtocol {
    
    public var hsl: HSL
    public var affinity: Affinity
    
    public init(hsl: HSL, affinity: Affinity) {
        self.hsl = hsl
        self.affinity = affinity
    }
    
    public init(_ maybeHex: String) {
        let proto = hexToProtocol(maybeHex)
        
        self.hsl = proto.hsl
        self.affinity = proto.affinity
    }
}

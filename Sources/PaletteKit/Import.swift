import Foundation

public func hueFromChannels(_ channels: RGB) -> Double {
    let (R, G, B) = (Double(channels.R), Double(channels.G), Double(channels.B))
    var hue: Double = 0
    
    if R >  G && G >= B { hue = 60 * (0 + (G - B) / (R - B)) }
    if G >= R && R >  B { hue = 60 * (2 - (R - B) / (G - B)) }
    if G >  B && B >= R { hue = 60 * (2 + (B - R) / (G - R)) }
    if B >= G && G >  R { hue = 60 * (4 - (G - R) / (B - R)) }
    if B >  R && R >= G { hue = 60 * (4 + (R - G) / (B - G)) }
    if R >= B && B >  G { hue = 60 * (6 - (B - G) / (R - G)) }
    
    return hue
}

public func lumFromChannels(_ channels: RGB) -> Double {
    let (R, G, B) = (Double(channels.R), Double(channels.G), Double(channels.B))
    let rLum = R * Double(CHANNEL_SPECIFIC_LUM.R) / 255
    let gLum = G * Double(CHANNEL_SPECIFIC_LUM.G) / 255
    let bLum = B * Double(CHANNEL_SPECIFIC_LUM.B) / 255
    return rLum + gLum + bLum
}

public func satFromChannels(_ channels: RGB) -> UInt8 {
    let (R, G, B) = (channels.R, channels.G, channels.B)
    let sat = max(R, G, B) - min(R, G, B)
    return sat
}

public func channelsToSwatch(_ channels: RGB) -> SwatchProtocol {
    let hue = hueFromChannels(channels)
    let lum = lumFromChannels(channels)
    let sat = satFromChannels(channels)
    return Swatch(hsl: HSL(hue: hue, sat: sat, lum: lum), affinity: .lum)
}



func hexToRGB(maybeHex: String) -> RGB {
    do {
        let hex = try normalizeHex(maybeHex)
        
        let r = UInt8(hex.code.prefix(2), radix: 16) ?? 0
        let g = UInt8(hex.code.dropFirst(2).prefix(2), radix: 16) ?? 0
        let b = UInt8(hex.code.dropFirst(4).prefix(2), radix: 16) ?? 0
        
        return RGB(R: r, G: g, B: b)
    } catch {
        print("Invalid hex received.")
        return RGB(R: 0, G: 255, B: 255)
    }
}



func duplicateAllCharacters(_ str: String) -> String {
    var ssttrr = ""
    for char in str {
        ssttrr.append(String(char) + String(char))
    }
    return ssttrr
}

func normalizeHex(_ maybeHex: String) throws -> Hex {
    var hexcode = maybeHex.prefix(1) == "#" ? String(maybeHex.dropFirst(1)) : maybeHex
    let hexIsCorrectLength = hexcode.count == 6 || hexcode.count == 3
    let hexIsCorrectCharSet = NSString(string: hexcode).range(of: #"^[0-9A-Fa-f]+$"#, options: .regularExpression) != NSMakeRange(NSNotFound, 0)
    
    let hexIsValid = hexIsCorrectLength && hexIsCorrectCharSet
    if !hexIsValid {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "\(maybeHex) is not a valid hex code"])
    }
    if hexcode.count == 3 {
        hexcode = duplicateAllCharacters(hexcode)
    }
    return (Hex(code: hexcode))
}

func hexToProtocol(_ maybeHex: String) -> SwatchProtocol {
    return maybeHex |> hexToRGB |> channelsToSwatch
}


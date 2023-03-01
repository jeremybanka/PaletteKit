func clampInto<T: Comparable>(_ range: ClosedRange<T>) -> Modifier<T> {
    return { value in
        return min(max(value, range.lowerBound), range.upperBound)
    }
}

typealias SwatchApplicator<T> = Applicator<T, SwatchProtocol>

let setLum: SwatchApplicator<Double>
= { newLum in { currentColor in
    Swatch(
        hsl: HSL(
            hue: currentColor.hsl.hue,
            sat: currentColor.hsl.sat,
            lum: currentColor.hsl.lum |> become(newLum) |> clampInto(0...1)
        ),
        affinity: currentColor.affinity
    )
} }

let tintBy: (Double) -> Modifier<SwatchProtocol>
= { tintAmount in { color in
    color
//    |> resetColor
    |> setLum(.modifier({ lum in (lum * 100 + tintAmount) / 100 }))
} }


let shadeBy: (Double) -> Modifier<SwatchProtocol>
= { tintAmount in { color in
    color
//    |> resetCdolor
    |> setLum(.modifier({ lum in (lum * 100 - tintAmount) / 100 }))
} }

func tint(_ color: SwatchProtocol, _ tintAmount: Double) -> SwatchProtocol {
    return tintBy(tintAmount)(color)
}

func shade(_ color: SwatchProtocol, _ shadeAmount: Double) -> SwatchProtocol {
    return shadeBy(shadeAmount)(color)
}

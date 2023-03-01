import XCTest
@testable import PaletteKit

final class LuumTests: XCTestCase {
    func testImportHue() {
        XCTAssertEqual(hueFromChannels(RGB(R: 255, G: 0, B: 0)), 0)
    }
    
    func testCreateLuum() {
        XCTAssertEqual(Swatch("#f00").hsl.hue, 000)
        XCTAssertEqual(Swatch("#ff0").hsl.hue, 060)
        XCTAssertEqual(Swatch("#0f0").hsl.hue, 120)
        XCTAssertEqual(Swatch("#0ff").hsl.hue, 180)
        XCTAssertEqual(Swatch("#00f").hsl.hue, 240)
        XCTAssertEqual(Swatch("#f0f").hsl.hue, 300)
    }
}

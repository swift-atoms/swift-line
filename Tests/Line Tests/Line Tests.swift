import Line
import Testing
import Foundation

@Suite struct `Line parameterization contracts` {
    @Test func `Zero directions are rejected including negative floating zero`() {
        #expect(throws: Line<Int, Int>.ValidationError.zeroDirection) {
            try Line(point: 1, direction: 0)
        }
        #expect(throws: Line<Int, Double>.ValidationError.zeroDirection) {
            try Line(point: 1, direction: -0.0)
        }
    }

    @Test func `Anchors do not require coordinates or arithmetic`() throws {
        let line = try Line(point: "origin", direction: Duration.seconds(2))
        #expect(line.point == "origin")
        #expect(line.direction == .seconds(2))
        #expect(line.anchored(at: "elsewhere").point == "elsewhere")
        #expect(line.point == "origin")
    }

    @Test func `Equality distinguishes parameterizations of the same geometric line`() throws {
        let line = try Line(point: 0, direction: 2)
        #expect(line != line.anchored(at: 1))
        #expect(line != (try Line(point: 0, direction: 4)))
        #expect(line != (try Line(point: 0, direction: -2)))
        #expect(Set([line, line]).count == 1)
    }

    @Test(arguments: [-2, 0, 3])
    func `Evaluation permits both signs and preserves parameter scale`(_ parameter: Int) throws {
        let line = try Line(point: 10, direction: 2)
        let point = line.point(at: parameter) { anchor, direction, t in anchor + direction * t }
        #expect(point == 10 + 2 * parameter)
    }

    @Test func `Evaluation propagates the supplied typed failure`() throws {
        enum Failure: Error { case overflow }
        let line = try Line(point: 0, direction: 1)
        func evaluate(_ point: Int, _ direction: Int, _ parameter: Int) throws(Failure) -> Int {
            throw .overflow
        }
        #expect(throws: Failure.overflow) { try line.point(at: 1, using: evaluate) }
    }

    @Test func `Decoding cannot introduce a zero direction`() throws {
        let decoder = JSONDecoder()
        #expect(throws: DecodingError.self) {
            try decoder.decode(Line<Int, Int>.self, from: Data(#"{"point":1,"direction":0}"#.utf8))
        }
        let line = try Line(point: 3, direction: -2)
        #expect(try decoder.decode(Line<Int, Int>.self, from: JSONEncoder().encode(line)) == line)
    }
}

@Suite struct `Line independent coding conformances` {
    private struct EncodeOnly: Encodable { let value: Int }
    private struct DecodeOnly: Decodable { let value: Int }

    @Test func `Encoding does not require a decodable point`() throws {
        let line = try Line(point: EncodeOnly(value: 7), direction: 2)
        let data = try JSONEncoder().encode(line)
        let decoded = try JSONDecoder().decode(Line<DecodeOnly, Int>.self, from: data)
        #expect(decoded.point.value == 7)
        #expect(decoded.direction == 2)
    }

    @Test func `Decoding does not require an encodable point`() throws {
        let data = Data(#"{"point":{"value":9},"direction":-3}"#.utf8)
        let decoded = try JSONDecoder().decode(Line<DecodeOnly, Int>.self, from: data)
        #expect(decoded.point.value == 9)
        #expect(decoded.direction == -3)
    }
}

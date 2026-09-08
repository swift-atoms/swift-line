import Line
import Point
import Tagged
import Testing

@Suite struct `Lines of independently owned points` {
    private enum World {}

    @Test func `Three dimensional construction retains vector direction`() throws {
        let line = try Line(point: Point(x: 1, y: 2, z: 3), direction: Vector(x: 0, y: 2, z: 0))
        #expect(line.point == Point(x: 1, y: 2, z: 3))
        #expect(line.direction == Vector(x: 0, y: 2, z: 0))
        #expect(throws: Line<Point<3, Int>, Vector<3, Int>>.ValidationError.zeroDirection) {
            try Line(point: Point(x: 1, y: 2, z: 3), direction: Vector<3, Int>.zero)
        }
    }

    @Test func `Anchoring preserves the tagged point domain`() throws {
        typealias Position = Tagged<World, Point<2, Int>>
        let start = Position(_unchecked: Point(x: 1, y: 2))
        let end = Position(_unchecked: Point(x: 3, y: 4))
        let line = try Line(point: start, direction: Vector(x: 1, y: 0))
        let moved: Line<Position, Vector<2, Int>> = line.anchored(at: end)
        #expect(moved.point == end)
        #expect(moved.direction == line.direction)
    }
}

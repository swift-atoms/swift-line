public struct Line<Point, Displacement: AdditiveArithmetic> {
    public var point: Point
    public let direction: Displacement

    public enum ValidationError: Swift.Error, Equatable {
        case zeroDirection
    }

    public init(point: Point, direction: Displacement) throws(ValidationError) {
        guard direction != .zero else { throw .zeroDirection }
        self.point = point
        self.direction = direction
    }

    public func anchored(at point: Point) -> Self {
        var result = self
        result.point = point
        return result
    }

    public func point<Parameter, Failure: Swift.Error>(
        at parameter: Parameter,
        using evaluate: (Point, Displacement, Parameter) throws(Failure) -> Point
    ) throws(Failure) -> Point {
        try evaluate(point, direction, parameter)
    }
}

extension Line: Equatable where Point: Equatable {}
extension Line: Hashable where Point: Hashable, Displacement: Hashable {}
extension Line: Sendable where Point: Sendable, Displacement: Sendable {}

#if !hasFeature(Embedded)
extension Line {
    private enum CodingKeys: String, CodingKey { case point, direction }
}

extension Line: Encodable where Point: Encodable, Displacement: Encodable {}
extension Line: Decodable where Point: Decodable, Displacement: Decodable {
    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let point = try values.decode(Point.self, forKey: .point)
        let direction = try values.decode(Displacement.self, forKey: .direction)
        guard direction != .zero else {
            throw DecodingError.dataCorruptedError(
                forKey: .direction, in: values, debugDescription: "A line direction must be nonzero."
            )
        }
        self.point = point
        self.direction = direction
    }
}
#endif

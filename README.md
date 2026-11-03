# swift-line

Use this package when you need an infinite line through an anchor point with a nonzero direction, over any point and displacement types you bring (for example `Point` and `Vector` from swift-point, wrapped in `Tagged` if you like). Start from `Line<Point, Displacement>`. For a half-line that starts at its anchor, use Ray from swift-ray. For a bounded piece between two points, use Segment from swift-segment.

## Laws

- The direction is never zero. Both `Line.init(point:direction:)` and decoding reject it, and decoding reports the failure as a corrupted `direction` key. "Zero" means equal to `.zero`, so a floating-point `-0.0` is rejected too.
- A `Line` is a parameterization, not a set of points. Equality and hashing compare the anchor and the direction exactly. Two values that describe the same geometric line with a different anchor, a different direction length or the opposite direction sign are unequal.
- The direction cannot change after construction. `anchored(at:)` and assignment to `point` replace only the anchor, so the nonzero invariant always holds.
- The package does no arithmetic. `point(at:using:)` passes the anchor, the direction and the parameter to the caller's closure unchanged: the parameter is not normalized, and its sign is not restricted. Any failure the closure throws reaches the caller as it was thrown.
- Encoding uses the keys `point` and `direction`. Encoding and decoding are separate conformances, so each needs only its own capability from `Point` and `Displacement`.

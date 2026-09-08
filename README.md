# Line

An anchored, nonzero-direction line parameterization. Point and displacement are
independently owned types; production imports Swift only. The displacement must
satisfy AdditiveArithmetic's laws. No coordinates, dimension, metric, normalization,
or retroactive point conformance is imposed.

```swift
import Line

let line = try Line(point: 10, direction: 2)
let behind = line.point(at: -3) { point, direction, t in point + direction * t }
// behind == 4
```

Zero directions throw `ValidationError.zeroDirection`. Direction is immutable,
and decoding enforces the same invariant. Degenerate point-like curves should
use their own point or constant Bezier representation. Equality compares the
stored parameterization: different anchors or scaled directions are different
values even when an affine interpretation produces the same point set.

Evaluation takes an explicit operation and propagates its typed error. A valid
scalar action and affine translation are the caller's domain responsibility.
The generic representation does not assert finite coordinates or components;
domains requiring those guarantees must use validated point/displacement types.
IEEE infinity/NaN are not made into valid geometric directions by this wrapper.
Geometric equality, projection, intersection, metrics and normalization belong to
explicit relationships. No tolerance or platform mathematics is selected here.

Dependencies in the manifest are URL-only, and Point/Tagged are test integration
dependencies. Local resolution uses atoms.xcworkspace.

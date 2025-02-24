part of geojson_vi;

/// This class represents the geometry type MultiLineString according to the
/// GeoJSON specification.
///
/// A MultiLineString is composed of an array of LineString coordinate arrays.
class GeoJSONMultiLineString implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.multiLineString;

  /// The 'coordinates' member must be an array of LineString coordinate arrays.
  List<List<List<double>>> coordinates = [];

  @override
  double get area => 0.0;

  @override
  List<double> get bbox {
    final longitudes = coordinates
        .expand(
          (element) => element.expand(
            (element) => [element[0]],
          ),
        )
        .toList();
    final latitudes = coordinates
        .expand(
          (element) => element.expand(
            (element) => [element[1]],
          ),
        )
        .toList();
    longitudes.sort();
    latitudes.sort();

    return [
      longitudes.first,
      latitudes.first,
      longitudes.last,
      latitudes.last,
    ];
  }

  @override
  double get distance => 0.0;

  /// Creates a new GeoJSONMultiLineString object with the given [coordinates].
  ///
  /// The [coordinates] must represent one or more valid LineString coordinates.
  GeoJSONMultiLineString(this.coordinates)
      : assert(coordinates.isNotEmpty,
            'The coordinates MUST be one or more elements');

  /// Creates a new GeoJSONMultiLineString object from a map.
  ///
  /// The map must include a 'type' key with the value 'MultiLineString' and
  /// a 'coordinates' key with an array of linear ring coordinate arrays.
  factory GeoJSONMultiLineString.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(['MultiLineString'].contains(map['type']), 'Invalid type');
    assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`');
    assert(map['coordinates'] is List,
        'There MUST be array of linear ring coordinate arrays.');
    final llll = map['coordinates'];
    final coords = <List<List<double>>>[];
    llll.forEach((lll) {
      assert(lll is List, 'There MUST be List');
      final rings = <List<double>>[];
      lll.forEach((ll) {
        assert(ll is List, 'There MUST be List');
        assert((ll as List).length > 1, 'There MUST be two or more element');
        final pos = ll.map((e) => e.toDouble()).cast<double>().toList();
        rings.add(pos);
      });
      coords.add(rings);
    });
    return GeoJSONMultiLineString(coords);
  }

  /// Creates a new GeoJSONMultiLineString object from a JSON string.
  ///
  /// The JSON string must represent a valid GeoJSON MultiLineString object.
  factory GeoJSONMultiLineString.fromJSON(String source) =>
      GeoJSONMultiLineString.fromMap(json.decode(source));

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'coordinates': coordinates,
    };
  }

  @override
  String toJSON({int indent = 0}) {
    if (indent > 0) {
      return JsonEncoder.withIndent(' ' * indent).convert(toMap());
    } else {
      return json.encode(toMap());
    }
  }

  @override
  String toString() => 'MultiLineString($coordinates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeoJSONMultiLineString && other.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

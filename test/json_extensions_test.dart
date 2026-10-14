import 'dart:convert';

// Import every lib/src file to prove no `ambiguous_extension_member_access`.
// ignore_for_file: unused_import
import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> decode(String source) =>
    jsonDecode(source) as Map<String, dynamic>;

void main() {
  final empty = <String, dynamic>{};

  group('getString', () {
    final json = decode('{"name": "Ali", "id": 42, "pi": 3.5, "ok": true, '
        '"none": null, "list": [1], "obj": {}}');

    test('reads strings and converts num/bool', () {
      expect(json.getString('name'), 'Ali');
      expect(json.getString('id'), '42');
      expect(json.getString('pi'), '3.5');
      expect(json.getString('ok'), 'true');
    });

    test('null for missing, null, list and map', () {
      expect(json.getString('missing'), isNull);
      expect(json.getString('none'), isNull);
      expect(json.getString('list'), isNull);
      expect(json.getString('obj'), isNull);
      expect(empty.getString('x'), isNull);
    });

    test('getStringOr', () {
      expect(json.getStringOr('name', 'x'), 'Ali');
      expect(json.getStringOr('none', 'Guest'), 'Guest');
      expect(empty.getStringOr('x', ''), '');
    });
  });

  group('getInt', () {
    final json = decode('{"a": 25, "b": 25.0, "c": "25", "d": " 25 ", '
        '"e": "25.0", "f": 25.5, "g": "25.5", "h": "abc", "i": null, '
        '"j": true, "k": "-3", "l": [1]}');

    test('accepts int, whole double, numeric strings', () {
      expect(json.getInt('a'), 25);
      expect(json.getInt('b'), 25);
      expect(json.getInt('b'), isA<int>());
      expect(json.getInt('c'), 25);
      expect(json.getInt('d'), 25);
      expect(json.getInt('e'), 25);
      expect(json.getInt('k'), -3);
    });

    test('rejects fractional, non-numeric, bool, null, list, missing', () {
      expect(json.getInt('f'), isNull);
      expect(json.getInt('g'), isNull);
      expect(json.getInt('h'), isNull);
      expect(json.getInt('i'), isNull);
      expect(json.getInt('j'), isNull);
      expect(json.getInt('l'), isNull);
      expect(json.getInt('missing'), isNull);
      expect(<String, dynamic>{'x': double.nan}.getInt('x'), isNull);
      expect(<String, dynamic>{'x': double.infinity}.getInt('x'), isNull);
      expect(<String, dynamic>{'x': ''}.getInt('x'), isNull);
      expect(<String, dynamic>{'x': 1e300}.getInt('x'), isNull);
      expect(<String, dynamic>{'x': '1e300'}.getInt('x'), isNull);
    });

    test('getIntOr', () {
      expect(json.getIntOr('a', 0), 25);
      expect(json.getIntOr('h', 0), 0);
      expect(empty.getIntOr('x', -1), -1);
    });
  });

  group('getDouble / getNum', () {
    final json = decode('{"i": 10, "d": 9.99, "s": "1.5", "si": "7", '
        '"bad": "x", "nan": "NaN", "inf": "Infinity", "b": false}');

    test('getDouble', () {
      expect(json.getDouble('i'), 10.0);
      expect(json.getDouble('i'), isA<double>());
      expect(json.getDouble('d'), 9.99);
      expect(json.getDouble('s'), 1.5);
      expect(json.getDouble('si'), 7.0);
      expect(json.getDouble('bad'), isNull);
      expect(json.getDouble('nan'), isNull);
      expect(json.getDouble('inf'), isNull);
      expect(json.getDouble('b'), isNull);
      expect(json.getDouble('missing'), isNull);
      expect(json.getDoubleOr('bad', 0.5), 0.5);
      expect(json.getDoubleOr('d', 0), 9.99);
    });

    test('getNum keeps int vs double', () {
      expect(json.getNum('i'), isA<int>());
      expect(json.getNum('d'), 9.99);
      expect(json.getNum('s'), 1.5);
      expect(json.getNum('si'), isA<int>());
      expect(json.getNum('bad'), isNull);
      expect(json.getNumOr('bad', 0), 0);
      expect(empty.getNumOr('x', 1.5), 1.5);
    });
  });

  group('getBool', () {
    final json = decode('{"t": true, "f": false, "ts": "TRUE", "fs": "False", '
        '"one": 1, "zero": 0, "os": "1", "zs": " 0 ", "two": 2, '
        '"yes": "yes", "dbl": 1.0, "n": null}');

    test('accepts the documented forms', () {
      expect(json.getBool('t'), isTrue);
      expect(json.getBool('f'), isFalse);
      expect(json.getBool('ts'), isTrue);
      expect(json.getBool('fs'), isFalse);
      expect(json.getBool('one'), isTrue);
      expect(json.getBool('zero'), isFalse);
      expect(json.getBool('os'), isTrue);
      expect(json.getBool('zs'), isFalse);
      expect(json.getBool('dbl'), isTrue);
    });

    test('null for anything else', () {
      expect(json.getBool('two'), isNull);
      expect(json.getBool('yes'), isNull);
      expect(json.getBool('n'), isNull);
      expect(json.getBool('missing'), isNull);
    });

    test('getBoolOr', () {
      expect(json.getBoolOr('yes', false), isFalse);
      expect(json.getBoolOr('t', false), isTrue);
      expect(empty.getBoolOr('x', true), isTrue);
    });
  });

  group('getDateTime', () {
    final json = decode('{"iso": "2024-01-15T10:30:00Z", "date": "2024-01-15", '
        '"epoch": 0, "ms": 1705314600000, "bad": "not a date", "b": true, '
        '"huge": 1e300}');

    test('parses ISO-8601 strings', () {
      expect(json.getDateTime('iso'), DateTime.utc(2024, 1, 15, 10, 30));
      expect(json.getDateTime('date'), DateTime(2024, 1, 15));
    });

    test('treats ints as UTC epoch milliseconds', () {
      final epoch = json.getDateTime('epoch')!;
      expect(epoch.isUtc, isTrue);
      expect(epoch, DateTime.utc(1970));
      expect(json.getDateTime('ms'), DateTime.utc(2024, 1, 15, 10, 30));
    });

    test('null for invalid, wrong type, out of range, missing', () {
      expect(json.getDateTime('bad'), isNull);
      expect(json.getDateTime('b'), isNull);
      expect(json.getDateTime('huge'), isNull);
      expect(json.getDateTime('missing'), isNull);
    });

    test('getDateTimeOr', () {
      final fallback = DateTime(2000);
      expect(json.getDateTimeOr('bad', fallback), fallback);
      expect(json.getDateTimeOr('epoch', fallback), DateTime.utc(1970));
    });
  });

  group('getList / getMap', () {
    final json = decode('{"tags": ["a", 1, "b", null], "nums": [1, 2.5, 3], '
        '"user": {"id": 1, "address": {"city": "Lahore"}}, "str": "x", '
        '"emptyList": [], "emptyMap": {}}');

    test('getList filters by type', () {
      expect(json.getList<String>('tags'), ['a', 'b']);
      expect(json.getList<int>('nums'), [1, 3]);
      expect(json.getList<num>('nums'), [1, 2.5, 3]);
      expect(json.getList<dynamic>('tags'), ['a', 1, 'b', null]);
      expect(json.getList<String>('tags'), isA<List<String>>());
      expect(json.getList<String>('emptyList'), isEmpty);
      expect(json.getList<String>('str'), isNull);
      expect(json.getList<String>('missing'), isNull);
      expect(json.getListOr<String>('str', const []), isEmpty);
    });

    test('getList returns a new list', () {
      final list = json.getList<dynamic>('tags')!..add('z');
      expect(json.getList<dynamic>('tags'), hasLength(4));
      expect(list, hasLength(5));
    });

    test('getMap reads nested decoded maps and chains', () {
      final user = json.getMap('user');
      expect(user, isNotNull);
      expect(user!.getInt('id'), 1);
      expect(user.getMap('address')?.getString('city'), 'Lahore');
      expect(json.getMap('emptyMap'), isEmpty);
      expect(json.getMap('str'), isNull);
      expect(json.getMap('missing'), isNull);
      expect(json.getMapOr('missing', const {}), isEmpty);
    });

    test('getMap converts non-string keys', () {
      final raw = <String, dynamic>{
        'm': <dynamic, dynamic>{1: 'one', 'two': 2},
      };
      final m = raw.getMap('m')!;
      expect(m, isA<Map<String, dynamic>>());
      expect(m, {'1': 'one', 'two': 2});
    });
  });

  group('getPath', () {
    final json = decode('{"user": {"address": {"city": "Lahore"}, '
        '"nick": null}, "items": [{"name": "A"}, {"name": "B"}], '
        '"matrix": [[1, 2], [3, 4]]}');

    test('walks maps and lists', () {
      expect(json.getPath('user.address.city'), 'Lahore');
      expect(json.getPath('items.1.name'), 'B');
      expect(json.getPath('matrix.1.0'), 3);
      expect(json.getPath('user'), isA<Map>());
    });

    test('null for missing, out of range, bad index, scalar walk', () {
      expect(json.getPath('user.phone'), isNull);
      expect(json.getPath('user.nick'), isNull);
      expect(json.getPath('items.5.name'), isNull);
      expect(json.getPath('items.-1'), isNull);
      expect(json.getPath('items.first'), isNull);
      expect(json.getPath('user.address.city.x'), isNull);
      expect(json.getPath(''), isNull);
      expect(empty.getPath('a.b'), isNull);
    });
  });

  group('removeNulls', () {
    final json = decode('{"a": 1, "b": null, "c": {"d": null, "e": 2}, '
        '"f": [1, null, {"g": null, "h": 3}]}');

    test('shallow keeps nested nulls', () {
      final result = json.removeNulls();
      expect(result.keys, ['a', 'c', 'f']);
      expect(result['c'], {'d': null, 'e': 2});
    });

    test('deep cleans nested maps and lists', () {
      expect(json.removeNulls(deep: true), {
        'a': 1,
        'c': {'e': 2},
        'f': [
          1,
          {'h': 3},
        ],
      });
    });

    test('does not mutate the original and handles empty', () {
      json.removeNulls(deep: true);
      expect(json.containsKey('b'), isTrue);
      expect(empty.removeNulls(), isEmpty);
    });
  });

  group('toQueryString', () {
    test('encodes keys and values, skips nulls, repeats lists', () {
      final query = <String, dynamic>{
        'q': 'a b&c',
        'page': 2,
        'skip': null,
        'tag': ['x', null, 'y'],
        'ünï': 'é',
      }.toQueryString();
      expect(query, 'q=a+b%26c&page=2&tag=x&tag=y&%C3%BCn%C3%AF=%C3%A9');
      expect(Uri.splitQueryString(query)['q'], 'a b&c');
    });

    test('empty map gives empty string', () {
      expect(empty.toQueryString(), '');
    });
  });

  test('works on Map<String, Object?> too', () {
    final Map<String, Object?> json = {'age': '30', 'tags': null};
    expect(json.getInt('age'), 30);
    expect(json.removeNulls(), {'age': '30'});
  });

  test('no extension conflicts with every lib/src file imported', () {
    final json = decode('{"a": "1", "b": null, "c": {"d": 2}}');
    // JSON members.
    expect(json.getInt('a'), 1);
    expect(json.getIntOr('b', 0), 0);
    expect(json.getStringOr('a', ''), '1');
    expect(json.getDouble('a'), 1.0);
    expect(json.getNum('a'), 1);
    expect(json.getBool('a'), isTrue);
    expect(json.getDateTime('b'), isNull);
    expect(json.getList<int>('b'), isNull);
    expect(json.getMap('c')?.getInt('d'), 2);
    expect(json.getPath('c.d'), 2);
    expect(json.removeNulls(deep: true), hasLength(2));
    expect(json.toQueryString(), 'a=1&c=%7Bd%3A+2%7D');
    // Members from map/nullable extensions and core Map still resolve.
    expect(json.filter((k, v) => v != null), hasLength(2));
    expect(json.isNotNullOrEmpty, isTrue);
  });
}

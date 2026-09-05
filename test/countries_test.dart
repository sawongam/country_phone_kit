import 'package:country_phone_kit/country_phone_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the table', () {
    test('is not empty and is sorted by name', () {
      expect(Countries.all, isNotEmpty);

      final names = Countries.all.map((country) => country.name).toList();
      expect(names, orderedEquals([...names]..sort()));
    });

    test('has one row per ISO alpha-2 code', () {
      final codes = Countries.all.map((country) => country.isoCode).toSet();
      expect(codes, hasLength(Countries.all.length));
    });

    test('every row is complete enough to render and dial', () {
      for (final country in Countries.all) {
        expect(country.name, isNotEmpty, reason: country.isoCode);
        expect(country.isoCode, hasLength(2), reason: country.isoCode);
        expect(country.dialCode, isNotEmpty, reason: country.isoCode);
        expect(
          country.dialCode,
          isNot(startsWith('+')),
          reason: '${country.isoCode}: dialCode is stored without its +',
        );
        expect(country.dialCodePrefix, startsWith('+'));
        // A flag is a regional-indicator pair: two surrogate pairs.
        expect(country.flag.runes, hasLength(2), reason: country.isoCode);
        expect(country.minLength, greaterThan(0), reason: country.isoCode);
        expect(
          country.maxLength,
          greaterThanOrEqualTo(country.minLength),
          reason: country.isoCode,
        );
        expect(country.iso3Code, anyOf(isNull, hasLength(3)));
      }
    });

    test('Antarctica is the only country with no currency', () {
      final without = Countries.all
          .where((country) => country.currency == null)
          .map((country) => country.isoCode);
      expect(without, ['AQ']);
    });
  });

  group('byIsoCode', () {
    test('is case-insensitive and null-tolerant', () {
      expect(Countries.byIsoCode('NP')?.name, 'Nepal');
      expect(Countries.byIsoCode('np')?.name, 'Nepal');
      expect(Countries.byIsoCode(null), isNull);
      expect(Countries.byIsoCode('ZZ'), isNull);
    });
  });

  group('dial codes', () {
    test('byDialCode returns every country sharing the code', () {
      final onePlus = Countries.byDialCode('1').map((c) => c.isoCode);
      expect(onePlus, containsAll(['US', 'CA']));
      expect(Countries.byDialCode('+977').single.isoCode, 'NP');
      expect(Countries.byDialCode('99999'), isEmpty);
    });

    test('primaryForDialCode resolves a shared code to one country', () {
      expect(Countries.primaryForDialCode('1')?.isoCode, 'US');
      expect(Countries.primaryForDialCode('+1')?.isoCode, 'US');
      expect(Countries.primaryForDialCode('7')?.isoCode, 'RU');
      expect(Countries.primaryForDialCode('99999'), isNull);
    });

    test('longestDialCodePrefix prefers the longer code', () {
      // 977 (Nepal) must win over 97, which is nobody's code on its own.
      expect(Countries.longestDialCodePrefix('9779812345678'), '977');
      expect(Countries.longestDialCodePrefix('12025550100'), '1');
      expect(Countries.longestDialCodePrefix('0000000'), isNull);
    });
  });

  group('search', () {
    test('empty query returns the whole list unchanged', () {
      expect(Countries.search('   '), same(Countries.all));
    });

    test('ranks an exact ISO or dial-code hit first', () {
      expect(Countries.search('np').first.isoCode, 'NP');
      expect(Countries.search('977').first.isoCode, 'NP');
      expect(Countries.search('+977').first.isoCode, 'NP');
    });

    test(
      'ranks a name that starts with the query above one that contains it',
      () {
        final results = Countries.search('in').map((c) => c.isoCode).toList();
        expect(results.indexOf('IN'), lessThan(results.indexOf('FI')));
      },
    );

    test('matches by name, case-insensitively', () {
      expect(Countries.search('NEPAL').single.isoCode, 'NP');
    });

    test('returns nothing for a query no country matches', () {
      expect(Countries.search('qqqqqq'), isEmpty);
    });
  });

  group('Country', () {
    test('equality is by ISO code', () {
      expect(Countries.byIsoCode('NP'), equals(Countries.byIsoCode('np')));
      expect(
        Countries.byIsoCode('NP'),
        isNot(equals(Countries.byIsoCode('IN'))),
      );
    });

    test('matchesQuery covers name, both ISO codes and the dial code', () {
      final nepal = Countries.byIsoCode('NP')!;
      expect(nepal.matchesQuery('nep'), isTrue);
      expect(nepal.matchesQuery('np'), isTrue);
      expect(nepal.matchesQuery('npl'), isTrue);
      expect(nepal.matchesQuery('977'), isTrue);
      expect(nepal.matchesQuery('+97'), isTrue);
      expect(nepal.matchesQuery('france'), isFalse);
    });
  });
}

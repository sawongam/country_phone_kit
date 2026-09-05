import 'package:country_phone_kit/country_phone_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the table', () {
    test('holds every currency exactly once, in code order', () {
      expect(Currencies.all, isNotEmpty);

      final codes = Currencies.all.map((currency) => currency.code).toList();
      expect(codes.toSet(), hasLength(codes.length));
      expect(codes, orderedEquals([...codes]..sort()));
    });

    test('is deduplicated — the euro appears once, not 28 times', () {
      final euros = Currencies.all.where((c) => c.code == 'EUR');
      expect(euros, hasLength(1));
      expect(Currencies.countriesUsing('EUR').length, greaterThan(20));
    });

    test('covers every currency the country table names', () {
      final fromCountries = {
        for (final country in Countries.all)
          if (country.currency != null) country.currency!.code,
      };
      final fromCurrencies = Currencies.all.map((c) => c.code).toSet();
      expect(fromCurrencies, fromCountries);
    });

    test('every row is complete enough to render', () {
      for (final currency in Currencies.all) {
        expect(currency.code, hasLength(3), reason: currency.code);
        expect(currency.name, isNotEmpty, reason: currency.code);
        expect(currency.symbol, isNotEmpty, reason: currency.code);
      }
    });

    test('carries no currency the euro area retired', () {
      // Upstream data still had these; the generator's override table fixes
      // them. Two even carried `€` against the old code, so a currency picker
      // offered three different currencies all symbolised the same way.
      for (final code in ['CYP', 'MTL', 'SKK', 'EEK', 'LVL', 'LTL', 'HRK']) {
        expect(Currencies.byCode(code), isNull, reason: code);
      }
      for (final iso in ['CY', 'MT', 'SK', 'EE', 'LV', 'LT', 'HR']) {
        expect(Currencies.forCountry(iso)?.code, 'EUR', reason: iso);
      }
    });

    test('carries no ISO-4217 code that was redenominated away', () {
      // Each of these was replaced by the code beside it. Shipping the old one
      // hands a backend a code no payment processor will accept.
      const retired = {
        'GHC': 'GHS',
        'SDD': 'SDG',
        'TMM': 'TMT',
        'ZMK': 'ZMW',
        'MRO': 'MRU',
        'STD': 'STN',
        'VEF': 'VES',
        'SLL': 'SLE',
        'ZWD': 'ZWG',
      };
      for (final entry in retired.entries) {
        expect(Currencies.byCode(entry.key), isNull, reason: entry.key);
        expect(Currencies.byCode(entry.value), isNotNull, reason: entry.value);
      }
    });

    test('every name says which currency it is', () {
      // A picker row reading "Dollar" or "Franc" tells the user nothing. The
      // euro is the one currency whose bare name is unambiguous.
      final bare = Currencies.all
          .where((c) => !c.name.contains(' ') && c.code != 'EUR')
          .map((c) => '${c.code} "${c.name}"');
      expect(bare, isEmpty);
    });

    test('one currency per symbol where the symbol is unique to it', () {
      // `$` and `£` are genuinely shared; `€` is not, and a second currency
      // claiming it means the table has gone stale again.
      final euroish = Currencies.all.where((c) => c.symbol == '€');
      expect(euroish.map((c) => c.code), ['EUR']);
    });

    test('is unmodifiable', () {
      expect(
        () => Currencies.all.add(
          const CountryCurrency(code: 'XXX', name: 'x', symbol: 'x'),
        ),
        throwsUnsupportedError,
      );
    });
  });

  group('lookups', () {
    test('byCode is case-insensitive and null-tolerant', () {
      expect(Currencies.byCode('NPR')?.name, 'Nepalese rupee');
      expect(Currencies.byCode('npr')?.symbol, isNotEmpty);
      expect(Currencies.byCode(null), isNull);
      expect(Currencies.byCode('ZZZ'), isNull);
    });

    test('forCountry answers with what that country spends', () {
      expect(Currencies.forCountry('NP')?.code, 'NPR');
      expect(Currencies.forCountry('de')?.code, 'EUR');
      // Antarctica has no currency of its own, and no country is 'ZZ'.
      expect(Currencies.forCountry('AQ'), isNull);
      expect(Currencies.forCountry('ZZ'), isNull);
    });

    test('countriesUsing turns a code back into countries', () {
      expect(Currencies.countriesUsing('NPR').single.isoCode, 'NP');
      expect(
        Currencies.countriesUsing('eur').map((c) => c.isoCode),
        containsAll(['DE', 'FR', 'IE']),
      );
      expect(Currencies.countriesUsing('ZZZ'), isEmpty);
    });
  });

  group('search', () {
    test('empty query returns the whole list unchanged', () {
      expect(Currencies.search('  '), same(Currencies.all));
    });

    test('ranks an exact code hit first', () {
      expect(Currencies.search('usd').first.code, 'USD');
      expect(Currencies.search('USD').first.code, 'USD');
      // 'us' is not a code, but USD starts with it — above AUD, which merely
      // contains it.
      final loose = Currencies.search('us').map((c) => c.code).toList();
      expect(loose.indexOf('USD'), lessThan(loose.indexOf('AUD')));
    });

    test('matches on name and on symbol', () {
      expect(
        Currencies.search('rupee').map((c) => c.code),
        containsAll(['NPR', 'INR']),
      );
      expect(Currencies.search('€').single.code, 'EUR');
    });

    test('returns nothing for a query no currency matches', () {
      expect(Currencies.search('qqqqqq'), isEmpty);
    });
  });

  group('CountryCurrency', () {
    test('equality is by code', () {
      expect(Currencies.byCode('EUR'), Currencies.forCountry('DE'));
      expect(Currencies.byCode('EUR'), isNot(Currencies.byCode('USD')));
    });

    test('matchesQuery covers code, name and symbol', () {
      final npr = Currencies.byCode('NPR')!;
      expect(npr.matchesQuery('npr'), isTrue);
      expect(npr.matchesQuery('nepalese'), isTrue);
      expect(npr.matchesQuery('rupee'), isTrue);
      expect(npr.matchesQuery('euro'), isFalse);
    });
  });
}

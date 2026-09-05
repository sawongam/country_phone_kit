import 'package:country_phone_kit/country_phone_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final nepal = Countries.byIsoCode('NP')!;
  final us = Countries.byIsoCode('US')!;

  group('parse', () {
    test('reads a national number against the fallback country', () {
      final number = PhoneNumber.parse('9812345678', fallbackCountry: nepal);
      expect(number.country, nepal);
      expect(number.nationalNumber, '9812345678');
    });

    test('drops separators', () {
      final number = PhoneNumber.parse(
        '(981) 234-5678',
        fallbackCountry: nepal,
      );
      expect(number.nationalNumber, '9812345678');
    });

    test('drops the trunk 0', () {
      final number = PhoneNumber.parse('09812345678', fallbackCountry: nepal);
      expect(number.nationalNumber, '9812345678');
    });

    test('resolves the country from a + dial code', () {
      final number = PhoneNumber.parse('+9779812345678', fallbackCountry: us);
      expect(number.country, nepal);
      expect(number.nationalNumber, '9812345678');
    });

    test('treats 00 as an international prefix', () {
      final number = PhoneNumber.parse('009779812345678', fallbackCountry: us);
      expect(number.country, nepal);
      expect(number.nationalNumber, '9812345678');
    });

    test('keeps the digits when the dial code is unknown', () {
      final number = PhoneNumber.parse('+99999123', fallbackCountry: nepal);
      expect(number.country, nepal);
      expect(number.nationalNumber, '99999123');
    });

    test('empty input yields an empty number on the fallback country', () {
      final number = PhoneNumber.parse('  ', fallbackCountry: nepal);
      expect(number.country, nepal);
      expect(number.nationalNumber, isEmpty);
      expect(number.isEmpty, isTrue);
      expect(number.e164, isEmpty);
    });
  });

  group('validation', () {
    test('accepts a real number', () {
      expect(
        PhoneNumber.parse('9812345678', fallbackCountry: nepal).isValid,
        isTrue,
      );
      expect(
        PhoneNumber.parse('2025550100', fallbackCountry: us).isValid,
        isTrue,
      );
    });

    test('is a metadata verdict, not a length check', () {
      // Ten digits — the right length for Nepal — but no carrier issues 111…
      final number = PhoneNumber.parse('1112223333', fallbackCountry: nepal);
      expect(number.nationalNumber, hasLength(10));
      expect(number.isValid, isFalse);
      expect(number.error, PhoneNumberError.invalid);
    });

    test('reports empty, tooShort and tooLong apart from invalid', () {
      expect(PhoneNumber(country: nepal).error, PhoneNumberError.empty);
      expect(
        PhoneNumber.parse('98', fallbackCountry: nepal).error,
        PhoneNumberError.tooShort,
      );
      expect(
        PhoneNumber.parse('98123456789012', fallbackCountry: nepal).error,
        PhoneNumberError.tooLong,
      );
    });

    test('a half-typed number never throws', () {
      for (var i = 1; i <= 10; i++) {
        final typed = '9812345678'.substring(0, i);
        expect(
          () => PhoneNumber.parse(typed, fallbackCountry: nepal).error,
          returnsNormally,
          reason: typed,
        );
      }
    });
  });

  group('formatting', () {
    test('e164 joins the dial code and the national number', () {
      final number = PhoneNumber.parse('9812345678', fallbackCountry: nepal);
      expect(number.e164, '+9779812345678');
    });

    test('e164 is empty for an untouched field', () {
      expect(PhoneNumber(country: nepal).e164, isEmpty);
    });

    test('groups the way the country writes it', () {
      final american = PhoneNumber.parse('2025550100', fallbackCountry: us);
      expect(american.formatNational, contains('202'));
      expect(american.formatNational, isNot(equals(american.nationalNumber)));
      expect(american.formatInternational, startsWith('+1'));
    });

    test('falls back to raw digits while the number is incomplete', () {
      final number = PhoneNumber.parse('98', fallbackCountry: nepal);
      expect(number.formatNational, isNotEmpty);
    });
  });

  group('copyWith', () {
    test('changing country keeps the digits typed so far', () {
      final number = PhoneNumber.parse('9812345678', fallbackCountry: nepal);
      final moved = number.copyWithCountry(us);
      expect(moved.country, us);
      expect(moved.nationalNumber, '9812345678');
    });

    test('changing the number cleans what the field hands over', () {
      final number = PhoneNumber(country: nepal)
          .copyWithNationalNumber('0 (981) 234-5678');
      expect(number.nationalNumber, '9812345678');
    });
  });

  group('one-line helpers', () {
    test('isValidNumber checks against a named country', () {
      expect(PhoneNumber.isValidNumber('9812345678', isoCode: 'NP'), isTrue);
      expect(PhoneNumber.isValidNumber('9812345678', isoCode: 'np'), isTrue);
      expect(PhoneNumber.isValidNumber('1112223333', isoCode: 'NP'), isFalse);
      expect(PhoneNumber.isValidNumber('9812345678', isoCode: 'ZZ'), isFalse);
    });

    test('isValidNumber reads the country off an international number', () {
      expect(PhoneNumber.isValidNumber('+977 981 234 5678'), isTrue);
      expect(PhoneNumber.isValidNumber('00977 9812345678'), isTrue);
    });

    test('a bare national number with no country is not guessed', () {
      // 98 is Iran's dial code; answering for Iran here would be worse than
      // answering nothing.
      expect(PhoneNumber.isValidNumber('9812345678'), isFalse);
      expect(PhoneNumber.formatE164('9812345678'), isNull);
    });

    test('formatE164 returns the wire format, or null when invalid', () {
      expect(
        PhoneNumber.formatE164('(981) 234-5678', isoCode: 'NP'),
        '+9779812345678',
      );
      expect(PhoneNumber.formatE164('+977 9812345678'), '+9779812345678');
      expect(PhoneNumber.formatE164('98', isoCode: 'NP'), isNull);
      expect(PhoneNumber.formatE164('', isoCode: 'NP'), isNull);
    });
  });

  group('value semantics', () {
    test('equal on country and national number', () {
      expect(
        PhoneNumber(country: nepal, nationalNumber: '9812345678'),
        PhoneNumber.parse('+9779812345678', fallbackCountry: us),
      );
      expect(
        PhoneNumber(country: nepal, nationalNumber: '9812345678').hashCode,
        PhoneNumber(country: nepal, nationalNumber: '9812345678').hashCode,
      );
      expect(
        PhoneNumber(country: nepal, nationalNumber: '9812345678'),
        isNot(PhoneNumber(country: us, nationalNumber: '9812345678')),
      );
    });
  });
}

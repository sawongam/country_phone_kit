import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_phone_kit/country_phone_kit.dart';

void main() => runApp(const CountryPhoneKitExampleApp());

/// Seed is pine, not the Material default purple, so the widgets' Theme
/// pickup is obvious when you flip light and dark.
const _seed = Color(0xFF1F4E46);

class CountryPhoneKitExampleApp extends StatefulWidget {
  const CountryPhoneKitExampleApp({super.key});

  @override
  State<CountryPhoneKitExampleApp> createState() =>
      _CountryPhoneKitExampleAppState();
}

class _CountryPhoneKitExampleAppState extends State<CountryPhoneKitExampleApp> {
  ThemeMode _mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'country_phone_kit',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: GalleryPage(
        themeMode: _mode,
        onThemeMode: (mode) => setState(() => _mode = mode),
      ),
    );
  }
}

ThemeData _theme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);

  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
    ),
  );
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({
    required this.themeMode,
    required this.onThemeMode,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeMode;

  /// Whether the app is currently painting dark, whichever way it got there.
  bool _isDark(BuildContext context) => switch (themeMode) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = _isDark(context);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: scheme.surface,
            title: const Text('country_phone_kit'),
            actions: [
              IconButton(
                tooltip: dark ? 'Switch to light' : 'Switch to dark',
                icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () =>
                    onThemeMode(dark ? ThemeMode.light : ThemeMode.dark),
              ),
              const SizedBox(width: 4),
            ],
          ),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DataDemo(),
                      SizedBox(height: 20),
                      _PhoneFieldDemo(),
                      SizedBox(height: 20),
                      _CountryPickerDemo(),
                      SizedBox(height: 20),
                      _CurrencyPickerDemo(),
                      SizedBox(height: 20),
                      _ParseDemo(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The package with no widgets of its own involved: the country table read
/// straight off [Countries], and a one-line validity check.
class _DataDemo extends StatefulWidget {
  const _DataDemo();

  @override
  State<_DataDemo> createState() => _DataDemoState();
}

class _DataDemoState extends State<_DataDemo> {
  final _iso = TextEditingController(text: 'NP');
  final _number = TextEditingController(text: '9812345678');

  @override
  void dispose() {
    _iso.dispose();
    _number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final iso = _iso.text.trim();
    final country = Countries.byIsoCode(iso);
    final input = _number.text;
    final valid = PhoneNumber.isValidNumber(input, isoCode: iso);
    final e164 = PhoneNumber.formatE164(input, isoCode: iso);

    return _DemoCard(
      kicker: 'Countries · PhoneNumber',
      title: 'Just the data',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'No widget from this package is on screen in this card. '
            'Everything below is read straight off the const table.',
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(
                label: 'Countries.all',
                value: '${Countries.all.length}',
              ),
              _MetaChip(
                label: '+1',
                value: '${Countries.byDialCode('1').length} countries',
              ),
              _MetaChip(
                label: 'primary +1',
                value: Countries.primaryForDialCode('1')!.isoCode,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 92,
                child: TextField(
                  controller: _iso,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 2,
                  decoration: const InputDecoration(
                    labelText: 'ISO',
                    counterText: '',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _number,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Number'),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                fontFeatures: [FontFeature.tabularFigures()],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(
                    "Countries.byIsoCode('$iso')",
                    country == null
                        ? 'null'
                        : '${country.flag} ${country.name} '
                              '${country.dialCodePrefix}',
                  ),
                  _line(
                    'isValidNumber',
                    '$valid',
                    color: valid ? scheme.primary : scheme.error,
                  ),
                  _line('formatE164', e164 ?? 'null'),
                  if (country?.currency case final currency?)
                    _line(
                      'currency',
                      '${currency.code}  ${currency.symbol}  ${currency.name}',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String key, String value, {Color? color}) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 168,
            child: Text(
              key,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(color: color, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.kicker,
    required this.title,
    required this.child,
  });

  final String kicker;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Material(
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              kicker.toUpperCase(),
              style: text.labelSmall?.copyWith(
                color: scheme.primary,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: text.titleLarge),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _PhoneFieldDemo extends StatefulWidget {
  const _PhoneFieldDemo();

  @override
  State<_PhoneFieldDemo> createState() => _PhoneFieldDemoState();
}

class _PhoneFieldDemoState extends State<_PhoneFieldDemo> {
  late PhoneNumber _phone = PhoneNumber(country: Countries.byIsoCode('NP')!);
  bool _submitted = false;
  bool _enabled = true;

  static const _labels = CountryPickerLabels(
    title: 'Select country',
    searchHint: 'Search country or code',
    clearSearchTooltip: 'Clear search',
    emptyTitle: 'No match',
    emptyMessage: 'No country matches that name or dialling code.',
  );

  String? get _errorText {
    if (!_submitted && _phone.isEmpty) return null;
    return switch (_phone.error) {
      PhoneNumberError.empty => 'Enter a phone number',
      PhoneNumberError.tooShort => 'That number is too short',
      PhoneNumberError.tooLong => 'That number is too long',
      PhoneNumberError.invalid => 'Not a valid number for this country',
      null => null,
    };
  }

  void _submit() {
    setState(() => _submitted = true);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    if (_phone.isValid) {
      messenger.showSnackBar(
        SnackBar(content: Text('Would send ${_phone.e164}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      kicker: 'PhoneNumberField',
      title: 'Type a number',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PhoneNumberField(
            value: _phone,
            enabled: _enabled,
            required: true,
            label: 'Mobile',
            hintText: 'National number',
            errorText: _errorText,
            textInputAction: TextInputAction.done,
            pickerLabels: _labels,
            onChanged: (number) => setState(() => _phone = number),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Enabled'),
                selected: _enabled,
                onSelected: (value) => setState(() => _enabled = value),
              ),
              ActionChip(
                avatar: const Icon(Icons.south_east, size: 16),
                label: const Text('Fill Nepal sample'),
                onPressed: () => setState(() {
                  _submitted = false;
                  _phone = PhoneNumber.parse(
                    '+9779812345678',
                    fallbackCountry: Countries.byIsoCode('NP')!,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ValueBoard(phone: _phone),
          const SizedBox(height: 16),
          FilledButton(onPressed: _submit, child: const Text('Validate')),
        ],
      ),
    );
  }
}

class _ValueBoard extends StatelessWidget {
  const _ValueBoard({required this.phone});

  final PhoneNumber phone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final valid = phone.isValid;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                valid ? Icons.check_circle_outline : Icons.hourglass_empty,
                size: 18,
                color: valid ? scheme.primary : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                valid ? 'Valid' : (phone.error?.name ?? 'empty'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _kv('Country', '${phone.country.flag}  ${phone.country.name}'),
          _kv('ISO', phone.country.isoCode),
          _kv(
            'National',
            phone.nationalNumber.isEmpty ? '—' : phone.nationalNumber,
          ),
          _kv('Grouped', phone.isEmpty ? '—' : phone.formatNational),
          _kv('E.164', phone.e164.isEmpty ? '—' : phone.e164),
        ],
      ),
    );
  }

  Widget _kv(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              key,
              style: const TextStyle(
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryPickerDemo extends StatefulWidget {
  const _CountryPickerDemo();

  @override
  State<_CountryPickerDemo> createState() => _CountryPickerDemoState();
}

class _CountryPickerDemoState extends State<_CountryPickerDemo> {
  Country _country = Countries.byIsoCode('NP')!;

  Future<void> _openSheet() async {
    final picked = await showCountryPicker(
      context: context,
      selected: _country,
    );
    if (picked == null || !mounted) return;
    setState(() => _country = picked);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final currency = _country.currency;

    return _DemoCard(
      kicker: 'showCountryPicker',
      title: 'Pick a country',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: scheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: scheme.outlineVariant),
            ),
            child: InkWell(
              onTap: _openSheet,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    CountryFlag(_country.flag, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _country.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${_country.isoCode}  ${_country.dialCodePrefix}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.unfold_more, color: scheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(label: 'Dial', value: _country.dialCodePrefix),
              _MetaChip(
                label: 'Digits',
                value: _country.minLength == _country.maxLength
                    ? '${_country.minLength}'
                    : '${_country.minLength}–${_country.maxLength}',
              ),
              if (currency != null)
                _MetaChip(
                  label: 'Currency',
                  value: '${currency.symbol} ${currency.code}',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label  ',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _CurrencyPickerDemo extends StatefulWidget {
  const _CurrencyPickerDemo();

  @override
  State<_CurrencyPickerDemo> createState() => _CurrencyPickerDemoState();
}

class _CurrencyPickerDemoState extends State<_CurrencyPickerDemo> {
  CountryCurrency _currency = Currencies.byCode('NPR')!;

  Future<void> _openSheet() async {
    final picked = await showCurrencyPicker(
      context: context,
      selected: _currency,
    );
    if (picked == null || !mounted) return;
    setState(() => _currency = picked);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final users = Currencies.countriesUsing(_currency.code);

    return _DemoCard(
      kicker: 'showCurrencyPicker',
      title: 'Pick a currency',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: scheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: scheme.outlineVariant),
            ),
            child: InkWell(
              onTap: _openSheet,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(
                          _currency.symbol,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_currency.name, style: text.titleMedium),
                          Text(
                            _currency.code,
                            style: text.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.unfold_more, color: scheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            users.length == 1
                ? 'Currencies.countriesUsing — one country'
                : 'Currencies.countriesUsing — ${users.length} countries',
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          // The other direction: a currency code back to the countries that
          // spend it. Twenty-eight of them, for the euro.
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final country in users.take(12))
                Tooltip(
                  message: country.name,
                  child: Text(
                    country.flag,
                    style: const TextStyle(fontSize: 20, height: 1),
                  ),
                ),
              if (users.length > 12)
                Text(
                  '+${users.length - 12}',
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParseDemo extends StatefulWidget {
  const _ParseDemo();

  @override
  State<_ParseDemo> createState() => _ParseDemoState();
}

class _ParseDemoState extends State<_ParseDemo> {
  final _controller = TextEditingController(text: '+1 (202) 555-0100');
  late PhoneNumber _parsed = PhoneNumber.parse(
    _controller.text,
    fallbackCountry: Countries.byIsoCode('US')!,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _parse(String raw) {
    setState(() {
      _parsed = PhoneNumber.parse(
        raw,
        fallbackCountry: Countries.byIsoCode('US')!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      kicker: 'PhoneNumber.parse',
      title: 'Paste any format',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d+\s\-().]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Raw input',
              hintText: '+977 098-1234-5678',
            ),
            onChanged: _parse,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final sample in const [
                '+977 098-1234-5678',
                '00 44 20 7946 0958',
                '(202) 555-0100',
              ])
                ActionChip(
                  label: Text(sample, style: const TextStyle(fontSize: 12)),
                  onPressed: () {
                    _controller.text = sample;
                    _parse(sample);
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          _ValueBoard(phone: _parsed),
        ],
      ),
    );
  }
}

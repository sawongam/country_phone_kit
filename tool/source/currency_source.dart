// Raw currency and ISO-3166-1 alpha-3 data, keyed by alpha-2 code.
//
// GENERATOR INPUT ONLY — nothing at runtime imports this file. It is the
// authored source `tool/generate_countries.dart` merges with
// `countries_source.dart` to produce `lib/src/data/country_data.dart`.
//
// Derived from a JSON blob that also carried a base64 PNG flag per country
// (~1MB). Those were dropped: the emoji flag in `countries_source.dart` renders
// on every platform the app ships to, at any size, for nothing.
//
// A handful of rows are absent or wrong at the source; `_currencyOverrides` in
// the generator is the curated patch and lists every entry it fixes.

/// Currency and alpha-3 code for one country, as authored upstream.
typedef RawCurrency = ({
  String? iso3,
  String? currencyCode,
  String? currencyName,
  String? currencySymbol,
});

const rawCurrencies = <String, RawCurrency>{
  // Andorra
  'AD': (
    iso3: 'AND',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // United Arab Emirates
  'AE': (
    iso3: 'ARE',
    currencyCode: 'AED',
    currencyName: 'United Arab Emirates dirham',
    currencySymbol: 'د.إ',
  ),
  // Afghanistan
  'AF': (
    iso3: 'AFG',
    currencyCode: 'AFN',
    currencyName: 'Afghan afghani',
    currencySymbol: '؋',
  ),
  // Antigua and Barbuda
  'AG': (
    iso3: 'ATG',
    currencyCode: 'XCD',
    currencyName: 'East Caribbean dollar',
    currencySymbol: '\$',
  ),
  // Anguilla
  'AI': (
    iso3: 'AIA',
    currencyCode: 'XCD',
    currencyName: 'East Caribbean dollar',
    currencySymbol: '\$',
  ),
  // Albania
  'AL': (
    iso3: 'ALB',
    currencyCode: 'ALL',
    currencyName: 'Albanian lek',
    currencySymbol: 'Lek',
  ),
  // Armenia
  'AM': (
    iso3: 'ARM',
    currencyCode: 'AMD',
    currencyName: null,
    currencySymbol: 'Դ',
  ),
  // Angola
  'AO': (
    iso3: 'AGO',
    currencyCode: 'AOA',
    currencyName: 'Angolan kwanza',
    currencySymbol: 'Kz',
  ),
  // Antarctica
  'AQ': (
    iso3: 'ATA',
    currencyCode: null,
    currencyName: null,
    currencySymbol: '\$',
  ),
  // Argentina
  'AR': (
    iso3: 'ARG',
    currencyCode: 'ARS',
    currencyName: 'Argentine peso',
    currencySymbol: '\$',
  ),
  // American Samoa
  'AS': (
    iso3: 'ASM',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Austria
  'AT': (
    iso3: 'AUT',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Australia
  'AU': (
    iso3: 'AUS',
    currencyCode: 'AUD',
    currencyName: 'Australian dollar',
    currencySymbol: '\$',
  ),
  // Aruba
  'AW': (
    iso3: 'ABW',
    currencyCode: 'AWG',
    currencyName: 'Aruban florin',
    currencySymbol: 'ƒ',
  ),
  // Åland Islands
  'AX': (
    iso3: null,
    currencyCode: 'AX',
    currencyName: 'Åland',
    currencySymbol: '€',
  ),
  // Azerbaijan
  'AZ': (
    iso3: 'AZE',
    currencyCode: 'AZN',
    currencyName: 'Azerbaijani manat',
    currencySymbol: 'ман',
  ),
  // Bosnia and Herzegovina
  'BA': (
    iso3: 'BIH',
    currencyCode: 'BAM',
    currencyName: 'Bosnia and Herzegovina convertible mark',
    currencySymbol: 'KM',
  ),
  // Barbados
  'BB': (
    iso3: 'BRB',
    currencyCode: 'BBD',
    currencyName: 'Barbados dollar',
    currencySymbol: '\$',
  ),
  // Bangladesh
  'BD': (
    iso3: 'BGD',
    currencyCode: 'BDT',
    currencyName: 'Bangladeshi taka',
    currencySymbol: '৳',
  ),
  // Belgium
  'BE': (
    iso3: 'BEL',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Burkina Faso
  'BF': (
    iso3: 'BFA',
    currencyCode: 'XOF',
    currencyName: 'CFA franc BCEAO',
    currencySymbol: 'CFA',
  ),
  // Bulgaria
  'BG': (
    iso3: 'BGR',
    currencyCode: 'BGN',
    currencyName: 'Bulgarian lev',
    currencySymbol: 'лв',
  ),
  // Bahrain
  'BH': (
    iso3: 'BHR',
    currencyCode: 'BHD',
    currencyName: 'Bahraini dinar',
    currencySymbol: '.د.ب',
  ),
  // Burundi
  'BI': (
    iso3: 'BDI',
    currencyCode: 'BIF',
    currencyName: 'Burundian franc',
    currencySymbol: 'BIF',
  ),
  // Benin
  'BJ': (
    iso3: 'BEN',
    currencyCode: 'XOF',
    currencyName: 'CFA franc BCEAO',
    currencySymbol: 'CFA',
  ),
  // Bermuda
  'BM': (
    iso3: 'BMU',
    currencyCode: 'BMD',
    currencyName: 'Bermudian dollar',
    currencySymbol: '\$',
  ),
  // Brunei
  'BN': (
    iso3: 'BRN',
    currencyCode: 'BND',
    currencyName: 'Brunei dollar',
    currencySymbol: '\$',
  ),
  // Bolivia
  'BO': (
    iso3: 'BOL',
    currencyCode: 'BOB',
    currencyName: 'Boliviano',
    currencySymbol: '\$b',
  ),
  // Brazil
  'BR': (
    iso3: 'BRA',
    currencyCode: 'BRL',
    currencyName: 'Brazilian real',
    currencySymbol: 'R\$',
  ),
  // Bahamas
  'BS': (
    iso3: 'BHS',
    currencyCode: 'BSD',
    currencyName: 'Bahamian dollar',
    currencySymbol: '\$',
  ),
  // Bhutan
  'BT': (
    iso3: 'BTN',
    currencyCode: 'BTN',
    currencyName: 'Bhutanese ngultrum',
    currencySymbol: 'BTN',
  ),
  // Bouvet Island
  'BV': (
    iso3: 'BVT',
    currencyCode: 'NOK',
    currencyName: 'Norwegian krone',
    currencySymbol: 'kr',
  ),
  // Botswana
  'BW': (
    iso3: 'BWA',
    currencyCode: 'BWP',
    currencyName: 'Botswana pula',
    currencySymbol: 'P',
  ),
  // Belarus
  'BY': (
    iso3: 'BLR',
    currencyCode: 'BYR',
    currencyName: 'Belarusian ruble',
    currencySymbol: 'p.',
  ),
  // Belize
  'BZ': (
    iso3: 'BLZ',
    currencyCode: 'BZD',
    currencyName: 'Belize dollar',
    currencySymbol: 'BZ\$',
  ),
  // Canada
  'CA': (
    iso3: 'CAN',
    currencyCode: 'CAD',
    currencyName: 'Canadian dollar',
    currencySymbol: '\$',
  ),
  // Cocos Islands
  'CC': (
    iso3: 'CCK',
    currencyCode: 'AUD',
    currencyName: 'Dollar',
    currencySymbol: '\$',
  ),
  // Democratic Republic of the Congo
  'CD': (
    iso3: 'COD',
    currencyCode: 'CDF',
    currencyName: 'Congolese franc',
    currencySymbol: 'CDF',
  ),
  // Central African Republic
  'CF': (
    iso3: 'CAF',
    currencyCode: 'XAF',
    currencyName: 'CFA franc BEAC',
    currencySymbol: 'FCF',
  ),
  // Republic of the Congo
  'CG': (
    iso3: 'COG',
    currencyCode: 'XAF',
    currencyName: 'CFA franc BEAC',
    currencySymbol: 'FCF',
  ),
  // Switzerland
  'CH': (
    iso3: 'CHE',
    currencyCode: 'CHF',
    currencyName: 'Franc',
    currencySymbol: 'CHF',
  ),
  // Ivory Coast
  'CI': (
    iso3: 'CIV',
    currencyCode: 'XOF',
    currencyName: 'CFA franc BCEAO',
    currencySymbol: 'CFA',
  ),
  // Cook Islands
  'CK': (
    iso3: 'COK',
    currencyCode: 'NZD',
    currencyName: 'New Zealand dollar',
    currencySymbol: '\$',
  ),
  // Chile
  'CL': (
    iso3: 'CHL',
    currencyCode: 'CLP',
    currencyName: 'Peso',
    currencySymbol: '\$',
  ),
  // Cameroon
  'CM': (
    iso3: 'CMR',
    currencyCode: 'XAF',
    currencyName: 'CFA franc BEAC',
    currencySymbol: 'FCF',
  ),
  // China
  'CN': (
    iso3: 'CHN',
    currencyCode: 'CNY',
    currencyName: 'Renminbi',
    currencySymbol: '¥',
  ),
  // Colombia
  'CO': (
    iso3: 'COL',
    currencyCode: 'COP',
    currencyName: 'Colombian peso',
    currencySymbol: '\$',
  ),
  // Costa Rica
  'CR': (
    iso3: 'CRI',
    currencyCode: 'CRC',
    currencyName: 'Costa Rican colon',
    currencySymbol: '₡',
  ),
  // Cuba
  'CU': (
    iso3: 'CUB',
    currencyCode: 'CUP',
    currencyName: 'Cuban peso',
    currencySymbol: '₱',
  ),
  // Christmas Island
  'CX': (
    iso3: 'CXR',
    currencyCode: 'AUD',
    currencyName: 'Dollar',
    currencySymbol: '\$',
  ),
  // Cyprus
  'CY': (
    iso3: 'CYP',
    currencyCode: 'CYP',
    currencyName: 'Pound',
    currencySymbol: '€',
  ),
  // Czech Republic
  'CZ': (
    iso3: 'CZE',
    currencyCode: 'CZK',
    currencyName: 'Czech koruna',
    currencySymbol: 'Kč',
  ),
  // Germany
  'DE': (
    iso3: 'DEU',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Djibouti
  'DJ': (
    iso3: 'DJI',
    currencyCode: 'DJF',
    currencyName: 'Djiboutian franc',
    currencySymbol: 'DJF',
  ),
  // Denmark
  'DK': (
    iso3: 'DNK',
    currencyCode: 'DKK',
    currencyName: 'Danish krone',
    currencySymbol: 'kr',
  ),
  // Dominica
  'DM': (
    iso3: 'DMA',
    currencyCode: 'XCD',
    currencyName: 'East Caribbean dollar',
    currencySymbol: '\$',
  ),
  // Dominican Republic
  'DO': (
    iso3: 'DOM',
    currencyCode: 'DOP',
    currencyName: 'Dominican peso',
    currencySymbol: 'RD\$',
  ),
  // Algeria
  'DZ': (
    iso3: 'DZA',
    currencyCode: 'DZD',
    currencyName: 'Algerian dinar',
    currencySymbol: 'دج',
  ),
  // Ecuador
  'EC': (
    iso3: 'ECU',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Estonia
  'EE': (
    iso3: 'EST',
    currencyCode: 'EEK',
    currencyName: 'Kroon',
    currencySymbol: 'kr',
  ),
  // Egypt
  'EG': (
    iso3: 'EGY',
    currencyCode: 'EGP',
    currencyName: 'Egyptian pound',
    currencySymbol: '£',
  ),
  // Eritrea
  'ER': (
    iso3: 'ERI',
    currencyCode: 'ERN',
    currencyName: 'Eritrean nakfa',
    currencySymbol: 'Nfk',
  ),
  // Spain
  'ES': (
    iso3: 'ESP',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Ethiopia
  'ET': (
    iso3: 'ETH',
    currencyCode: 'ETB',
    currencyName: 'Ethiopian birr',
    currencySymbol: 'ETB',
  ),
  // Finland
  'FI': (
    iso3: 'FIN',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Fiji
  'FJ': (
    iso3: 'FJI',
    currencyCode: 'FJD',
    currencyName: 'Fiji dollar',
    currencySymbol: '\$',
  ),
  // Falkland Islands
  'FK': (
    iso3: 'FLK',
    currencyCode: 'FKP',
    currencyName: 'Falkland Islands pound',
    currencySymbol: '£',
  ),
  // Micronesia
  'FM': (
    iso3: 'FSM',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Faroe Islands
  'FO': (
    iso3: 'FRO',
    currencyCode: 'DKK',
    currencyName: 'Danish krone',
    currencySymbol: 'kr',
  ),
  // France
  'FR': (
    iso3: 'FRA',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Gabon
  'GA': (
    iso3: 'GAB',
    currencyCode: 'XAF',
    currencyName: 'CFA franc BEAC',
    currencySymbol: 'FCF',
  ),
  // United Kingdom
  'GB': (
    iso3: 'GBR',
    currencyCode: 'GBP',
    currencyName: 'Pound sterling',
    currencySymbol: '£',
  ),
  // Grenada
  'GD': (
    iso3: 'GRD',
    currencyCode: 'XCD',
    currencyName: 'East Caribbean dollar',
    currencySymbol: '\$',
  ),
  // Georgia
  'GE': (
    iso3: 'GEO',
    currencyCode: 'GEL',
    currencyName: 'Georgian lari',
    currencySymbol: '₾',
  ),
  // French Guiana
  'GF': (
    iso3: 'GUF',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Ghana
  'GH': (
    iso3: 'GHA',
    currencyCode: 'GHC',
    currencyName: 'Cedi',
    currencySymbol: '¢',
  ),
  // Gibraltar
  'GI': (
    iso3: 'GIB',
    currencyCode: 'GIP',
    currencyName: 'Gibraltar pound',
    currencySymbol: '£',
  ),
  // Greenland
  'GL': (
    iso3: 'GRL',
    currencyCode: 'DKK',
    currencyName: 'Danish krone',
    currencySymbol: 'kr',
  ),
  // Gambia
  'GM': (
    iso3: 'GMB',
    currencyCode: 'GMD',
    currencyName: 'Gambian dalasi',
    currencySymbol: 'D',
  ),
  // Guinea
  'GN': (
    iso3: 'GIN',
    currencyCode: 'GNF',
    currencyName: 'Franc',
    currencySymbol: 'FG',
  ),
  // Guadeloupe
  'GP': (
    iso3: 'GLP',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Equatorial Guinea
  'GQ': (
    iso3: 'GNQ',
    currencyCode: 'XAF',
    currencyName: 'CFA franc BEAC',
    currencySymbol: 'FCF',
  ),
  // Greece
  'GR': (
    iso3: 'GRC',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // South Georgia and the South Sandwich Islands
  'GS': (
    iso3: 'SGS',
    currencyCode: 'GBP',
    currencyName: 'Pound sterling',
    currencySymbol: '£',
  ),
  // Guatemala
  'GT': (
    iso3: 'GTM',
    currencyCode: 'GTQ',
    currencyName: 'Guatemalan quetzal',
    currencySymbol: 'Q',
  ),
  // Guam
  'GU': (
    iso3: 'GUM',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Guinea-Bissau
  'GW': (
    iso3: 'GNB',
    currencyCode: 'XOF',
    currencyName: 'CFA franc BCEAO',
    currencySymbol: 'CFA',
  ),
  // Guyana
  'GY': (
    iso3: 'GUY',
    currencyCode: 'GYD',
    currencyName: 'Guyanese dollar',
    currencySymbol: '\$',
  ),
  // Hong Kong
  'HK': (
    iso3: 'HKG',
    currencyCode: 'HKD',
    currencyName: 'Hong Kong dollar',
    currencySymbol: '\$',
  ),
  // Heard Island and McDonald Islands
  'HM': (
    iso3: 'HMD',
    currencyCode: 'AUD',
    currencyName: 'Dollar',
    currencySymbol: '\$',
  ),
  // Honduras
  'HN': (
    iso3: 'HND',
    currencyCode: 'HNL',
    currencyName: 'Honduran lempira',
    currencySymbol: 'L',
  ),
  // Croatia
  'HR': (
    iso3: 'HRV',
    currencyCode: 'HRK',
    currencyName: 'Croatian kuna',
    currencySymbol: 'kn',
  ),
  // Haiti
  'HT': (
    iso3: 'HTI',
    currencyCode: 'HTG',
    currencyName: 'Haitian gourde',
    currencySymbol: 'G',
  ),
  // Hungary
  'HU': (
    iso3: 'HUN',
    currencyCode: 'HUF',
    currencyName: 'Hungarian forint',
    currencySymbol: 'Ft',
  ),
  // Indonesia
  'ID': (
    iso3: 'IDN',
    currencyCode: 'IDR',
    currencyName: 'Indonesian rupiah',
    currencySymbol: 'Rp',
  ),
  // Ireland
  'IE': (
    iso3: 'IRL',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Israel
  'IL': (
    iso3: 'ISR',
    currencyCode: 'ILS',
    currencyName: 'Israeli new shekel',
    currencySymbol: '₪',
  ),
  // India
  'IN': (
    iso3: 'IND',
    currencyCode: 'INR',
    currencyName: 'Indian rupee',
    currencySymbol: 'Rs',
  ),
  // British Indian Ocean Territory
  'IO': (
    iso3: 'IOT',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Iraq
  'IQ': (
    iso3: 'IRQ',
    currencyCode: 'IQD',
    currencyName: 'Iraqi dinar',
    currencySymbol: 'ع.د',
  ),
  // Iran
  'IR': (
    iso3: 'IRN',
    currencyCode: 'IRR',
    currencyName: 'Iranian rial',
    currencySymbol: '﷼',
  ),
  // Iceland
  'IS': (
    iso3: 'ISL',
    currencyCode: 'ISK',
    currencyName: 'Icelandic króna',
    currencySymbol: 'kr',
  ),
  // Italy
  'IT': (
    iso3: 'ITA',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Jamaica
  'JM': (
    iso3: 'JAM',
    currencyCode: 'JMD',
    currencyName: 'Jamaican dollar',
    currencySymbol: '\$',
  ),
  // Jordan
  'JO': (
    iso3: 'JOR',
    currencyCode: 'JOD',
    currencyName: 'Jordanian dinar',
    currencySymbol: 'JD',
  ),
  // Japan
  'JP': (
    iso3: 'JPN',
    currencyCode: 'JPY',
    currencyName: 'Japanese yen',
    currencySymbol: '¥',
  ),
  // Kenya
  'KE': (
    iso3: 'KEN',
    currencyCode: 'KES',
    currencyName: 'Kenyan shilling',
    currencySymbol: 'KSh',
  ),
  // Kyrgyzstan
  'KG': (
    iso3: 'KGZ',
    currencyCode: 'KGS',
    currencyName: 'Kyrgyzstani som',
    currencySymbol: 'лв',
  ),
  // Cambodia
  'KH': (
    iso3: 'KHM',
    currencyCode: 'KHR',
    currencyName: 'Cambodian riel',
    currencySymbol: '៛',
  ),
  // Kiribati
  'KI': (
    iso3: 'KIR',
    currencyCode: 'AUD',
    currencyName: 'Dollar',
    currencySymbol: '\$',
  ),
  // Comoros
  'KM': (
    iso3: 'COM',
    currencyCode: 'KMF',
    currencyName: 'Franc',
    currencySymbol: 'CF',
  ),
  // Saint Kitts and Nevis
  'KN': (
    iso3: 'KNA',
    currencyCode: 'XCD',
    currencyName: 'East Caribbean dollar',
    currencySymbol: '\$',
  ),
  // North Korea
  'KP': (
    iso3: 'PRK',
    currencyCode: 'KPW',
    currencyName: 'North Korean won',
    currencySymbol: '₩',
  ),
  // South Korea
  'KR': (
    iso3: 'KOR',
    currencyCode: 'KRW',
    currencyName: 'South Korean won',
    currencySymbol: '₩',
  ),
  // Kuwait
  'KW': (
    iso3: 'KWT',
    currencyCode: 'KWD',
    currencyName: 'Kuwaiti dinar',
    currencySymbol: 'KD',
  ),
  // Cayman Islands
  'KY': (
    iso3: 'CYM',
    currencyCode: 'KYD',
    currencyName: 'Cayman Islands dollar',
    currencySymbol: '\$',
  ),
  // Kazakhstan
  'KZ': (
    iso3: 'KAZ',
    currencyCode: 'KZT',
    currencyName: 'Kazakhstani tenge',
    currencySymbol: 'лв',
  ),
  // Laos
  'LA': (
    iso3: 'LAO',
    currencyCode: 'LAK',
    currencyName: 'Lao kip',
    currencySymbol: '₭',
  ),
  // Lebanon
  'LB': (
    iso3: 'LBN',
    currencyCode: 'LBP',
    currencyName: 'Lebanese pound',
    currencySymbol: '£',
  ),
  // Saint Lucia
  'LC': (
    iso3: 'LCA',
    currencyCode: 'XCD',
    currencyName: 'East Caribbean dollar',
    currencySymbol: '\$',
  ),
  // Liechtenstein
  'LI': (
    iso3: 'LIE',
    currencyCode: 'CHF',
    currencyName: 'Swiss franc',
    currencySymbol: 'CHF',
  ),
  // Sri Lanka
  'LK': (
    iso3: 'LKA',
    currencyCode: 'LKR',
    currencyName: 'Sri Lankan rupee',
    currencySymbol: 'Rs',
  ),
  // Liberia
  'LR': (
    iso3: 'LBR',
    currencyCode: 'LRD',
    currencyName: 'Liberian dollar',
    currencySymbol: '\$',
  ),
  // Lesotho
  'LS': (
    iso3: 'LSO',
    currencyCode: 'LSL',
    currencyName: 'Lesotho loti',
    currencySymbol: 'L',
  ),
  // Lithuania
  'LT': (
    iso3: 'LTU',
    currencyCode: 'LTL',
    currencyName: 'Litas',
    currencySymbol: 'Lt',
  ),
  // Luxembourg
  'LU': (
    iso3: 'LUX',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Latvia
  'LV': (
    iso3: 'LVA',
    currencyCode: 'LVL',
    currencyName: 'Lat',
    currencySymbol: 'Ls',
  ),
  // Libya
  'LY': (
    iso3: 'LBY',
    currencyCode: 'LYD',
    currencyName: 'Libyan dinar',
    currencySymbol: 'LD',
  ),
  // Morocco
  'MA': (
    iso3: 'MAR',
    currencyCode: 'MAD',
    currencyName: 'Moroccan dirham',
    currencySymbol: 'MAD',
  ),
  // Monaco
  'MC': (
    iso3: 'MCO',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Moldova
  'MD': (
    iso3: 'MDA',
    currencyCode: 'MDL',
    currencyName: 'Moldovan leu',
    currencySymbol: 'lei',
  ),
  // Madagascar
  'MG': (
    iso3: 'MDG',
    currencyCode: 'MGA',
    currencyName: 'Malagasy ariary',
    currencySymbol: 'Ar',
  ),
  // Marshall Islands
  'MH': (
    iso3: 'MHL',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Macedonia
  'MK': (
    iso3: 'MKD',
    currencyCode: 'MKD',
    currencyName: 'Macedonian denar',
    currencySymbol: 'ден',
  ),
  // Mali
  'ML': (
    iso3: 'MLI',
    currencyCode: 'XOF',
    currencyName: 'CFA franc BCEAO',
    currencySymbol: 'CFA',
  ),
  // Myanmar
  'MM': (
    iso3: 'MMR',
    currencyCode: 'MMK',
    currencyName: 'Myanmar kyat',
    currencySymbol: 'K',
  ),
  // Mongolia
  'MN': (
    iso3: 'MNG',
    currencyCode: 'MNT',
    currencyName: 'Mongolian tögrög',
    currencySymbol: '₮',
  ),
  // Macao
  'MO': (
    iso3: 'MAC',
    currencyCode: 'MOP',
    currencyName: 'Macanese pataca',
    currencySymbol: 'MOP',
  ),
  // Northern Mariana Islands
  'MP': (
    iso3: 'MNP',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Martinique
  'MQ': (
    iso3: 'MTQ',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Mauritania
  'MR': (
    iso3: 'MRT',
    currencyCode: 'MRO',
    currencyName: 'Ouguiya',
    currencySymbol: 'UM',
  ),
  // Montserrat
  'MS': (
    iso3: 'MSR',
    currencyCode: 'XCD',
    currencyName: 'East Caribbean dollar',
    currencySymbol: '\$',
  ),
  // Malta
  'MT': (
    iso3: 'MLT',
    currencyCode: 'MTL',
    currencyName: 'Lira',
    currencySymbol: '€',
  ),
  // Mauritius
  'MU': (
    iso3: 'MUS',
    currencyCode: 'MUR',
    currencyName: 'Mauritian rupee',
    currencySymbol: 'Rs',
  ),
  // Maldives
  'MV': (
    iso3: 'MDV',
    currencyCode: 'MVR',
    currencyName: 'Maldivian rufiyaa',
    currencySymbol: 'Rf',
  ),
  // Malawi
  'MW': (
    iso3: 'MWI',
    currencyCode: 'MWK',
    currencyName: 'Malawian kwacha',
    currencySymbol: 'MK',
  ),
  // Mexico
  'MX': (
    iso3: 'MEX',
    currencyCode: 'MXN',
    currencyName: 'Mexican peso',
    currencySymbol: '\$',
  ),
  // Malaysia
  'MY': (
    iso3: 'MYS',
    currencyCode: 'MYR',
    currencyName: 'Malaysian ringgit',
    currencySymbol: 'RM',
  ),
  // Mozambique
  'MZ': (
    iso3: 'MOZ',
    currencyCode: 'MZN',
    currencyName: 'Mozambican metical',
    currencySymbol: 'MT',
  ),
  // Namibia
  'NA': (
    iso3: 'NAM',
    currencyCode: 'NAD',
    currencyName: 'Namibian dollar',
    currencySymbol: '\$',
  ),
  // New Caledonia
  'NC': (
    iso3: 'NCL',
    currencyCode: 'XPF',
    currencyName: 'CFP franc',
    currencySymbol: '₣',
  ),
  // Niger
  'NE': (
    iso3: 'NER',
    currencyCode: 'XOF',
    currencyName: 'CFA franc BCEAO',
    currencySymbol: 'CFA',
  ),
  // Norfolk Island
  'NF': (
    iso3: 'NFK',
    currencyCode: 'AUD',
    currencyName: 'Dollar',
    currencySymbol: '\$',
  ),
  // Nigeria
  'NG': (
    iso3: 'NGA',
    currencyCode: 'NGN',
    currencyName: 'Nigerian naira',
    currencySymbol: '₦',
  ),
  // Nicaragua
  'NI': (
    iso3: 'NIC',
    currencyCode: 'NIO',
    currencyName: 'Nicaraguan córdoba',
    currencySymbol: 'C\$',
  ),
  // Netherlands
  'NL': (
    iso3: 'NLD',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Norway
  'NO': (
    iso3: 'NOR',
    currencyCode: 'NOK',
    currencyName: 'Norwegian krone',
    currencySymbol: 'kr',
  ),
  // Nepal
  'NP': (
    iso3: 'NPL',
    currencyCode: 'NPR',
    currencyName: 'Nepalese rupee',
    currencySymbol: 'Rs',
  ),
  // Nauru
  'NR': (
    iso3: 'NRU',
    currencyCode: 'AUD',
    currencyName: 'Dollar',
    currencySymbol: '\$',
  ),
  // Niue
  'NU': (
    iso3: 'NIU',
    currencyCode: 'NZD',
    currencyName: 'New Zealand dollar',
    currencySymbol: '\$',
  ),
  // New Zealand
  'NZ': (
    iso3: 'NZL',
    currencyCode: 'NZD',
    currencyName: 'New Zealand dollar',
    currencySymbol: '\$',
  ),
  // Oman
  'OM': (
    iso3: 'OMN',
    currencyCode: 'OMR',
    currencyName: 'Omani rial',
    currencySymbol: '﷼',
  ),
  // Panama
  'PA': (
    iso3: 'PAN',
    currencyCode: 'PAB',
    currencyName: 'Panamanian balboa',
    currencySymbol: 'B/.',
  ),
  // Peru
  'PE': (
    iso3: 'PER',
    currencyCode: 'PEN',
    currencyName: 'Peruvian sol',
    currencySymbol: 'S/.',
  ),
  // French Polynesia
  'PF': (
    iso3: 'PYF',
    currencyCode: 'XPF',
    currencyName: 'CFP franc',
    currencySymbol: 'CFPF',
  ),
  // Papua New Guinea
  'PG': (
    iso3: 'PNG',
    currencyCode: 'PGK',
    currencyName: 'Papua New Guinean kina',
    currencySymbol: 'K',
  ),
  // Philippines
  'PH': (
    iso3: 'PHL',
    currencyCode: 'PHP',
    currencyName: 'Philippine peso',
    currencySymbol: 'Php',
  ),
  // Pakistan
  'PK': (
    iso3: 'PAK',
    currencyCode: 'PKR',
    currencyName: 'Pakistani rupee',
    currencySymbol: 'Rs',
  ),
  // Poland
  'PL': (
    iso3: 'POL',
    currencyCode: 'PLN',
    currencyName: 'Polish złoty',
    currencySymbol: 'zł',
  ),
  // Saint Pierre and Miquelon
  'PM': (
    iso3: 'SPM',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Pitcairn
  'PN': (
    iso3: 'PCN',
    currencyCode: 'NZD',
    currencyName: 'New Zealand dollar',
    currencySymbol: '\$',
  ),
  // Puerto Rico
  'PR': (
    iso3: 'PRI',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Palestinian Territory
  'PS': (
    iso3: 'PSE',
    currencyCode: 'ILS',
    currencyName: 'Israeli new shekel',
    currencySymbol: '₪',
  ),
  // Portugal
  'PT': (
    iso3: 'PRT',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Palau
  'PW': (
    iso3: 'PLW',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Paraguay
  'PY': (
    iso3: 'PRY',
    currencyCode: 'PYG',
    currencyName: 'Paraguayan guaraní',
    currencySymbol: 'Gs',
  ),
  // Qatar
  'QA': (
    iso3: 'QAT',
    currencyCode: 'QAR',
    currencyName: 'Qatari riyal',
    currencySymbol: '﷼',
  ),
  // Reunion
  'RE': (
    iso3: 'REU',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Romania
  'RO': (
    iso3: 'ROU',
    currencyCode: 'RON',
    currencyName: 'Romanian leu',
    currencySymbol: 'lei',
  ),
  // Russia
  'RU': (
    iso3: 'RUS',
    currencyCode: 'RUB',
    currencyName: 'Russian ruble',
    currencySymbol: '₽',
  ),
  // Rwanda
  'RW': (
    iso3: 'RWA',
    currencyCode: 'RWF',
    currencyName: 'Rwandan franc',
    currencySymbol: 'R₣',
  ),
  // Saudi Arabia
  'SA': (
    iso3: 'SAU',
    currencyCode: 'SAR',
    currencyName: 'Saudi riyal',
    currencySymbol: '﷼',
  ),
  // Solomon Islands
  'SB': (
    iso3: 'SLB',
    currencyCode: 'SBD',
    currencyName: 'Solomon Islands dollar',
    currencySymbol: '\$',
  ),
  // Seychelles
  'SC': (
    iso3: 'SYC',
    currencyCode: 'SCR',
    currencyName: 'Seychelles rupee',
    currencySymbol: 'Rs',
  ),
  // Sudan
  'SD': (
    iso3: 'SDN',
    currencyCode: 'SDD',
    currencyName: 'Dinar',
    currencySymbol: 'ج.س.',
  ),
  // Sweden
  'SE': (
    iso3: 'SWE',
    currencyCode: 'SEK',
    currencyName: 'Swedish krona',
    currencySymbol: 'kr',
  ),
  // Singapore
  'SG': (
    iso3: 'SGP',
    currencyCode: 'SGD',
    currencyName: 'Singapore dollar',
    currencySymbol: '\$',
  ),
  // Saint Helena
  'SH': (
    iso3: 'SHN',
    currencyCode: 'SHP',
    currencyName: 'Saint Helena pound',
    currencySymbol: '£',
  ),
  // Slovenia
  'SI': (
    iso3: 'SVN',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Svalbard and Jan Mayen
  'SJ': (
    iso3: 'SJM',
    currencyCode: 'NOK',
    currencyName: 'Norwegian krone',
    currencySymbol: 'kr',
  ),
  // Slovakia
  'SK': (
    iso3: 'SVK',
    currencyCode: 'SKK',
    currencyName: 'Koruna',
    currencySymbol: 'Sk',
  ),
  // Sierra Leone
  'SL': (
    iso3: 'SLE',
    currencyCode: 'SLL',
    currencyName: 'Leone',
    currencySymbol: 'Le',
  ),
  // San Marino
  'SM': (
    iso3: 'SMR',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Senegal
  'SN': (
    iso3: 'SEN',
    currencyCode: 'XOF',
    currencyName: 'CFA franc BCEAO',
    currencySymbol: 'CFA',
  ),
  // Somalia
  'SO': (
    iso3: 'SOM',
    currencyCode: 'SOS',
    currencyName: 'Somalian shilling',
    currencySymbol: 'S',
  ),
  // Suriname
  'SR': (
    iso3: 'SUR',
    currencyCode: 'SRD',
    currencyName: 'Surinamese dollar',
    currencySymbol: '\$',
  ),
  // Sao Tome and Principe
  'ST': (
    iso3: 'STP',
    currencyCode: 'STD',
    currencyName: 'Dobra',
    currencySymbol: 'Db',
  ),
  // El Salvador
  'SV': (
    iso3: 'SLV',
    currencyCode: 'SVC',
    currencyName: 'Salvadoran colón',
    currencySymbol: '\$',
  ),
  // Syria
  'SY': (
    iso3: 'SYR',
    currencyCode: 'SYP',
    currencyName: 'Syrian pound',
    currencySymbol: '£',
  ),
  // Swaziland
  'SZ': (
    iso3: 'SWZ',
    currencyCode: 'SZL',
    currencyName: 'Swazi lilangeni',
    currencySymbol: 'E',
  ),
  // Turks and Caicos Islands
  'TC': (
    iso3: 'TCA',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Chad
  'TD': (
    iso3: 'TCD',
    currencyCode: 'XAF',
    currencyName: 'CFA franc BEAC',
    currencySymbol: 'FCFA',
  ),
  // French Southern Territories
  'TF': (
    iso3: 'ATF',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Togo
  'TG': (
    iso3: 'TGO',
    currencyCode: 'XOF',
    currencyName: 'CFA franc BCEAO',
    currencySymbol: 'CFA',
  ),
  // Thailand
  'TH': (
    iso3: 'THA',
    currencyCode: 'THB',
    currencyName: 'Thai baht',
    currencySymbol: '฿',
  ),
  // Tajikistan
  'TJ': (
    iso3: 'TJK',
    currencyCode: 'TJS',
    currencyName: 'Tajikistani somoni',
    currencySymbol: 'SM',
  ),
  // Tokelau
  'TK': (
    iso3: 'TKL',
    currencyCode: 'NZD',
    currencyName: 'New Zealand dollar',
    currencySymbol: '\$',
  ),
  // East Timor
  'TL': (
    iso3: 'TLS',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Turkmenistan
  'TM': (
    iso3: 'TKM',
    currencyCode: 'TMM',
    currencyName: 'Manat',
    currencySymbol: 'm',
  ),
  // Tunisia
  'TN': (
    iso3: 'TUN',
    currencyCode: 'TND',
    currencyName: 'Tunisian dinar',
    currencySymbol: 'د.ت',
  ),
  // Tonga
  'TO': (
    iso3: 'TON',
    currencyCode: 'TOP',
    currencyName: 'Tongan paʻanga',
    currencySymbol: 'T\$',
  ),
  // Turkey
  'TR': (
    iso3: 'TUR',
    currencyCode: 'TRY',
    currencyName: 'Turkish lira',
    currencySymbol: 'YTL',
  ),
  // Trinidad and Tobago
  'TT': (
    iso3: 'TTO',
    currencyCode: 'TTD',
    currencyName: 'Trinidad and Tobago dollar',
    currencySymbol: 'TT\$',
  ),
  // Tuvalu
  'TV': (
    iso3: 'TUV',
    currencyCode: 'AUD',
    currencyName: 'Dollar',
    currencySymbol: '\$',
  ),
  // Taiwan
  'TW': (
    iso3: 'TWN',
    currencyCode: 'TWD',
    currencyName: 'New Taiwan dollar',
    currencySymbol: 'NT\$',
  ),
  // Tanzania
  'TZ': (
    iso3: 'TZA',
    currencyCode: 'TZS',
    currencyName: 'Tanzanian shilling',
    currencySymbol: 'TSh',
  ),
  // Ukraine
  'UA': (
    iso3: 'UKR',
    currencyCode: 'UAH',
    currencyName: 'Ukrainian hryvnia',
    currencySymbol: '₴',
  ),
  // Uganda
  'UG': (
    iso3: 'UGA',
    currencyCode: 'UGX',
    currencyName: 'Ugandan shilling',
    currencySymbol: 'USh',
  ),
  // United States
  'US': (
    iso3: 'USA',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Uruguay
  'UY': (
    iso3: 'URY',
    currencyCode: 'UYU',
    currencyName: 'Uruguayan peso',
    currencySymbol: '\$U',
  ),
  // Uzbekistan
  'UZ': (
    iso3: 'UZB',
    currencyCode: 'UZS',
    currencyName: 'Uzbekistani sum',
    currencySymbol: 'лв',
  ),
  // Vatican
  'VA': (
    iso3: 'VAT',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // Saint Vincent and the Grenadines
  'VC': (
    iso3: 'VCT',
    currencyCode: 'XCD',
    currencyName: 'East Caribbean dollar',
    currencySymbol: '\$',
  ),
  // Venezuela
  'VE': (
    iso3: 'VEN',
    currencyCode: 'VEF',
    currencyName: 'Bolivar',
    currencySymbol: 'Bs',
  ),
  // British Virgin Islands
  'VG': (
    iso3: 'VGB',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // U.S. Virgin Islands
  'VI': (
    iso3: 'VIR',
    currencyCode: 'USD',
    currencyName: 'United States dollar',
    currencySymbol: '\$',
  ),
  // Vietnam
  'VN': (
    iso3: 'VNM',
    currencyCode: 'VND',
    currencyName: 'Vietnamese đồng',
    currencySymbol: '₫',
  ),
  // Vanuatu
  'VU': (
    iso3: 'VUT',
    currencyCode: 'VUV',
    currencyName: 'Vanuatu vatu',
    currencySymbol: 'Vt',
  ),
  // Wallis and Futuna
  'WF': (
    iso3: 'WLF',
    currencyCode: 'XPF',
    currencyName: 'CFP franc',
    currencySymbol: '₣',
  ),
  // Samoa
  'WS': (
    iso3: 'WSM',
    currencyCode: 'WST',
    currencyName: 'Samoan tala',
    currencySymbol: 'WS\$',
  ),
  // Yemen
  'YE': (
    iso3: 'YEM',
    currencyCode: 'YER',
    currencyName: 'Yemeni rial',
    currencySymbol: '﷼',
  ),
  // Mayotte
  'YT': (
    iso3: 'MYT',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  // South Africa
  'ZA': (
    iso3: 'ZAF',
    currencyCode: 'ZAR',
    currencyName: 'South African rand',
    currencySymbol: 'R',
  ),
  // Zambia
  'ZM': (
    iso3: 'ZMB',
    currencyCode: 'ZMK',
    currencyName: 'Kwacha',
    currencySymbol: 'ZK',
  ),
  // Zimbabwe
  'ZW': (
    iso3: 'ZWE',
    currencyCode: 'ZWD',
    currencyName: 'Dollar',
    currencySymbol: 'Z\$',
  ),
};

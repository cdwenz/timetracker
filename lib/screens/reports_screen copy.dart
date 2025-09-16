// lib/screens/reports_screen.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ihadi_time_tracker/widgets/custom_drawer.dart';
import 'package:ihadi_time_tracker/widgets/report_detail_modal.dart';
import 'package:ihadi_time_tracker/models/tracking.dart';
import 'package:ihadi_time_tracker/services/reports_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // ======== Estado UI ========
  bool _filtersExpanded = true;
  bool _loading = false;
  String? _error;

  // ======== Filtros ========
  // Usuario: "Todos" (null), "Yo" y derivados de resultados
  final List<_UserOption> _users = [];
  _UserOption? _selectedUser; // null => todos (según permisos)
  String? _myUserId; // desde JWT
  String? _myUserName; // desde prefs (para mostrar “Yo (nombre)”)

  // País (Autocomplete por NOMBRE, valida por CÓDIGO)
  final TextEditingController _countryCtrl = TextEditingController();
  String? _supportedCountry; // código ISO seleccionado (o null si sin filtro)
  bool _noCountryFilter = false;

  // Rango de fechas (DateRangePicker)
  DateTimeRange? _range;

  // Paginación
  int _page = 1;
  int _pageSize = 20;

  // Datos
  List<Tracking> _items = [];
  int _total = 0;

  // ======== Lifecycle ========
  @override
  void initState() {
    super.initState();
    _initMe().then((_) => _load(resetPage: true));
  }

  @override
  void dispose() {
    _countryCtrl.dispose();
    super.dispose();
  }

  // ======== Init: obtener “Yo” del JWT + nombre desde prefs ========
  Future<void> _initMe() async {
    final prefs = await SharedPreferences.getInstance();
    _myUserName = prefs.getString('username') ?? 'Yo';

    final token = prefs.getString('access_token') ?? prefs.getString('token');
    _myUserId = _decodeSubFromJwt(token);
    // Cargamos “Yo” en la lista para la opción dedicada
    if (_myUserId != null) {
      _upsertUser(
          _UserOption(id: _myUserId!, name: _myUserName ?? 'Yo', isMe: true));
    }
    setState(() {});
  }

  // Decodifica el claim `sub` del JWT sin dependencias externas.
  String? _decodeSubFromJwt(String? jwt) {
    try {
      if (jwt == null || !jwt.contains('.')) return null;
      final parts = jwt.split('.');
      if (parts.length < 2) return null;
      final payload = _base64UrlDecode(parts[1]);
      final map = jsonDecode(utf8.decode(payload));
      if (map is Map && map['sub'] != null) {
        return map['sub'].toString();
      }
    } catch (_) {}
    return null;
  }

  Uint8List _base64UrlDecode(String input) {
    var normalized = input.replaceAll('-', '+').replaceAll('_', '/');
    switch (normalized.length % 4) {
      case 2:
        normalized += '==';
        break;
      case 3:
        normalized += '=';
        break;
      default:
        break;
    }
    return base64Decode(normalized);
  }

  // ======== Acciones ========
  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final initial = _range ??
        DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 0),
        );
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3, 1, 1),
      lastDate: DateTime(now.year + 2, 12, 31),
      initialDateRange: initial,
    );
    if (picked != null) {
      setState(() => _range = picked);
    }
  }

  String _fmtDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  // Convierte el contenido del TextField (nombre o “Nombre (COD)”) a código ISO válido
  // Si _noCountryFilter = true, devuelve null
  String? _resolveCountryCodeFromInput() {
    if (_noCountryFilter) return null;

    final raw = _countryCtrl.text.trim();
    if (raw.isEmpty) return null;

    // Si viene “Nombre (COD)”
    final inParens = _extractCode(raw);
    if (inParens != null && kCountryNames.containsKey(inParens)) {
      return inParens;
    }

    // Matcheo por nombre exacto
    final byName = _nameToCode[raw.toLowerCase()];
    if (byName != null) return byName;

    // Matcheo por código ingresado directo
    final maybeCode = raw.toUpperCase();
    if (kCountryNames.containsKey(maybeCode)) return maybeCode;

    // no válido -> no aplicar filtro
    return null;
  }

  Future<void> _load({bool resetPage = false}) async {
    setState(() {
      _loading = true;
      _error = null;
      if (resetPage) _page = 1;
    });
    try {
      // Resolver país desde el input
      _supportedCountry = _resolveCountryCodeFromInput();

      final data = await ReportsService.fetchTrackers(
        userId: _selectedUser?.id, // null => todos (según permisos)
        fromDate: _range?.start,
        toDate: _range?.end,
        supportedCountry: _supportedCountry,
        page: _page,
        pageSize: _pageSize,
      );
      setState(() {
        _items = data.items;
        _total = data.total;
      });

      // Actualizar lista de usuarios a partir de los resultados
      _absorbUsersFromItems(_items);
      setState(() {});
    } catch (e) {
      setState(() {
        _error = e.toString();
        _items = [];
        _total = 0;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  // ======== Derivar usuarios desde los trackings ========
  void _absorbUsersFromItems(List<Tracking> items) {
    for (final t in items) {
      final map = _asMap(t) ?? {};
      final userId = (map['userId'] ??
              (map['user'] is Map ? map['user']['id'] : null) ??
              map['createdById'] ??
              map['ownerId'])
          ?.toString();

      final userName = (map['userName'] ??
              (map['user'] is Map ? map['user']['name'] : null) ??
              map['createdBy'] ??
              map['ownerName'] ??
              map['username'])
          ?.toString();

      if (userId == null || userId.isEmpty) continue;

      // Evitamos duplicar “Yo”
      final isMe = (_myUserId != null && userId == _myUserId);
      final name =
          isMe ? (_myUserName ?? userName ?? 'Yo') : (userName ?? 'Usuario');
      _upsertUser(_UserOption(id: userId, name: name, isMe: isMe));
    }

    // Aseguramos que “Yo” esté siempre primero si existe
    _users.sort((a, b) {
      if (a.isMe && !b.isMe) return -1;
      if (!a.isMe && b.isMe) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  void _upsertUser(_UserOption u) {
    final idx = _users.indexWhere((x) => x.id == u.id);
    if (idx >= 0) {
      _users[idx] = _UserOption(id: u.id, name: u.name, isMe: u.isMe);
    } else {
      _users.add(u);
    }
  }

  // ======== Derivación de textos para la lista ========
  Map<String, dynamic>? _asMap(Tracking t) {
    try {
      final str = jsonEncode(t);
      final decoded = jsonDecode(str);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  ({String title, String subtitle, String day}) _deriveTexts(Tracking t) {
    final map = _asMap(t) ?? {};
    final user = (map['userName'] ??
            map['user_name'] ??
            (map['user'] is Map ? map['user']['name'] : map['user']) ??
            map['technician'] ??
            map['createdBy'] ??
            map['created_by'])
        ?.toString();

    final desc = (map['description'] ??
            map['notes'] ??
            map['task'] ??
            map['activity'] ??
            map['title'])
        ?.toString();

    String day = '';
    for (final key in [
      'startedAt',
      'started_at',
      'date',
      'createdAt',
      'created_at',
      'endedAt'
    ]) {
      final v = map[key];
      if (v != null) {
        final s = v.toString();
        day = s.contains('T') ? s.split('T').first : s;
        break;
      }
    }

    final title = user?.isNotEmpty == true
        ? user!
        : (desc?.isNotEmpty == true ? desc! : 'Tracking');
    final subtitle = user != null && desc != null && user != desc
        ? desc
        : (day.isNotEmpty ? day : (desc ?? ''));
    return (title: title, subtitle: subtitle, day: day);
  }

  // ======== UI ========
  Widget _filtersHeader() {
    return Row(
      children: [
        IconButton(
          tooltip: _filtersExpanded ? 'Ocultar filtros' : 'Mostrar filtros',
          icon: Icon(_filtersExpanded ? Icons.expand_less : Icons.expand_more),
          onPressed: () => setState(() => _filtersExpanded = !_filtersExpanded),
        ),
        const Text(
          'Filtros',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: _loading ? null : () => _load(resetPage: true),
          icon: const Icon(Icons.search),
          label: const Text('Aplicar'),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: _loading
              ? null
              : () {
                  setState(() {
                    _selectedUser = null;
                    _noCountryFilter = false;
                    _countryCtrl.clear();
                    _supportedCountry = null;
                    _range = null;
                    _page = 1;
                    _pageSize = 20;
                  });
                  _load(resetPage: true);
                },
          icon: const Icon(Icons.clear),
          label: const Text('Limpiar'),
        ),
      ],
    );
  }

  Widget _filtersBody() {
    if (!_filtersExpanded) return const SizedBox.shrink();

    final isWide = MediaQuery.of(context).size.width >= 700;

    // Autocomplete por nombre “Nombre (COD)”
    final options = kCountryNames.entries
        .map((e) => '${e.value} (${e.key})')
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Fila: Usuario + País + “Sin filtro”
            Wrap(
              runSpacing: 12,
              spacing: 12,
              children: [
                SizedBox(
                  width: isWide ? 320 : MediaQuery.of(context).size.width - 48,
                  child: DropdownButtonFormField<_UserOption>(
                    value: _selectedUser,
                    items: [
                      const DropdownMenuItem<_UserOption>(
                        value: null,
                        child: Text('Todos (según permisos)'),
                      ),
                      if (_myUserId != null)
                        DropdownMenuItem<_UserOption>(
                          value: _users.firstWhere(
                            (u) => u.isMe,
                            orElse: () => _UserOption(
                                id: _myUserId!,
                                name: _myUserName ?? 'Yo',
                                isMe: true),
                          ),
                          child: const Text(
                              'Solo mis trackings '), //(${_myUserName ?? "Yo"})
                        ),
                      ..._users.where((u) => !u.isMe).map(
                            (u) => DropdownMenuItem<_UserOption>(
                              value: u,
                              child: Text(u.name),
                            ),
                          ),
                    ],
                    onChanged: (v) => setState(() => _selectedUser = v),
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_search),
                    ),
                  ),
                ),
                SizedBox(
                  width: isWide ? 320 : MediaQuery.of(context).size.width - 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue value) {
                          if (_noCountryFilter)
                            return const Iterable<String>.empty();
                          final q = value.text.trim().toLowerCase();
                          if (q.isEmpty) return const Iterable<String>.empty();
                          return options
                              .where((opt) => opt.toLowerCase().contains(q))
                              .take(20);
                        },
                        onSelected: (sel) {
                          final code = _extractCode(sel);
                          final name = _extractName(sel);
                          _countryCtrl.text = name ?? sel;
                          _supportedCountry = code;
                          setState(() {});
                          // cierra el popup
                          FocusScope.of(context).unfocus();
                        },
                        fieldViewBuilder:
                            (ctx, controller, focusNode, onSubmit) {
                          controller.text = _countryCtrl.text;
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            enabled: !_noCountryFilter,
                            decoration: InputDecoration(
                              labelText: 'País (nombre completo)',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.public),
                              helperText: _noCountryFilter
                                  ? 'Sin filtro de país'
                                  : 'Escribí el nombre del país (verás “Nombre (COD)”)',
                              suffixIcon: _countryCtrl.text.isNotEmpty &&
                                      !_noCountryFilter
                                  ? IconButton(
                                      tooltip: 'Quitar país',
                                      onPressed: () {
                                        _countryCtrl.clear();
                                        _supportedCountry = null;
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.clear),
                                    )
                                  : null,
                            ),
                            onSubmitted: (_) => _load(resetPage: true),
                          );
                        },
                        optionsViewBuilder: (ctx, onSelected, opts) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4,
                              child: SizedBox(
                                width: isWide
                                    ? 320
                                    : MediaQuery.of(context).size.width - 48,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: opts
                                      .map((o) => ListTile(
                                            title: Text(o),
                                            onTap: () => onSelected(o),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _noCountryFilter,
                            onChanged: (v) {
                              setState(() {
                                _noCountryFilter = v ?? false;
                                if (_noCountryFilter) {
                                  _countryCtrl.clear();
                                  _supportedCountry = null;
                                }
                              });
                            },
                          ),
                          const Text('Sin filtro de país'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Rango de fechas (un solo control)
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _pickDateRange,
                icon: const Icon(Icons.date_range),
                label: Text(
                  _range == null
                      ? 'Seleccionar rango de fechas'
                      : 'Rango: ${_fmtDate(_range!.start)}  →  ${_fmtDate(_range!.end)}',
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Page size
            Row(
              children: [
                const Text('Page size:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _pageSize,
                  items: const [
                    DropdownMenuItem(value: 10, child: Text('10')),
                    DropdownMenuItem(value: 20, child: Text('20')),
                    DropdownMenuItem(value: 50, child: Text('50')),
                    DropdownMenuItem(value: 100, child: Text('100')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _pageSize = v);
                    _load(resetPage: true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paginationBar() {
    final totalPages =
        (_total / (_pageSize == 0 ? 1 : _pageSize)).ceil().clamp(1, 999999);
    return Row(
      children: [
        Text(
            'Mostrando ${_items.length} de $_total  •  Página $_page de $totalPages'),
        const Spacer(),
        IconButton(
          tooltip: 'Anterior',
          onPressed: _loading || _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _load();
                },
          icon: const Icon(Icons.chevron_left),
        ),
        IconButton(
          tooltip: 'Siguiente',
          onPressed: _loading || _page >= totalPages
              ? null
              : () {
                  setState(() => _page += 1);
                  _load();
                },
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final usernameFuture = SharedPreferences.getInstance()
        .then((p) => p.getString('username') ?? '');

    return FutureBuilder<String>(
      future: usernameFuture,
      builder: (context, snap) {
        final username = snap.data ?? '';
        return Scaffold(
          appBar: AppBar(
            title: const Text('Reportes / Trackers'),
          ),
          drawer: const CustomDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _filtersHeader(),
                _filtersBody(),
                const SizedBox(height: 6),
                _paginationBar(),
                const SizedBox(height: 6),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.error_outline),
                                  const SizedBox(height: 8),
                                  Text(
                                    _error!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(height: 8),
                                  OutlinedButton(
                                    onPressed: () => _load(),
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              ),
                            )
                          : _items.isEmpty
                              ? const Center(
                                  child: Text(
                                      'No hay resultados con los filtros actuales'))
                              : ListView.separated(
                                  itemCount: _items.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (ctx, i) {
                                    final t = _items[i];
                                    final texts = _deriveTexts(t);
                                    return ListTile(
                                      title: Text(texts.title),
                                      subtitle: Text(texts.subtitle),
                                      trailing: Text(texts.day),
                                      onTap: () => showReportDetailForTracking(
                                          context, t),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helpers "Nombre (COD)"
  String? _extractCode(String s) {
    final i = s.lastIndexOf('(');
    final j = s.lastIndexOf(')');
    if (i >= 0 && j > i) {
      return s.substring(i + 1, j).trim().toUpperCase();
    }
    return null;
  }

  String? _extractName(String s) {
    final i = s.lastIndexOf('(');
    if (i > 0) return s.substring(0, i).trim();
    return s.trim();
  }
}

// ======== Soporte ========

class _UserOption {
  final String id;
  final String name;
  final bool isMe;
  _UserOption({required this.id, required this.name, required this.isMe});
  @override
  String toString() => name;
}

/// ISO 3166-1 alpha-2: code -> name
const Map<String, String> kCountryNames = {
  'AF': 'Afghanistan',
  'AX': 'Åland Islands',
  'AL': 'Albania',
  'DZ': 'Algeria',
  'AS': 'American Samoa',
  'AD': 'Andorra',
  'AO': 'Angola',
  'AI': 'Anguilla',
  'AQ': 'Antarctica',
  'AG': 'Antigua and Barbuda',
  'AR': 'Argentina',
  'AM': 'Armenia',
  'AW': 'Aruba',
  'AU': 'Australia',
  'AT': 'Austria',
  'AZ': 'Azerbaijan',
  'BS': 'Bahamas',
  'BH': 'Bahrain',
  'BD': 'Bangladesh',
  'BB': 'Barbados',
  'BY': 'Belarus',
  'BE': 'Belgium',
  'BZ': 'Belize',
  'BJ': 'Benin',
  'BM': 'Bermuda',
  'BT': 'Bhutan',
  'BO': 'Bolivia (Plurinational State of)',
  'BQ': 'Bonaire, Sint Eustatius and Saba',
  'BA': 'Bosnia and Herzegovina',
  'BW': 'Botswana',
  'BV': 'Bouvet Island',
  'BR': 'Brazil',
  'IO': 'British Indian Ocean Territory',
  'BN': 'Brunei Darussalam',
  'BG': 'Bulgaria',
  'BF': 'Burkina Faso',
  'BI': 'Burundi',
  'KH': 'Cambodia',
  'CM': 'Cameroon',
  'CA': 'Canada',
  'CV': 'Cabo Verde',
  'KY': 'Cayman Islands',
  'CF': 'Central African Republic',
  'TD': 'Chad',
  'CL': 'Chile',
  'CN': 'China',
  'CX': 'Christmas Island',
  'CC': 'Cocos (Keeling) Islands',
  'CO': 'Colombia',
  'KM': 'Comoros',
  'CG': 'Congo',
  'CD': 'Congo, Democratic Republic of the',
  'CK': 'Cook Islands',
  'CR': 'Costa Rica',
  'CI': "Côte d'Ivoire",
  'HR': 'Croatia',
  'CU': 'Cuba',
  'CW': 'Curaçao',
  'CY': 'Cyprus',
  'CZ': 'Czechia',
  'DK': 'Denmark',
  'DJ': 'Djibouti',
  'DM': 'Dominica',
  'DO': 'Dominican Republic',
  'EC': 'Ecuador',
  'EG': 'Egypt',
  'SV': 'El Salvador',
  'GQ': 'Equatorial Guinea',
  'ER': 'Eritrea',
  'EE': 'Estonia',
  'SZ': 'Eswatini',
  'ET': 'Ethiopia',
  'FK': 'Falkland Islands (Malvinas)',
  'FO': 'Faroe Islands',
  'FJ': 'Fiji',
  'FI': 'Finland',
  'FR': 'France',
  'GF': 'French Guiana',
  'PF': 'French Polynesia',
  'TF': 'French Southern Territories',
  'GA': 'Gabon',
  'GM': 'Gambia',
  'GE': 'Georgia',
  'DE': 'Germany',
  'GH': 'Ghana',
  'GI': 'Gibraltar',
  'GR': 'Greece',
  'GL': 'Greenland',
  'GD': 'Grenada',
  'GP': 'Guadeloupe',
  'GU': 'Guam',
  'GT': 'Guatemala',
  'GG': 'Guernsey',
  'GN': 'Guinea',
  'GW': 'Guinea-Bissau',
  'GY': 'Guyana',
  'HT': 'Haiti',
  'HM': 'Heard Island and McDonald Islands',
  'VA': 'Holy See',
  'HN': 'Honduras',
  'HK': 'Hong Kong',
  'HU': 'Hungary',
  'IS': 'Iceland',
  'IN': 'India',
  'ID': 'Indonesia',
  'IR': 'Iran (Islamic Republic of)',
  'IQ': 'Iraq',
  'IE': 'Ireland',
  'IM': 'Isle of Man',
  'IL': 'Israel',
  'IT': 'Italy',
  'JM': 'Jamaica',
  'JP': 'Japan',
  'JE': 'Jersey',
  'JO': 'Jordan',
  'KZ': 'Kazakhstan',
  'KE': 'Kenya',
  'KI': 'Kiribati',
  'KP': "Korea (Democratic People's Republic of)",
  'KR': 'Korea, Republic of',
  'KW': 'Kuwait',
  'KG': 'Kyrgyzstan',
  'LA': "Lao People's Democratic Republic",
  'LV': 'Latvia',
  'LB': 'Lebanon',
  'LS': 'Lesotho',
  'LR': 'Liberia',
  'LY': 'Libya',
  'LI': 'Liechtenstein',
  'LT': 'Lithuania',
  'LU': 'Luxembourg',
  'MO': 'Macao',
  'MG': 'Madagascar',
  'MW': 'Malawi',
  'MY': 'Malaysia',
  'MV': 'Maldives',
  'ML': 'Mali',
  'MT': 'Malta',
  'MH': 'Marshall Islands',
  'MQ': 'Martinique',
  'MR': 'Mauritania',
  'MU': 'Mauritius',
  'YT': 'Mayotte',
  'MX': 'Mexico',
  'FM': 'Micronesia (Federated States of)',
  'MD': 'Moldova, Republic of',
  'MC': 'Monaco',
  'MN': 'Mongolia',
  'ME': 'Montenegro',
  'MS': 'Montserrat',
  'MA': 'Morocco',
  'MZ': 'Mozambique',
  'MM': 'Myanmar',
  'NA': 'Namibia',
  'NR': 'Nauru',
  'NP': 'Nepal',
  'NL': 'Netherlands',
  'NC': 'New Caledonia',
  'NZ': 'New Zealand',
  'NI': 'Nicaragua',
  'NE': 'Niger',
  'NG': 'Nigeria',
  'NU': 'Niue',
  'NF': 'Norfolk Island',
  'MK': 'North Macedonia',
  'MP': 'Northern Mariana Islands',
  'NO': 'Norway',
  'OM': 'Oman',
  'PK': 'Pakistan',
  'PW': 'Palau',
  'PS': 'Palestine, State of',
  'PA': 'Panama',
  'PG': 'Papua New Guinea',
  'PY': 'Paraguay',
  'PE': 'Peru',
  'PH': 'Philippines',
  'PN': 'Pitcairn',
  'PL': 'Poland',
  'PT': 'Portugal',
  'PR': 'Puerto Rico',
  'QA': 'Qatar',
  'RE': 'Réunion',
  'RO': 'Romania',
  'RU': 'Russian Federation',
  'RW': 'Rwanda',
  'BL': 'Saint Barthélemy',
  'SH': 'Saint Helena, Ascension and Tristan da Cunha',
  'KN': 'Saint Kitts and Nevis',
  'LC': 'Saint Lucia',
  'MF': 'Saint Martin (French part)',
  'PM': 'Saint Pierre and Miquelon',
  'VC': 'Saint Vincent and the Grenadines',
  'WS': 'Samoa',
  'SM': 'San Marino',
  'ST': 'Sao Tome and Principe',
  'SA': 'Saudi Arabia',
  'SN': 'Senegal',
  'RS': 'Serbia',
  'SC': 'Seychelles',
  'SL': 'Sierra Leone',
  'SG': 'Singapore',
  'SX': 'Sint Maarten (Dutch part)',
  'SK': 'Slovakia',
  'SI': 'Slovenia',
  'SB': 'Solomon Islands',
  'SO': 'Somalia',
  'ZA': 'South Africa',
  'GS': 'South Georgia and the South Sandwich Islands',
  'SS': 'South Sudan',
  'ES': 'Spain',
  'LK': 'Sri Lanka',
  'SD': 'Sudan',
  'SR': 'Suriname',
  'SJ': 'Svalbard and Jan Mayen',
  'SE': 'Sweden',
  'CH': 'Switzerland',
  'SY': 'Syrian Arab Republic',
  'TW': 'Taiwan, Province of China',
  'TJ': 'Tajikistan',
  'TZ': 'Tanzania, United Republic of',
  'TH': 'Thailand',
  'TL': 'Timor-Leste',
  'TG': 'Togo',
  'TK': 'Tokelau',
  'TO': 'Tonga',
  'TT': 'Trinidad and Tobago',
  'TN': 'Tunisia',
  'TR': 'Türkiye',
  'TM': 'Turkmenistan',
  'TC': 'Turks and Caicos Islands',
  'TV': 'Tuvalu',
  'UG': 'Uganda',
  'UA': 'Ukraine',
  'AE': 'United Arab Emirates',
  'GB': 'United Kingdom of Great Britain and Northern Ireland',
  'UM': 'United States Minor Outlying Islands',
  'US': 'United States of America',
  'UY': 'Uruguay',
  'UZ': 'Uzbekistan',
  'VU': 'Vanuatu',
  'VE': 'Venezuela (Bolivarian Republic of)',
  'VN': 'Viet Nam',
  'VG': 'Virgin Islands (British)',
  'VI': 'Virgin Islands (U.S.)',
  'WF': 'Wallis and Futuna',
  'EH': 'Western Sahara',
  'YE': 'Yemen',
  'ZM': 'Zambia',
  'ZW': 'Zimbabwe',
};

// Inverso: nombre (lowercase) -> code
final Map<String, String> _nameToCode = {
  for (final e in kCountryNames.entries) e.value.toLowerCase(): e.key,
};

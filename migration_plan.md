# Null Safety Migration Plan

Branch: `nullSafetyMigration` → `master`

---

## Status: GOTOWY DO MERGE — wszystkie blokery naprawione, 30/30 testów zielonych

---

## Krytyczne regressje (blokują merge)

### 1. `project_filters.dart:15` — zły domyślny parametr dependencies
- **Problem:** Default `const [""]` zamiast `const []`. Powoduje że wszystkie `ProjectFinder().find()` zwracają pustą listę — żaden projekt nie ma zależności o nazwie `""`. Łamie ALL komendy.
- **Fix:** Usunięto zbędny parametr pośredni — `dependencies` jest teraz bezpośrednio `this.dependencies` (domyślnie null = brak filtra).
- **Plik:** `lib/src/project_finder/project_filters.dart:13-19`
- [x] Zrobione

### 2. `flutter_finder.dart:14` — błąd priorytetów operatorów
- **Problem:** `_environmentPath ?? "".split(":")` parsowane jako `_environmentPath ?? ("".split(":"))`. Gdy PATH nie-null: zwraca cały PATH string zamiast ścieżki do flutter. Gdy null: rzuca `StateError` zamiast `FlutterNotFoundException`. Stary kod miał `.firstWhere(..., orElse: () => null)?.parent?.path` — bezpieczny.
- **Fix:** Zastąpiono łańcuch funkcyjny pętlą `for` — eliminuje problem precedencji i brak `orElse`. Null PATH traktowany jak `""` (brak wyników → `FlutterNotFoundException`).
- **Plik:** `lib/src/flutter_finder/flutter_finder.dart:13-19`
- [x] Zrobione

### 3. `project_finder.dart:34` — force unwrap na nullable API
- **Problem:** `pubspec.environment!["flutter"]` — `pubspec_parse` v1.0.0 zmieniło `environment` na nullable. Crash dla każdego `pubspec.yaml` bez sekcji `environment:`. `Project` constructor i tak obsługuje null (default: `VersionConstraint.any`).
- **Fix:** Zamieniono `pubspec.environment!` na `pubspec.environment?`. `Project` constructor obsługuje null — default `VersionConstraint.any`.
- **Plik:** `lib/src/project_finder/project_finder.dart:34`
- [x] Zrobione

---

## Średnie problemy (force unwraps z TODO)

### 4. `update_flutter_sdk_command.dart:65-66` — podwójny force unwrap
- **Problem:** `RegExp(...).firstMatch(output)!.group(1)` + `Version.parse(version!)`. NPE gdy format `flutter --version` się zmieni. Deweloper zostawił TODO: "delete force unwrap".
- **Fix:** `firstMatch` przez `?.group(1)`, null → `FormatException` z treścią outputu. Usunięto oba `!`.
- **Plik:** `lib/src/command/update_flutter_sdk_command.dart:63-67`
- [x] Zrobione

---

## Testy — zakomentowane zamiast zmigrowane

### 5. Cztery pliki testowe w całości zakomentowane
- **Problem:** Zakomentowanie testów zamiast ich migracji. Brak weryfikacji że nic nie jest zepsute.
- **Pliki:**
  - `test/matchers.dart` (36 linii)
  - `test/process_starter/process_starter_test.dart` (28 linii)
  - `test/project_finder/project_finder_integration_test.dart` (115 linii)
  - `test/command/update_sdk_command_integration_test.dart` (155 linii)
- **Fix:** Odkomentowane i zmigrowane. `mockito 5` → `@GenerateMocks` + wygenerowane mocks. Brakujące stuby dodane (mockito 5 jest ścisły — niestubowane wywołania rzucają `MissingStubError`). `build_runner` podniesiony do `^2.4.0` (Dart 3 compat). **30/30 testów przechodzi.**
- [x] `test/matchers.dart`
- [x] `test/process_starter/process_starter_test.dart`
- [x] `test/project_finder/project_finder_integration_test.dart`
- [x] `test/command/update_sdk_command_integration_test.dart`

---

## Drobne

### 6. `analysis_options.yaml` — implicit-dynamic: true
- **Problem:** Osłabia null safety — analyzer nie wyłapuje implicit `dynamic`.
- **Fix:** Zmieniono `implicit-dynamic: true` na `false`. Analyzer nadal czysty — żadnych nowych naruszeń.
- **Plik:** `analysis_options.yaml:6`
- [x] Zrobione

### 7. `pubspec.yaml` — niezacommitowana zmiana
- **Problem:** Lokalna zmiana SDK upper bound `<3.0.0` → `<4.0.0` niezacommitowana.
- **Fix:** Zmiana `<3.0.0` → `<4.0.0` jest poprawna (Dart 3 support). Do zacommitowania razem z resztą zmian z tego brancha.
- **Plik:** `pubspec.yaml`
- [x] Do zacommitowania

---

## Co jest już dobrze

- [x] SDK constraint `>=2.12.0` — poprawne minimum dla null safety
- [x] Wszystkie zależności zaktualizowane do null-safe wersji
- [x] `required` użyte poprawnie we wszystkich konstruktorach
- [x] `quiver/check.dart` (checkNotNull) usunięty i zastąpiony null safety
- [x] `ProcessOutput` → named params z `required`
- [x] `MoronepoCommandRunner` default param `= const []`
- [x] `fromResults` poprawnie zwraca `T?`
- [x] Fallback `workingDirectory ?? Directory.current.path` przeniesiony do `moronepo_command.dart`
- [x] `ProjectFilters.from()` obsługuje nullable `ArgResults?`
- [x] `_extractFlag` zwraca `bool?`
- [x] Brak `@dart=2.9` opt-outów
- [x] Brak nadmiarowego `late`

---

## Kolejność napraw

1. Fix #1 — `project_filters.dart` (najszerszy wpływ)
2. Fix #2 — `flutter_finder.dart` (logika zepsuta)
3. Fix #3 — `project_finder.dart` (crash na brakującym env)
4. Fix #6 — `analysis_options.yaml` (pozwoli wyłapać inne problemy)
5. Fix #4 — `update_flutter_sdk_command.dart` (force unwraps)
6. Fix #5 — migracja testów (weryfikacja całości)
7. Fix #7 — zacommitowanie pubspec.yaml

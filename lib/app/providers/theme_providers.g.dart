// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeConfigHash() => r'92d7982e299ba755d3292538e2b59f76879b3e28';

/// 主题配置提供者 - 组合以上所有提供者
///
/// Copied from [themeConfig].
@ProviderFor(themeConfig)
final themeConfigProvider = AutoDisposeProvider<ThemeConfig>.internal(
  themeConfig,
  name: r'themeConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$themeConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ThemeConfigRef = AutoDisposeProviderRef<ThemeConfig>;
String _$currentThemeHash() => r'443286ff46c563210d00cd2e3cc2c710ed578a8a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 当前主题提供者 - 根据环境亮度选择适当的主题
///
/// Copied from [currentTheme].
@ProviderFor(currentTheme)
const currentThemeProvider = CurrentThemeFamily();

/// 当前主题提供者 - 根据环境亮度选择适当的主题
///
/// Copied from [currentTheme].
class CurrentThemeFamily extends Family<AppTheme> {
  /// 当前主题提供者 - 根据环境亮度选择适当的主题
  ///
  /// Copied from [currentTheme].
  const CurrentThemeFamily();

  /// 当前主题提供者 - 根据环境亮度选择适当的主题
  ///
  /// Copied from [currentTheme].
  CurrentThemeProvider call(
    BuildContext context,
  ) {
    return CurrentThemeProvider(
      context,
    );
  }

  @override
  CurrentThemeProvider getProviderOverride(
    covariant CurrentThemeProvider provider,
  ) {
    return call(
      provider.context,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'currentThemeProvider';
}

/// 当前主题提供者 - 根据环境亮度选择适当的主题
///
/// Copied from [currentTheme].
class CurrentThemeProvider extends AutoDisposeProvider<AppTheme> {
  /// 当前主题提供者 - 根据环境亮度选择适当的主题
  ///
  /// Copied from [currentTheme].
  CurrentThemeProvider(
    BuildContext context,
  ) : this._internal(
          (ref) => currentTheme(
            ref as CurrentThemeRef,
            context,
          ),
          from: currentThemeProvider,
          name: r'currentThemeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentThemeHash,
          dependencies: CurrentThemeFamily._dependencies,
          allTransitiveDependencies:
              CurrentThemeFamily._allTransitiveDependencies,
          context: context,
        );

  CurrentThemeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
  }) : super.internal();

  final BuildContext context;

  @override
  Override overrideWith(
    AppTheme Function(CurrentThemeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentThemeProvider._internal(
        (ref) => create(ref as CurrentThemeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AppTheme> createElement() {
    return _CurrentThemeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentThemeProvider && other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CurrentThemeRef on AutoDisposeProviderRef<AppTheme> {
  /// The parameter `context` of this provider.
  BuildContext get context;
}

class _CurrentThemeProviderElement extends AutoDisposeProviderElement<AppTheme>
    with CurrentThemeRef {
  _CurrentThemeProviderElement(super.provider);

  @override
  BuildContext get context => (origin as CurrentThemeProvider).context;
}

String _$themeModeNotifierHash() => r'1533795fc3e6e68ff75c9e811d2ce4f623d5a588';

/// 主题模式提供者
///
/// Copied from [ThemeModeNotifier].
@ProviderFor(ThemeModeNotifier)
final themeModeNotifierProvider =
    AutoDisposeNotifierProvider<ThemeModeNotifier, ThemeMode>.internal(
  ThemeModeNotifier.new,
  name: r'themeModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeModeNotifier = AutoDisposeNotifier<ThemeMode>;
String _$themeColorsNotifierHash() =>
    r'ffff60c2fb454555a0f7023011b6a4e2b4fdda0e';

/// 自定义主题颜色提供者
///
/// Copied from [ThemeColorsNotifier].
@ProviderFor(ThemeColorsNotifier)
final themeColorsNotifierProvider = AutoDisposeNotifierProvider<
    ThemeColorsNotifier, ({Color primary, Color secondary})>.internal(
  ThemeColorsNotifier.new,
  name: r'themeColorsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeColorsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeColorsNotifier
    = AutoDisposeNotifier<({Color primary, Color secondary})>;
String _$fontFamilyNotifierHash() =>
    r'af19dde708e824a30adc383073cf9720922cdd97';

/// 字体系列提供者
///
/// Copied from [FontFamilyNotifier].
@ProviderFor(FontFamilyNotifier)
final fontFamilyNotifierProvider =
    AutoDisposeNotifierProvider<FontFamilyNotifier, String>.internal(
  FontFamilyNotifier.new,
  name: r'fontFamilyNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fontFamilyNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FontFamilyNotifier = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

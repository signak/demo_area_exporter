import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'logger.dart';

/// usage:
/// ```dart
/// final versionInfo = await initVersionInfoProvider();
/// print(versionInfo.data.toString());
///
/// ProviderScope(
///   overrides: [
///     versionInfo.providerOverride,
///   ],
///   child: ...
/// ),
/// ```
final versionInfoProvider = Provider<PackageInfo>(
  (ref) =>
      throw UnimplementedError('should overrideWithValue versionInfoProvider'),
);

class VersionInfoInitResult {
  const VersionInfoInitResult._({
    required this.data,
    required this.providerOverride,
  });

  final PackageInfo data;
  final Override providerOverride;
}

Future<VersionInfoInitResult> initVersionInfoProvider(
    {bool shouldOutputVersionsToLog = false}) async {
  final info = await _VersionUtil.getInfo();
  if (shouldOutputVersionsToLog) {
    logger.i(info.toString());
  }
  return VersionInfoInitResult._(
    data: info,
    providerOverride: versionInfoProvider.overrideWithValue(info),
  );
}

class _VersionUtil {
  const _VersionUtil._();

  static Future<PackageInfo> getInfo() async {
    return await PackageInfo.fromPlatform();
  }
}

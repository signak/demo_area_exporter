import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// usage:
/// ```dart
/// final info = await initDeviceInfoProvider();
/// print(info.data.toString());
///
/// ProviderScope(
///   overrides: [
///     info.providerOverride,
///   ],
///   child: ...
/// ),
/// ```
final deviceInfoProvider = Provider<DeviceInfo>(
  (ref) =>
      throw UnimplementedError('should overrideWithValue deviceInfoProvider'),
);

class DeviceInfoInitResult {
  const DeviceInfoInitResult._({
    required this.data,
    required this.providerOverride,
  });

  final DeviceInfo data;
  final Override providerOverride;
}

Future<DeviceInfoInitResult> initDeviceInfoProvider() async {
  final info = await _DeviceUtil.buildInfo();
  return DeviceInfoInitResult._(
    data: info,
    providerOverride: deviceInfoProvider.overrideWithValue(info),
  );
}

class _DeviceUtil {
  const _DeviceUtil._();

  static Future<DeviceInfo> buildInfo() async {
    final ret =
        await DeviceInfoPlugin().webBrowserInfo.then<DeviceInfo>((info) {
      final String appVersion = info.appVersion!.toLowerCase();
      final isAndroid = appVersion.contains('android');
      final isLinux = !isAndroid && appVersion.contains('linux');

      final isIOS =
          appVersion.contains('iphone') || appVersion.contains('ipad');
      final isMacOS = !isIOS && appVersion.contains('macintosh');

      final isWindows = appVersion.contains('windows');
      return DeviceInfo(
          appVersion: appVersion,
          isAndroid: isAndroid,
          isLinux: isLinux,
          isIOS: isIOS,
          isMacOS: isMacOS,
          isWindows: isWindows);
    });
    return ret;
  }
}

class DeviceInfo {
  DeviceInfo({
    required this.appVersion,
    isAndroid = false,
    isWindows = false,
    isIOS = false,
    isMacOS = false,
    isLinux = false,
  })  : _isAndroid = isAndroid,
        _isWindows = isWindows,
        _isIOS = isIOS,
        _isMacOS = isMacOS,
        _isLinux = isLinux;

  final String appVersion;
  final bool _isAndroid;
  final bool _isWindows;
  final bool _isIOS;
  final bool _isMacOS;
  final bool _isLinux;

  bool get isAndroid => _isAndroid;
  bool get isWindows => _isWindows;
  bool get isIOS => _isIOS;
  bool get isMacOS => _isMacOS;
  bool get isLinux => _isLinux;

  bool get isDesktop => isWindows || isMacOS || isLinux;
  bool get isMobile => isAndroid || isIOS;

  @override
  String toString() {
    return 'DeviceInfo(isAndroid: $isAndroid, isWindows: $isWindows, isIOS: $isIOS, isMacOS: $isMacOS, isLinux: $isLinux, isDesktop: $isDesktop, isMobile: $isMobile, appVersion: "$appVersion")';
  }
}

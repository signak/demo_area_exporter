import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Usage:
/// import 'package:wl_obs_capp/core/util/logger.dart';
/// logger.d('some log message.');
final logger = Logger(
  level: (kDebugMode) ? Level.debug : Level.info,
  filter: _SimpleLogFilter(),
  printer: (kDebugMode)
      ? PrettyPrinter(
          methodCount: 1, // 表示されるコールスタックの数
          errorMethodCount: 5, // 表示されるスタックトレースのコールスタックの数
          // lineLength: 120, // 出力するログ1行の幅
          // colors: true, // メッセージに色をつけるかどうか
          // printEmojis: true, // 絵文字を出力するかどうか
          printTime: true, // タイムスタンプを出力するかどうか
          excludeBox: {
            Level.debug: true,
          },
        )
      : SimplePrinter(printTime: true),
);

class _SimpleLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.index >= level!.index;
  }
}

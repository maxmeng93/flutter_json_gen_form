import './reg.dart';

/// 验证器
///
/// - required 必填
/// - type 快捷校验类型，只针对文本输入框
///   - email 邮箱
///   - url 网址
/// - min string 类型时为字符串长度；number 类型时为确定数字； array 类型时为数组长度
/// - max string 类型时为字符串长度；number 类型时为确定数字； array 类型时为数组长度
/// - len string 类型时为字符串长度；number 类型时为确定数字； array 类型时为数组长度
/// - pattern 正则校验
/// - message 错误提示信息
validator(String? label, dynamic value, List<dynamic>? rules) {
  if (rules == null || rules.isEmpty) {
    return null;
  }

  for (var rule in rules) {
    // 必填校验
    if (rule['required'] == true &&
        (value == null || value == '' || (value is List && value.isEmpty))) {
      return rule['message'] ?? '$label必填';
    }

    String msg = rule['message'] ?? '验证失败';

    // 正则校验
    if (rule['pattern'] != null) {
      final regExp = RegExp(rule['pattern']);
      if (!regExp.hasMatch(value)) {
        return msg;
      }
    }

    // min校验
    if (rule['min'] != null) {
      if (value is String && value.length < rule['min']) {
        return msg;
      }
      if (value is num && value < rule['min']) {
        return msg;
      }
      if (value is List && value.length < rule['min']) {
        return msg;
      }
    }

    // max校验
    if (rule['max'] != null) {
      if (value is String && value.length > rule['max']) {
        return msg;
      }
      if (value is num && value > rule['max']) {
        return msg;
      }
      if (value is List && value.length > rule['max']) {
        return msg;
      }
    }

    // len校验
    if (rule['len'] != null) {
      if (value is String && value.length != rule['len']) {
        return msg;
      }
      if (value is num && value != rule['len']) {
        return msg;
      }
      if (value is List && value.length != rule['len']) {
        return msg;
      }
    }

    // type校验
    if (rule['type'] != null && value is String) {
      switch (rule['type']) {
        case 'email':
          if (!emailRegExp.hasMatch(value)) return msg;
          break;
        case 'url':
          if (!urlRegExp.hasMatch(value)) return msg;
          break;
      }
    }
  }

  return null;
}

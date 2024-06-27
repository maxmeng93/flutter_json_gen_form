/// 邮箱
final emailRegExp = RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$');

/// 中国手机号
final phoneRegExp = RegExp(r'^1\d{10}$');

/// url
final urlRegExp = RegExp(r'^http(s)?:\/\/\S+$');

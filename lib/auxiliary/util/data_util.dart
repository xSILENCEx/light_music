import 'dart:isolate';

class DataUtil {
  ///传入数字，对数据进行格式化
  static detailNum(dynamic num) {
    try {
      if (num is String) {
        num = double.parse(num);
      }
      RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      String _mathFunc(Match match) => '${match[1]},';
      String temp;
      if (num < 1000) {
        return num.toString().replaceAllMapped(reg, _mathFunc);
      } else if (num >= 1000 && num < 10000) {
        temp = (num / 1000).toStringAsFixed(1);
        return '${temp}k'.replaceAllMapped(reg, _mathFunc);
      } else if (num >= 10000 && num < 100000) {
        temp = (num / 1000).toStringAsFixed(0);
        return '${temp}k'.replaceAllMapped(reg, _mathFunc);
      } else if (num >= 100000 && num < 1000000) {
        temp = (num / 1000000).toStringAsFixed(1);
        return '${temp}m'.replaceAllMapped(reg, _mathFunc);
      } else if (num >= 1000000 && num < 10000000) {
        temp = (num / 1000000).toStringAsFixed(0);
        return '${temp}m'.replaceAllMapped(reg, _mathFunc);
      } else if (num >= 10000000 && num < 100000000) {
        temp = (num / 100000000).toStringAsFixed(1);
        return '${temp}b'.replaceAllMapped(reg, _mathFunc);
      } else if (num >= 100000000 && num < 1000000000) {
        temp = (num / 100000000).toStringAsFixed(0);
        return '${temp}b'.replaceAllMapped(reg, _mathFunc);
      }
    } catch (e) {
      print("转换数据出错:$e");
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  ///通过isolate传入两个list，返回比对结果(对第一个list进行处理)
  static Future<dynamic> asyncCalculate(List<dynamic> content) async {
    final response = ReceivePort();
    await Isolate.spawn(_cal, response.sendPort);
    final sendPort = await response.first as SendPort;

    final answer = ReceivePort();
    sendPort.send([content, answer.sendPort]);

    return answer.first;
  }

  ///asyncCalculate的辅助函数
  static _cal(SendPort initialReplyTo) async {
    final port = ReceivePort();
    initialReplyTo.send(port.sendPort);

    port.listen((message) {
      final data = message[0] as List<dynamic>;
      final send = message[1] as SendPort;

      send.send(_calMethod(data));
    });
  }

  ///asyncCalculate计算方法
  static _calMethod(List<dynamic> l) {
    final List<dynamic> _tempList = List.from(l[0]);
    final int x = l[0].length, y = l[1].length;

    for (int i = 0; i < y; i++) {
      for (int j = 0; j < x; j++) {
        if (l[0][j]['username'] == l[1][i]['username']) {
          _tempList.remove(l[0][j]);
          break;
        }
      }
    }

    print('result length:${_tempList.length}');

    return _tempList;
  }

  ///////////////////////////////////////////////////////////////////////////
  ///通过isolate传入一个list和一个用户信息，返回一个bool，该用户是否在列表中
  static Future<dynamic> asyncIsFollowed(
      List<dynamic> list, String user) async {
    final response = ReceivePort();
    await Isolate.spawn(_calIsFollowed, response.sendPort);
    final sendPort = await response.first as SendPort;

    final answer = ReceivePort();
    sendPort.send([
      [list, user],
      answer.sendPort
    ]);

    return answer.first;
  }

  ///asyncIsFollowed的辅助函数
  static _calIsFollowed(SendPort initialReplyTo) async {
    final port = ReceivePort();
    initialReplyTo.send(port.sendPort);

    port.listen((message) {
      final data = message[0] as List<dynamic>;
      final send = message[1] as SendPort;

      send.send(_calIsFollowedMethod(data));
    });
  }

  ///asyncIsFollowed计算方法
  static _calIsFollowedMethod(List<dynamic> l) {
    bool have = false;

    l[0].forEach((f) {
      if (f['username'] == l[1]) {
        have = true;
        return;
      }
    });

    return have;
  }

  ///////////////////////////////////////////////////////////////////////////

  ///以下方法为图表日期格式化
  ///传入yyyy-mm-dd格式的日期，返回yy.mm.dd格式的日期
  static formatWeekDate(String dateTime) {
    final List<String> dateList = dateTime.split('-');
    final String result =
        dateList[0].substring(2) + '.' + dateList[1] + '.' + dateList[2];

    return result;
  }

  ///传入yyyy-mm-dd格式的日期，返回yyyy.mm格式的日期
  static formatMonthDate(String dateTime) {
    final List<String> dateList = dateTime.split('-');
    final String result = dateList[0] + '.' + dateList[1];

    return result;
  }

  ///传入yyyy-mm-dd格式的日期，返回mm.dd格式的日期
  static formatDayDate(String dateTime) {
    final List<String> dateList = dateTime.split('-');
    final String result = dateList[1] + '.' + dateList[2];

    return result;
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sharing_photo_notes/utils/log_data.dart';

class HttpConnection {
  final String tag = 'tag HttpConnection';
  /// 註冊user
  Future<String> toServer({String ip = "", String path = "", String json = "",required Map<String,String> headerMap}) async{
    Uri url = Uri.http(ip,path);
    String back = "";
    var response = await http.post(url,headers: headerMap ,body: json);
    if(response.statusCode == 200) {
      LogData().d(tag, 'statusCode 200');
      back = const Utf8Decoder().convert(response.bodyBytes);
    }
    LogData().dd(tag, 'back', back.toString());
    return back;
  }

  Future<String> uploadDatabaseImage({String ip = "", String path = "", String json = "",required Map<String,String> headerMap}) async{
    Uri url = Uri.http(ip,path);
    String back = "";
    var response = await http.post(url,headers: headerMap ,body: json);
    if(response.statusCode == 200) {
      LogData().d(tag, 'statusCode 200');
      back = Utf8Decoder().convert(response.bodyBytes);
    }
    LogData().dd(tag, 'back', back.toString());
    return back;
  }
  Future<String> getDatabaseImage({String ip = "", String path = "", String json = "",required Map<String,String> headerMap}) async{
    Uri url = Uri.http(ip,path);
    String back = "";
    var response = await http.post(url,headers: headerMap ,body: json);
    if(response.statusCode == 200) {
      LogData().d(tag, 'statusCode 200');
      back = Utf8Decoder().convert(response.bodyBytes);
    }
    LogData().dd(tag, 'back', back.toString());
    return back;
  }
}
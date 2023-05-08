import 'package:http/http.dart' as http;
class HttpConnection {

  /// 註冊user
  Future<String> toServer(String ip, String path, String json) async{
    var backJson = 'empty';
    Uri url = Uri.http(ip,path);
    var response = await http.post(url, body: json);

    if(response.statusCode == 200) {
      backJson = response.body;
    }
    return backJson;
  }
}
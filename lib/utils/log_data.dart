class LogData {
  final flag = false;
  d(String tag,String message){
    if(flag) print('$tag : $message');
  }
  dd(String tag,String title,String message){
    if(flag) print('$title : $message');
  }
}
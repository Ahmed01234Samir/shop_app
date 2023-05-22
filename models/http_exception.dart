class HttpExcepction implements Exception{
  final String message;

  HttpExcepction(this.message);


  @override
  String toString() {
    
    return message;
  }
}
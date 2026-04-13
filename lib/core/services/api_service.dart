import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio) {
    addInterceptors();
  }

  void addInterceptors() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['User-Agent'] = 'FlutterApp';
          options.headers['Accept-Language'] = 'en';
          return handler.next(options);
        },
      ),
    );
  }

  Future<dynamic> get({
    required String baseUrl,
    required String endPoint,
  }) async {
    final Response response = await _dio.get('$baseUrl$endPoint');
    return response.data;
  }
}

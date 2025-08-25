import 'package:dio/dio.dart';


const String kTmdbApiKey = String.fromEnvironment('TMDB_API_KEY', defaultValue: 'REPLACE_WITH_YOUR_TMDB_KEY');
const String kDefaultLanguage = 'en-US';
const String kDefaultRegion = 'IN';

class TmdbApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final params = Map<String, dynamic>.from(options.queryParameters);
    params.putIfAbsent('api_key', () => kTmdbApiKey);
    params.putIfAbsent('language', () => kDefaultLanguage);
    options.queryParameters = params;
    super.onRequest(options, handler);
  }
}

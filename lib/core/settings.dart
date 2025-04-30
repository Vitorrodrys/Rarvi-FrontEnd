import 'package:envied/envied.dart';

part 'settings.g.dart';



@Envied(path: 'test.env')
final class Settings {
  @EnviedField(varName: 'api_url')
  static const String apiUrl = _Settings.apiUrl;

  
}
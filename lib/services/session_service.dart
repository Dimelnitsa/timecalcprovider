
import '../domain/data_provider/session_data_provider.dart';

class SessionService {

  final _sessionDataProvider = SessionDataProvider();

  Future<void> saveLastSession(String nameSession)async{
    await _sessionDataProvider.saveLastSet(nameSession);
  }

  Future<String?> getLastSession()async{
    var nameSession = await _sessionDataProvider.getLastSet();
    return nameSession;
  }


}
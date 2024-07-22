import 'package:authentication_demo/ui/store/auth_store.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void setLocator() {
  locator.registerLazySingleton<AuthStore>(
    () => AuthStore(),
  );
}

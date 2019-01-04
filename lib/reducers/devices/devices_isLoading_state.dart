import 'package:redux/redux.dart';
import '../../actions/users.dart';

final isLoadingDevicesReducer = combineReducers<bool>([
  TypedReducer<bool, QueryDevicePendingAction>(_setIsLoading),
  TypedReducer<bool, QueryDeviceSuccessAction>(_setIsNotLoading),
  TypedReducer<bool, QueryDeviceFailureAction>(_setIsNotLoading),
]);

bool _setIsLoading(bool state, dynamic action) {
  return true;
}

bool _setIsNotLoading(bool state, dynamic action) {
  return false;
}
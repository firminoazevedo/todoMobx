import 'package:mobx/mobx.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {

  _LoginStore(){
    autorun((_){
      //print(email);
      //print(password+ 'password');
    });
  }

  @observable
  bool showPassword = true;

  @action
  void  changeShowPassword() => showPassword = !showPassword;

  @observable
  bool isLoading = false;

  @observable
  bool isLogged = false;

  @action
  Future<void> login() async{
    isLoading = true;
    await Future.delayed(Duration(seconds: 2));
    isLoading = false;
    isLogged = true;
  }

  @observable
  String email = '';

  @action
  void setEmail(String value) => email = value;

  @observable  
  String password = '';

  @action
  void setPassword(String value) => password = value;

  @computed
  bool get isEmailValid => email.length > 6;

  @computed
  bool get isPasswordValid => password.length > 6;

  @computed
  bool get isFormValid => isEmailValid && isPasswordValid;

  @action
  void logout(){
    isLogged = false;
    email = '';
    password = '';
  }

}
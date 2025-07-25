import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/elements/BlockButtonWidget.dart';
import 'package:deliveryboy/src/helpers/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import 'package:deliveryboy/src/controllers/user_controller.dart';

class ForgetPasswordWidget extends StatefulWidget {
  @override
  _ForgetPasswordWidgetState createState() => _ForgetPasswordWidgetState();
}

class _ForgetPasswordWidgetState extends AppStateX<ForgetPasswordWidget> {
  UserController? _con;

  _ForgetPasswordWidgetState() : super(controller: UserController()) {
    _con = controller as UserController?;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con?.scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(37),
                decoration: BoxDecoration(color: Theme.of(context).shadowColor),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(37) - 120,
              child: Container(
                width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(37),
                child: Text(
                  S.of(context).email_to_reset_password,
                  style: Theme.of(context).textTheme.headlineMedium?.merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(37) - 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [BoxShadow(blurRadius: 50, color: Theme.of(context).hintColor.withValues(alpha: 0.2))],
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 27),
                width: config.App(context).appWidth(88),
                child: Form(
                  key: _con?.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => _con?.user!.email = input,
                        validator: (input) => !input!.contains('@') ? S.of(context).should_be_a_valid_email : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).email,
                          labelStyle: TextStyle(color: Theme.of(context).shadowColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'johndoe@gmail.com',
                          hintStyle: TextStyle(color: Theme.of(context).focusColor.withValues(alpha: 0.7)),
                          prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).shadowColor),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withValues(alpha: 0.2))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withValues(alpha: 0.5))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withValues(alpha: 0.2))),
                        ),
                      ),
                      SizedBox(height: 30),
                      BlockButtonWidget(
                        text: Text(S.of(context).send_password_reset_link, style: TextStyle(color: Theme.of(context).primaryColor)),
                        color: Theme.of(context).shadowColor,
                        onPressed: () => _con?.resetPassword(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: Column(
                children: <Widget>[
                  MaterialButton(
                    elevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/Login'),
                    textColor: Theme.of(context).hintColor,
                    child: Text(S.of(context).i_remember_my_password_return_to_login),
                  ),
                  MaterialButton(
                    elevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/SignUp'),
                    textColor: Theme.of(context).hintColor,
                    child: Text(S.of(context).i_dont_have_an_account),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

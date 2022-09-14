import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wine_app/firebase.dart';
import '../components/filled_rounded_button.dart';

///     S I G N   U P   S C R E E N
///    - This is the screen the user sees when signing up.
///    - The http.dart file checks that the user does not already exist, prior to registering
///      a new user, otherwise prompts the user to log in.
///    - Form entry validation is conducted using a flutter FormKey.
///    - After a successful sign up the user is redirected to the load up screen.

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  // Allows for form validation
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // The visibility of error prompts are toggled using boolean variables
  bool _alreadyRegistered = false;

  // Default values
  String _email = '';
  String _password = '';
  String _passwordConfirm = '';
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    // Universal input decoration with styling
    // TextFields are varied using the default styling .copWith their unique properties
    InputDecoration textFormFieldDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white),
      ),
      hintStyle: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 18,
        color: Colors.grey.withOpacity(0.7),
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Builds App Logo
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/Logo.png',
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                Padding(
                  // 10% padding on all sides
                  padding:
                  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.05, horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.09,
                        backgroundImage:
                        const AssetImage('assets/default_profile.jpg'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Login Text
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      //Conditional text acts as error prompts
                      Visibility(
                        visible: _alreadyRegistered,
                        child: Text(
                          'Email already registered, try logging in.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Email form field
                      TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFormFieldDecoration.copyWith(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.email,
                                color: Colors.grey,
                                size: 26,
                              ),
                            ),
                            hintText: 'E-mail'),
                        onChanged: (value) {
                          _email = value;
                        },
                        // Null check confirmed during validation
                        onSaved: (String? input) => _email = input!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter email';
                          } else {
                            // Regex to confirm a valid email address
                            bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);
                            if (!emailValid) {
                              return 'Enter a valid email address';
                            } else {
                              // The return of null acts as a pass
                              return null;
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 13),
                      // Build password form field
                      TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        obscureText: _obscurePassword,
                        decoration: textFormFieldDecoration.copyWith(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 26,
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: IconButton(
                                icon: const FaIcon(FontAwesomeIcons.eye),
                                color: _obscurePassword
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.secondary,
                                iconSize: 23,
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            hintText: 'Password'),
                        onChanged: (value) {
                          _password = value;
                        },
                        // Null check confirmed during validation
                        onSaved: (String? input) => _password = input!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password';
                          } else {
                            // The return of null acts as a pass
                            return null;
                          }
                          // No further validation for security purposes
                        },
                      ), //Forgot Password ButtonText
                      const SizedBox(height: 13),
                      // Build confirm password form field
                      TextFormField(
                        obscureText: _obscurePassword,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (String value) {
                          _password = value;
                        },
                        decoration: textFormFieldDecoration.copyWith(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 26,
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: IconButton(
                                icon:
                                const FaIcon(FontAwesomeIcons.eye),
                                color: _obscurePassword
                                    ? Colors.grey
                                    : Theme.of(context)
                                    .colorScheme
                                    .secondary,
                                iconSize: 23,
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword =
                                    !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            hintText: 'Confirm'),
                        onChanged: (value) {
                          setState(
                                () {
                              _passwordConfirm = value;
                            },
                          );
                        },
                        // Null check confirmed during validation
                        onSaved: (String? input) =>
                        _passwordConfirm = input!,
                        autocorrect: false,
                        validator: (value) {
                          return _validatePassword(value);
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Login Button
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                        height: 1.4 *
                            (MediaQuery.of(context).size.height / 20),
                        width:
                        6 * (MediaQuery.of(context).size.width / 10),
                        child: FilledRoundedButton(
                          buttonText: 'Sign up',
                          onPressed: _validateInputs,
                          color: Theme.of(context).colorScheme.secondary,
                          // Keep default flutter fonts
                          applyFont: false,
                        ),
                      ),
                      //Sign Up Text
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Have an account?',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize:
                                MediaQuery.of(context).size.height / 40,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: ' Login',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize:
                                MediaQuery.of(context).size.height / 40,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ]),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Check that password is 8 characters long and contains at least on uppercase letter, lowercase letter and digit
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter password';
    } else {
      // Check password length
      if (!RegExp(r'^.{8,}$').hasMatch(value)) {
        return 'Must be at least 8 characters long';
        // Check for a lowercase letter
      } else if (!RegExp(r'^.*?[a-z].*$').hasMatch(value)) {
        return 'Must contain at least 1 lowercase character.';
        // Check for an uppercase letter
      } else if (!RegExp(r'^.*?[A-Z].*$').hasMatch(value)) {
        return 'Must contain at least 1 uppercase character.';
        // Check for digits
      } else if (!RegExp(r'^.*?[0-9].*$').hasMatch(value)) {
        return 'Must contain at least 1 number.';
        // Check whether confirmation password matches the original
      } else if (_password != _passwordConfirm) {
        return 'Password do not match';
      } else {
        return null;
      }
    }
  }

  void _validateInputs() {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState?.validate() != null) {
      final validForm = _formKey.currentState!.validate();
      if (validForm) {
        _formKey.currentState!.save();
        _userSignUp();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _userSignUp() async {
    String? fetchedAuthToken =
    await FirebaseServices().userSignUp(_email, _password, context);
    setState(() {
      _alreadyRegistered = false;
      _isLoading = false;
    });
    if (fetchedAuthToken == null) {
      // Then the users email is already registered in the database.
      setState(() {
        _alreadyRegistered = true;
      });
    } else {
      // Store token on device for automatic future login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', fetchedAuthToken);
      //Navigate to loading screen
      Navigator.pushNamed(context, '/home');
    }
  }
}

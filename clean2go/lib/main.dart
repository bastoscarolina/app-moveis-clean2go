import 'package:clean2go/provider/cleaners_list_page.dart';
import 'package:clean2go/provider/cleaning_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'supabase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'provider/auth_provider.dart';




// Change to true to enable authentication
// with Google Sign In
const authenticationEnabled = false;


// Sample supbase_options.dart file:
//
// const Map<Symbol, dynamic> supabaseOptions = {
//   #url: 'https://qwerty.supabase.co',
//   #anonKey: '1234567890',
// };
void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Function.apply(Supabase.initialize, [], supabaseOptions);


  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: authenticationEnabled ? AuthenticationWrapper() : CleanersListPage(),
      ),
    ),
  );
}




class AuthenticationWrapper extends ConsumerWidget {
  const AuthenticationWrapper({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);


    return authStateAsync.when(
      data: (AuthState state) {
        return state.session == null ? const SignInPage() : const CleanersListPage();
      },
      loading: () =>
      const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, __) {
        return Scaffold(body: Center(child: Text('Error: $error')));
      },
    );
  }
}


class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}




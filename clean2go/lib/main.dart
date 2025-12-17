import 'package:clean2go/provider/properties_list_page.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_options.dart'; // Importa o Map que criamos acima
import 'provider/auth_provider.dart';

// Change to true to enable authentication
// with Google Sign In
const authenticationEnabled = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sua lógica original mantida:
  await Function.apply(Supabase.initialize, [], supabaseOptions);

  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: authenticationEnabled ? AuthenticationWrapper() : PropertiesListPage(),
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
        return state.session == null ? const SignInPage() : const PropertiesListPage();
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/database_service.dart';
import 'providers/transaction_provider.dart';
import 'providers/category_provider.dart';
import 'providers/account_provider.dart';
import 'providers/recurring_transaction_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/category_list_screen.dart';
import 'screens/recurring_transaction_list_screen.dart';
import 'screens/add_recurring_transaction_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/loan_provider.dart';
import 'providers/currency_provider.dart';
import 'screens/loan_list_screen.dart';
import 'screens/add_loan_screen.dart';
import 'screens/account_list_screen.dart';
import 'screens/add_account_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider()..fetchTransactions(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider()..initCategories(),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountProvider()..initAccounts(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              RecurringTransactionProvider()
                ..checkAndGenerateRecurringTransactions(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<DatabaseService, LoanProvider>(
          create: (_) => LoanProvider(DatabaseService()),
          update: (_, db, previous) => previous ?? LoanProvider(db),
        ),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Hacksilver Ledger',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: themeProvider.seedColor,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              textTheme: GoogleFonts.outfitTextTheme(),
              appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: themeProvider.seedColor,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              textTheme: GoogleFonts.outfitTextTheme(
                ThemeData.dark().textTheme,
              ),
              appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
            ),
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const DashboardScreen(),
              '/transactions': (context) => const TransactionListScreen(),
              '/add-transaction': (context) => const AddTransactionScreen(),
              '/categories': (context) => const CategoryListScreen(),
              '/recurring-transactions': (context) =>
                  const RecurringTransactionListScreen(),
              '/add-recurring-transaction': (context) =>
                  const AddRecurringTransactionScreen(),
              '/loans': (context) => const LoanListScreen(),
              '/add-loan': (context) => const AddLoanScreen(),
              '/accounts': (context) => const AccountListScreen(),
              '/add-account': (context) => const AddAccountScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}

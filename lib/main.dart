import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/calculation/data/datasources/calculation_local_datasource.dart';
import 'features/calculation/data/repositories/calculation_repository_impl.dart';
import 'features/calculation/data/services/export_service.dart';
import 'features/calculation/domain/usecases/calculate_profit.dart';
import 'features/calculation/domain/usecases/manage_history.dart';
import 'features/calculation/presentation/providers/calculation_provider.dart';
import 'features/calculation/presentation/screens/calculation_screen.dart';
import 'features/calculation/presentation/screens/history_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection
    final localDataSource = CalculationLocalDataSource.instance;
    final repository = CalculationRepositoryImpl(
      localDataSource: localDataSource,
    );
    final calculateProfit = CalculateProfitUseCase();
    final saveCalculation = SaveCalculationUseCase(repository);
    final getHistory = GetHistoryUseCase(repository);
    final deleteCalculation = DeleteCalculationUseCase(repository);
    final clearHistory = ClearHistoryUseCase(repository);
    final exportService = ExportService();

    return ChangeNotifierProvider(
      create: (_) => CalculationProvider(
        calculateProfit: calculateProfit,
        saveCalculation: saveCalculation,
        getHistory: getHistory,
        deleteCalculation: deleteCalculation,
        clearHistory: clearHistory,
        exportService: exportService,
      ),
      child: MaterialApp(
        title: 'Profit Calculator',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', ''), Locale('tr', '')],
        home: const MainNavigator(),
      ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [CalculationScreen(), HistoryScreen()];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            HapticFeedback.selectionClick();
            setState(() => _currentIndex = index);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.calculate_outlined),
              selectedIcon: const Icon(Icons.calculate_rounded),
              label: l10n.calculator,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: const Icon(Icons.history_rounded),
              label: l10n.history,
            ),
          ],
        ),
      ),
    );
  }
}

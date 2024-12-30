import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Sayfalar
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/application_page.dart';
import 'pages/profile_page.dart';

// Tema
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopernik Pizza',
      theme: AppTheme.theme,
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return snapshot.hasData ? MainPage() : LoginPage();
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ApplicationsPage(),
    ProfilesPage(),
  ];

  String getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Ana Sayfa';
      case 1:
        return 'Başvurularım';
      case 2:
        return 'Profilim';
      default:
        return '';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  toolbarHeight: 70,
  title: LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = constraints.maxWidth; // AppBar'ın genişliğini al
      return Stack(
        alignment: Alignment.center,
        children: [
          // Metni sola hizala
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              getPageTitle(_selectedIndex),
              style: const TextStyle(color: AppTheme.secondaryColor, fontSize: 21, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Logoyu merkezden 48 piksel sağa kaydır
          Align(
            alignment: Alignment(
              (30.0 / (screenWidth / 2)), // X ekseninde 48 piksel kaydırma
              0.0, // Y ekseninde kaydırma yok
            ),
            child: Image.asset(
              'assets/images/logo.png',
              height: 60,
            ),
          ),
        ],
      );
    },
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.logout, color: AppTheme.secondaryColor, size: 28),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
      },
    ),
  ],
),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppTheme.secondaryColor,
        unselectedItemColor: AppTheme.textLightColor,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
            backgroundColor: AppTheme.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Başvurular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilim',
          ),
        ],
      ),
    );
  }
}

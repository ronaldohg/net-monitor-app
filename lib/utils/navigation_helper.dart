import 'package:flutter/material.dart';
import '../screens/about_screen.dart';

class NavigationHelper {
  static void navigateToAbout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutScreen()),
    );
  }

  static Widget buildStandardDrawer(BuildContext context, String currentScreen) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Radiobases App'),
            accountEmail: Text('Versión 1.0.0'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.cell_tower,
                color: Colors.blue,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.home,
            title: 'Inicio',
            isSelected: currentScreen == 'home',
            onTap: () {
              Navigator.pop(context);
              if (currentScreen != 'home') {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.list,
            title: 'Radiobases 3G',
            isSelected: currentScreen == '3g',
            onTap: () {
              Navigator.pop(context);
              if (currentScreen != '3g') {
                Navigator.pushNamedAndRemoveUntil(context, '/3g', (route) => false);
              }
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.list,
            title: 'Radiobases 4G',
            isSelected: currentScreen == '4g',
            onTap: () {
              Navigator.pop(context);
              if (currentScreen != '4g') {
                Navigator.pushNamedAndRemoveUntil(context, '/4g', (route) => false);
              }
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context: context,
            icon: Icons.person,
            title: 'Acerca de',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              NavigationHelper.navigateToAbout(context);
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.help,
            title: 'Ayuda',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              // Navegar a pantalla de ayuda futura
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}
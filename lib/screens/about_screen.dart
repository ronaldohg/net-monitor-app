import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar o logo del desarrollador
            CircleAvatar(
              radius: 90,
              backgroundImage: AssetImage('assets/perfil.jpg'),),
            const SizedBox(height: 20),
            
            // Nombre del desarrollador
            const Text(
              'Ronaldo Hernández García',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Titulo o especialidad
            const Text(
              'Desarrollador Flutter & Dart',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Tarjeta de información
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoItem(
                      icon: Icons.phone,
                      title: 'Contacto',
                      value: '+5352183532',
                    ),
                    _buildInfoItem(
                      icon: Icons.email,
                      title: 'Email',
                      value: 'ronaldo.hernandez@etecsa.cu',
                    ),
                    _buildInfoItem(
                      icon: Icons.location_on,
                      title: 'Ubicación',
                      value: 'Sancti Spiritus, Cuba',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Descripción
            const Text(
              'Sobre la Aplicación',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 10),
            
            const Text(
              'Esta aplicación fue desarrollada para la gestión y consulta de información '
              'de radiobases 3G y 4G. Permite la búsqueda, edición y exportación de datos '
              'de manera eficiente, integrando también información en tiempo real de las '
              'celdas móviles.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 30),
            
            // Redes sociales o enlaces
            const Text(
              'Conéctate conmigo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 15),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(
                  icon: Icons.code,
                  color: Colors.orange,
                  onTap: () => _launchURL('https://github.com/ronaldohg/net-monitor-app/'),
                  tooltip: 'GitHub',
                ),
                _buildSocialButton(
                  icon: Icons.work,
                  color: Colors.blue,
                  onTap: () => _launchURL('https://www.linkedin.com/in/ronaldo-hernandez-garcia/'),
                  tooltip: 'LinkedIn',
                ),/*
                _buildSocialButton(
                  icon: Icons.web,
                  color: Colors.green,
                  onTap: () => _launchURL('https://tuweb.com'),
                  tooltip: 'Sitio Web',
                ),*/
              ],
            ),
            
            const SizedBox(height: 10),
            
            // Información técnica
            Card(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Información Técnica',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTechInfo('Versión', '1.0.3'),
                    _buildTechInfo('Flutter', '3.0+'),
                    _buildTechInfo('Base de datos', 'SQLite'),
                    _buildTechInfo('Última actualización', '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
        icon: Icon(icon),
        color: color,
        iconSize: 30,
        onPressed: onTap,
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildTechInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
# net_monitor_cubano

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Radiobases App 📡

A Flutter application for reading provider cell info in real time. It can also managing and querying 3G and 4G radiobase information with an SQLite database and Excel import/export capabilities.

## 🚀 Features

- **Read Cell Info in real-time**: Search for current cell tower informetion in live
- **Smart Search**: Search for cell towers by CI (4G) or PSC (3G)
- **Complete Management**: Add, delete, and view cell towers
- **Export/Import**: Excel support
- **Local Database**: SQLite for offline storage
- **Intuitive Interface**: Simple and responsive navigation

## 📸 Screenshots

*(Add screenshots after running the application)*

## 🛠️ Technologies Used

- **Flutter** - UI Framework
- **Dart** - Programming Language
- **SQLite** - Local Database
- **Excel** - Data Export/Import
- **File Picker** - File Selection

## 📋 Prerequisites

- Flutter SDK 3.0+
- Dart SDK 2.19+
- Android Studio / VS Code
- Android/iOS Device or Emulator

## ⚙️ Installation

1. **Clone the repository**

    ```bash
    git clone https://github.com/your-username/radiobases-app.git
    cd radiobases-app

2. **Install dependencies**

    ```bash
    flutter pub get

3. **Run the application**

    ```bash
    flutter run

## 🗂️ Project Structure

    lib/

    ├── main.dart # Entry point

    ├── screens/ # Application screens

    │ ├── home_screen.dart # Main search screen

    │ ├── rb3g_list_screen.dart # List of 3G radio base stations

    │ ├── rb4g_list_screen.dart # List of 4G radio base stations

    │ ├── add_rb3g_screen.dart # 3G Add Form

    │ └── add_rb4g_screen.dart # 4G Add Form

    ├── models/ # Data Models

    │ ├── radiobase3g.dart # 3G Radio Base Model

    │ └── radiobase4g.dart # 4G Radio Base Model

    ├── database/ # Database Layer

    │ └── database_helper.dart # SQLite Helper

    └── utils/ # Utilities

    └── excel_helper.dart # Excel File Management

## 📱 Using the Application

# Home Screen

- Select radio base station type (3G/4G)
- Enter CI (4G) or PSC (3G)
- Press "Search" to query

# 3G Radio Base Station Management

- View complete list of 3G radio base stations
- Swipe to delete
- "+" button to add new ones
- Options menu: Export/Import to Excel

# 4G Radio Base Station Management

- View complete list of 4G radio base stations
- Swipe to delete
- "+" button to add new ones
- Options menu: Export/Import to Excel

## 🗃️ Database

# The application uses SQLite with two tables:

# Table: radiobases3g

- id (INTEGER PRIMARY KEY)
- name (TEXT NOT NULL)
- psc (TEXT NOT NULL UNIQUE)

# Table: radiobases4g

- id (INTEGER PRIMARY KEY)
- nombre (TEXT NOT NULL)
- ci (TEXT NOT NULL UNIQUE)

## 📊 Excel Format

    3G Export:
    PSC Name
    RB3G_001 123
    RB3G_002 456
    4G Export:
    CI Name
    RB4G_001 789
    RB4G_002 012

## 🐛 Troubleshooting

**Android Permission Error**
**Ensure that the android/app/src/main/AndroidManifest.xml file has the necessary permissions.**

**Dependencies not found Run:**

    '''bash
    flutter clean
    flutter pub get
    Problems with SQLite
    The database is automatically created on the first run.

## 🤝 Contributions

Contributions are welcome. Please:

Fork the project
Create a branch for your feature (git checkout -b feature/AmazingFeature)
Commit your changes (git commit -m 'Add some AmazingFeature')
Push to the branch (git push origin feature/AmazingFeature)

Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

Ronaldo Hernandez Garcia
GitHub: @ronaldohg

## 🙏 Acknowledgments

Flutter Team for the excellent framework
Dart/Flutter Developer Community
Found a bug? Open an issue

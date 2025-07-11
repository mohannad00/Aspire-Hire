# 🚀 AspireHire - Your Professional Career Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.7.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.7.0+-blue.svg)](https://dart.dev/)

AspireHire is a comprehensive job recruitment and networking platform built with Flutter, designed to connect job seekers, employees, and companies in a professional ecosystem. The platform features separate interfaces for different user types, advanced job matching, social networking capabilities, and professional tools.

## ✨ Features

### 🔐 Authentication & User Management
- **Multi-User Registration**: Support for Job Seekers, Employees, and Companies
- **Secure Authentication**: Email/password login with JWT tokens
- **Password Management**: Reset and recovery functionality
- **Email Verification**: Account confirmation system
- **Role-Based Access**: Different interfaces for each user type

### 💼 Job Management
- **Job Posting**: Companies can create and manage job listings
- **Advanced Job Search**: Filter by location, skills, experience, and more
- **Job Applications**: Streamlined application process with resume upload
- **Application Tracking**: Real-time status updates for applications
- **ATS Integration**: Resume evaluation against job requirements

### 👥 Social & Networking
- **Professional Feed**: News feed with industry-relevant content
- **Post Creation**: Share updates, achievements, and professional content
- **Community Features**: Connect with professionals in your field
- **Friend/Connection System**: Build your professional network
- **Comments & Engagement**: Interactive social features

### 🛠️ Professional Tools
- **CV Generation**: AI-powered resume creation
- **ATS Evaluation**: Resume optimization for Applicant Tracking Systems
- **Skill Testing**: Assessment tools for skill verification
- **Summary Generation**: Professional summary creation
- **Profile Management**: Comprehensive profile editing

### 📱 User Experience
- **Responsive Design**: Works across all platforms (iOS, Android, Web, Desktop)
- **Multi-Language Support**: Arabic and English localization
- **Dark/Light Theme**: Customizable appearance
- **Offline Support**: Cached data for offline access
- **Real-time Updates**: Live notifications and updates

## 🏗️ Architecture

### Technology Stack
- **Framework**: Flutter 3.7.0+
- **Language**: Dart 3.7.0+
- **State Management**: Flutter Bloc (Cubit pattern)
- **HTTP Client**: Dio
- **Local Storage**: Shared Preferences
- **Image Handling**: Cached Network Image, Image Picker
- **PDF Processing**: PDF viewer and generator
- **UI Components**: Custom components with Shimmer loading effects

### Project Structure
```
aspirehire/
├── 📁 lib/
│   ├── 📁 config/           # Configuration files
│   │   ├── 📁 datasources/  # API and cache configuration
│   │   └── 📁 routes/       # Route configuration
│   ├── 📁 core/             # Core application components
│   │   ├── 📁 components/   # Reusable UI components
│   │   ├── 📁 models/       # Data models (35+ models)
│   │   └── 📁 utils/        # Utility classes
│   └── 📁 features/         # Feature modules (30+ features)
│       ├── 📁 auth/         # Authentication
│       ├── 📁 job_*         # Job-related features
│       ├── 📁 profile/      # Profile management
│       ├── 📁 community/    # Social features
│       └── 📁 tools/        # Professional tools
├── 📁 assets/               # Static assets
│   ├── 📁 fonts/           # Custom fonts
│   ├── 📁 icons/           # SVG icons
│   ├── 📁 images/          # Image assets
│   └── 📁 translations/    # Localization files
└── 📁 platform_specific/   # Platform-specific code
```

### Clean Architecture
The project follows Clean Architecture principles:
- **Presentation Layer**: UI components and state management
- **Domain Layer**: Business logic and data models
- **Data Layer**: API calls and local storage

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.0 or higher
- Dart SDK 3.7.0 or higher
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/aspirehire.git
   cd aspirehire
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Copy `.env.example` to `.env`
   - Update API endpoints and configuration

4. **Run the application**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d chrome    # Web
   flutter run -d android   # Android
   flutter run -d ios       # iOS
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📊 Project Statistics

- **35+ Data Models**: Comprehensive data structures
- **35+ Cubits**: State management for all features
- **30+ Features**: Complete feature modules
- **Multi-Platform**: iOS, Android, Web, Desktop support
- **2 Languages**: Arabic and English support

## 🎯 Key Features Breakdown

### Authentication System
- User registration (3 types: Job Seeker, Employee, Company)
- Secure login with JWT tokens
- Password reset and recovery
- Email verification system

### Job Platform
- Job posting and management
- Advanced search with filters
- Application tracking system
- ATS integration for resume evaluation

### Social Networking
- Professional news feed
- Post creation and sharing
- Community features
- Friend/connection management

### Professional Tools
- AI-powered CV generation
- ATS evaluation tools
- Skill assessment system
- Professional summary creation

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Run tests**
   ```bash
   flutter test
   ```
5. **Commit your changes**
   ```bash
   git commit -m "Add: your feature description"
   ```
6. **Push to the branch**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create a Pull Request**

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting

## 🛠️ Development

### State Management
The project uses Flutter Bloc with Cubit pattern for state management:
- Each feature has its own Cubit
- States are immutable and use Equatable
- Clear separation of concerns

### API Integration
- Centralized API configuration
- Dio for HTTP requests
- Proper error handling
- Token-based authentication

### UI/UX
- Material Design principles
- Responsive layouts
- Loading states with Shimmer
- Custom components for reusability

## 📞 Support

If you have any questions or need support:
- Create an issue on GitHub
- Contact the development team
- Check the documentation

---

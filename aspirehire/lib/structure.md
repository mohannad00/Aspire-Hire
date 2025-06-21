# AspireHire - Flutter Project Structure

## Project Overview
AspireHire is a comprehensive job recruitment and networking platform built with Flutter, featuring separate interfaces for job seekers, employees, and companies.

## Technology Stack
- **Framework**: Flutter (SDK >=3.7.0)
- **State Management**: Flutter Bloc (Cubit pattern)
- **HTTP Client**: Dio
- **Local Storage**: Shared Preferences
- **Image Handling**: Cached Network Image, Image Picker
- **UI Components**: Custom components with Shimmer loading effects
- **PDF Handling**: PDF viewer and generator
- **Internationalization**: Multi-language support (Arabic/English)

## Project Structure

```
aspirehire/
├── 📁 android/                    # Android platform-specific code
├── 📁 ios/                       # iOS platform-specific code
├── 📁 web/                       # Web platform-specific code
├── 📁 windows/                   # Windows platform-specific code
├── 📁 macos/                     # macOS platform-specific code
├── 📁 linux/                     # Linux platform-specific code
├── 📁 test/                      # Test files
├── 📁 assets/                    # Static assets
│   ├── 📁 fonts/                 # Custom fonts (Pacifico)
│   ├── 📁 icons/                 # SVG icons
│   ├── 📁 images/                # Image assets
│   ├── 📁 translations/          # Localization files (ar.json, en.json)
│   └── 📄 Various PNG files      # UI assets and logos
├── 📁 lib/                       # Main Dart source code
│   ├── 📄 main.dart              # Application entry point
│   ├── 📁 config/                # Configuration files
│   │   ├── 📁 datasources/       # Data sources configuration
│   │   │   ├── 📁 api/           # API configuration
│   │   │   │   ├── api_consumer.dart
│   │   │   │   ├── end_points.dart
│   │   │   │   └── status_code.dart
│   │   │   └── 📁 cache/         # Cache configuration
│   │   │       └── shared_pref.dart
│   │   └── 📁 routes/            # Route configuration
│   ├── 📁 core/                  # Core application components
│   │   ├── 📁 components/        # Reusable UI components
│   │   │   ├── ReusableAppBar.dart
│   │   │   ├── ReusableBackButton.dart
│   │   │   ├── ReusableButton.dart
│   │   │   └── [Other components]
│   │   ├── 📁 entities/          # Business entities
│   │   ├── 📁 models/            # Data models
│   │   │   ├── Application.dart
│   │   │   ├── ATSEvaluation.dart
│   │   │   ├── Comment.dart
│   │   │   └── [32+ other models]
│   │   └── 📁 utils/             # Utility classes
│   │       ├── app_colors.dart
│   │       ├── app_fonts.dart
│   │       ├── app_images.dart
│   │       └── [Other utilities]
│   └── 📁 features/              # Feature modules (Clean Architecture)
│       ├── 📁 auth/              # Authentication module
│       │   ├── 📁 company_register/    # Company registration
│       │   │   ├── SignUpEmailCompany.dart
│       │   │   ├── SignUpPasswordCompany.dart
│       │   │   ├── SignUpPhoneCompany.dart
│       │   │   └── 📁 state_management/
│       │   ├── 📁 employee_register/   # Employee registration
│       │   │   ├── SignUpEmailEmployee.dart
│       │   │   ├── SignUpPasswordEmployee.dart
│       │   │   ├── SignUpPhoneEmployee.dart
│       │   │   └── 📁 state_management/
│       │   ├── 📁 jobseeker_register/  # Job seeker registration
│       │   │   ├── SignUpEmailJobSeeker.dart
│       │   │   ├── SignUpPasswordJobSeeker.dart
│       │   │   ├── SignUpPhoneJobSeeker.dart
│       │   │   └── 📁 state_management/
│       │   ├── 📁 login/         # Login functionality
│       │   │   ├── LoginScreen.dart
│       │   │   └── 📁 state_management/
│       │   ├── 📁 resend_confirm/      # Email confirmation
│       │   │   ├── resend_confirm_cubit.dart
│       │   │   ├── resend_confirm_state.dart
│       │   │   └── resend_confirmation_screen.dart
│       │   └── 📁 reset_password/      # Password reset
│       │       ├── forget_password_screen.dart
│       │       ├── LoginResetPass.dart
│       │       ├── LoginVerifyAcc.dart
│       │       └── 📁 state_management/
│       ├── 📁 onboarding/        # Onboarding screens
│       │   ├── OnboardingPage.dart
│       │   ├── OnboardingScreen.dart
│       │   └── 📁 state_management/
│       ├── 📁 choosing_role/     # Role selection
│       │   └── ChoosingRole.dart
│       ├── 📁 splash_screen/     # Splash screen
│       │   ├── splash_screen.dart
│       │   └── 📁 state_management/
│       ├── 📁 home_screen/       # Home screen functionality
│       │   ├── 📁 components/    # Home screen components
│       │   ├── HomeCompany.dart
│       │   ├── HomeScreenJobSeeker.dart
│       │   └── 📁 state_management/
│       ├── 📁 hame_nav_bar/      # Home navigation bar
│       │   └── home_nav_bar.dart
│       ├── 📁 company_home_nav_bar/    # Company navigation
│       │   └── company_home_nav_bar.dart
│       ├── 📁 company_home_screen/     # Company home screen
│       │   ├── company_home_screen.dart
│       │   └── 📁 components/
│       │       ├── CompanyHomeHeader.dart
│       │       ├── CompanyHomeHeaderSkeleton.dart
│       │       └── CompanyWritePostSkeleton.dart
│       ├── 📁 feed/              # News feed functionality
│       │   ├── 📁 components/    # Feed components
│       │   ├── 📁 screens/       # Feed screens
│       │   └── 📁 state_management/
│       ├── 📁 company_feed/      # Company-specific feed
│       │   ├── 📁 components/
│       │   │   ├── CompanyCommentBottomSheet.dart
│       │   │   ├── CompanyPostCard.dart
│       │   │   └── CompanyPostCardSkeleton.dart
│       │   └── 📁 state_management/
│       │       ├── company_comment_cubit.dart
│       │       ├── company_comment_state.dart
│       │       ├── company_feed_cubit.dart
│       │       └── [Other state files]
│       ├── 📁 create_post/       # Post creation functionality
│       │   ├── 📁 components/
│       │   │   ├── PostOptions.dart
│       │   │   └── [Other components]
│       │   ├── CreatePost.dart
│       │   └── 📁 state_management/
│       ├── 📁 company_create_post/      # Company post creation
│       │   ├── CompanyCreatePost.dart
│       │   └── 📁 state_management/
│       │       ├── company_create_post_cubit.dart
│       │       └── company_create_post_state.dart
│       ├── 📁 community/         # Community features
│       │   ├── communityScreen.dart
│       │   ├── 📁 components/
│       │   │   ├── FriendsCard.dart
│       │   │   ├── RequestCard.dart
│       │   │   ├── SectionHeader.dart
│       │   │   └── [Other components]
│       │   ├── 📁 state_management/
│       │   │   ├── comment_cubit.dart
│       │   │   ├── comment_state.dart
│       │   │   ├── follower_cubit.dart
│       │   │   └── [Other state files]
│       │   ├── test_follower_cubit.dart
│       │   └── test.dart
│       ├── 📁 company_community/ # Company community features
│       │   └── 📁 state_management/
│       │       ├── company_comment_cubit.dart
│       │       └── company_comment_state.dart
│       ├── 📁 job_search/        # Job search functionality
│       │   ├── 📁 components/    # Search components
│       │   ├── JobSearch.dart
│       │   └── 📁 state_management/
│       ├── 📁 job_post/          # Job posting functionality
│       │   ├── 📁 components/    # Job post components
│       │   ├── PostJob.dart
│       │   ├── 📁 screens/       # Job post screens
│       │   └── 📁 state_management/
│       ├── 📁 job_application/   # Job application functionality
│       │   ├── 📁 create_job_application/
│       │   ├── 📁 get_job_application/
│       │   ├── 📁 get_job_applications/
│       │   ├── 📁 update_job_application/
│       │   └── JobApply.dart
│       ├── 📁 applications/      # Applications management
│       │   ├── 📁 state_management/
│       │   │   ├── applications_cubit.dart
│       │   │   └── applications_state.dart
│       │   ├── 📁 ui/
│       │   │   ├── application_card.dart
│       │   │   └── applications_screen.dart
│       ├── 📁 my_applications/   # User's applications
│       │   └── myApplicationScreen.dart
│       ├── 📁 people_search/     # People search functionality
│       │   ├── search_screen.dart
│       │   └── 📁 state_management/
│       ├── 📁 seeker_profile/    # Job seeker profile
│       │   ├── 📁 archive/       # Archived content
│       │   ├── 📁 components/    # Profile components
│       │   ├── 📁 screens/       # Profile screens
│       │   ├── 📁 state_management/
│       │   ├── EditEducation.dart
│       │   ├── EditExperience.dart
│       │   └── EditProfile.dart
│       ├── 📁 company_profile/   # Company profile
│       │   ├── company_profile_cubit.dart
│       │   ├── company_profile_screen.dart
│       │   └── company_profile_state.dart
│       ├── 📁 company_edit_profile/     # Company profile editing
│       │   └── company_edit_profile.dart
│       ├── 📁 menu_screen/       # Menu functionality
│       │   └── MenuScreen.dart
│       ├── 📁 skill_test/        # Skill testing functionality
│       │   ├── skill_selection_screen.dart
│       │   ├── skill_test_screen.dart
│       │   └── 📁 state_management/
│       ├── 📁 ats_evaluate/      # ATS evaluation
│       │   ├── 📁 screens/
│       │   │   ├── ats_input_screen.dart
│       │   │   └── ats_result_screen.dart
│       │   └── 📁 state_management/
│       │       ├── ats_evaluate_cubit.dart
│       │       └── ats_evaluate_state.dart
│       ├── 📁 generate_cv/       # CV generation
│       │   ├── 📁 screens/
│       │   └── 📁 state_management/
│       └── 📁 generate_summary/  # Summary generation
│           ├── 📁 screens/
│           └── 📁 state_management/
├── 📄 pubspec.yaml               # Dependencies and project configuration
├── 📄 pubspec.lock               # Locked dependency versions
├── 📄 analysis_options.yaml      # Dart analysis configuration
├── 📄 README.md                  # Project documentation
└── 📄 .gitignore                 # Git ignore rules
```

## Architecture Overview

### Clean Architecture Pattern
The project follows Clean Architecture principles with clear separation of concerns:

1. **Presentation Layer** (`features/`): UI components, screens, and state management
2. **Domain Layer** (`core/models/`, `core/entities/`): Business logic and data models
3. **Data Layer** (`config/datasources/`): API calls, local storage, and data sources

### State Management
- Uses **Flutter Bloc** with **Cubit** pattern for state management
- Each feature has its own state management folder
- Consistent naming: `{feature}_cubit.dart` and `{feature}_state.dart`

### Feature Organization
Each feature is self-contained with:
- UI components and screens
- State management (Cubit/State)
- Business logic
- API integration

### Key Features
1. **Multi-User Types**: Job seekers, employees, and companies
2. **Authentication**: Registration, login, password reset
3. **Job Management**: Posting, searching, applying
4. **Social Features**: Community, posts, comments
5. **Profile Management**: User and company profiles
6. **ATS Integration**: Resume evaluation
7. **CV Generation**: Automated CV creation
8. **Skill Testing**: Assessment functionality

### Dependencies
- **UI**: Flutter SVG, Carousel Slider, Shimmer, Custom Refresh Indicator
- **State Management**: Flutter Bloc, Equatable
- **Network**: Dio for HTTP requests
- **Storage**: Shared Preferences, File Picker
- **PDF**: PDF viewer and generator
- **Internationalization**: Multi-language support

## Development Guidelines

### File Naming
- Use PascalCase for Dart files
- Use snake_case for folder names
- Follow feature-based organization

### State Management
- Each feature should have its own Cubit
- Use Equatable for state comparison
- Keep state classes immutable

### UI Components
- Create reusable components in `core/components/`
- Use consistent styling with `core/utils/`
- Implement loading states with Shimmer

### API Integration
- Centralized API configuration in `config/datasources/api/`
- Use Dio for HTTP requests
- Implement proper error handling

This structure provides a scalable and maintainable foundation for the AspireHire application, following Flutter best practices and Clean Architecture principles. 
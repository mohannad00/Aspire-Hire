# AspireHire Project - Data Models, Cubits & Features Count

## 📊 Project Statistics Summary

### 🎯 Total Counts
- **Data Models**: 35 models
- **Cubits**: 35 cubits
- **Features**: 30 main features
- **State Classes**: 35 state classes

---

## 📋 Data Models (35 Total)

### Core Models (`lib/core/models/`)
1. **Company.dart** - Company entity model
2. **CvResponse.dart** - CV generation response
3. **CvRequest.dart** - CV generation request
4. **SummaryResponse.dart** - Summary generation response
5. **SummaryRequest.dart** - Summary generation request
6. **ATSEvaluation.dart** - ATS evaluation model
7. **JobPost.dart** - Job posting model
8. **Feed.dart** - Feed/Post model
9. **GetProfile.dart** - Profile retrieval model
10. **UpdateProfileRequest.dart** - Profile update request
11. **Application.dart** - Job application model
12. **Resume.dart** - Resume model
13. **RecommendedJobPost.dart** - Recommended jobs model
14. **UserProfile.dart** - User profile model
15. **SkillTest.dart** - Skill test model
16. **Friend.dart** - Friend/Connection model
17. **Follower.dart** - Follower model
18. **Login.dart** - Login model
19. **SearchProfileDTO.dart** - Search profile data transfer object
20. **Comment.dart** - Comment model
21. **Post.dart** - Post model
22. **CompanyRegistration.dart** - Company registration model
23. **JobseekerRegistration.dart** - Job seeker registration model
24. **EmployeeRegistration.dart** - Employee registration model
25. **DeleteProfilePicture.dart** - Profile picture deletion model
26. **UploadResume.dart** - Resume upload model
27. **UpdateProfilePicture.dart** - Profile picture update model
28. **CreateJobPost.dart** - Job post creation model
29. **GetJobApplications.dart** - Job applications retrieval model
30. **GetJobApplication.dart** - Single job application model
31. **UpdateJobApplication.dart** - Job application update model
32. **CreateJobApplication.dart** - Job application creation model
33. **RequestPasswordReset.dart** - Password reset request model
34. **ResendConfirmation.dart** - Email confirmation resend model
35. **UpdateJobPost.dart** - Job post update model

---

## 🎮 Cubits (35 Total)

### Authentication Cubits
1. **LoginCubit** - User login functionality
2. **CompanyRegisterCubit** - Company registration
3. **EmployeeRegisterCubit** - Employee registration
4. **JobSeekerRegisterCubit** - Job seeker registration
5. **ResendConfirmCubit** - Email confirmation resend
6. **RequestPasswordResetCubit** - Password reset request
7. **PasswordResetCubit** - Password reset functionality

### Profile & User Management Cubits
8. **ProfileCubit** - User profile management
9. **UserProfileCubit** - User profile operations
10. **CompanyProfileCubit** - Company profile management

### Job Management Cubits
11. **CreateJobPostCubit** - Job post creation
12. **UpdateJobPostCubit** - Job post updates
13. **DeleteJobPostCubit** - Job post deletion
14. **GetJobPostCubit** - Job post retrieval
15. **SearchJobPostsCubit** - Job post search
16. **GetRecommendedJobsCubit** - Recommended jobs

### Job Application Cubits
17. **CreateJobApplicationCubit** - Job application creation
18. **GetJobApplicationCubit** - Single application retrieval
19. **GetJobApplicationsCubit** - Multiple applications retrieval
20. **UpdateJobApplicationCubit** - Application updates
21. **ApplicationsCubit** - Applications management

### Social Features Cubits
22. **FeedCubit** - News feed management
23. **LikeCubit** - Post liking functionality
24. **CommentCubit** - Comment management
25. **PostCubit** - Post management
26. **FriendCubit** - Friend/connection management
27. **FollowerCubit** - Follower management

### Company-Specific Cubits
28. **CompanyFeedCubit** - Company feed management
29. **CompanyCommentCubit** - Company comment management
30. **CompanyLikeCubit** - Company post liking
31. **CompanyCreatePostCubit** - Company post creation

### Utility Cubits
32. **SkillTestCubit** - Skill testing functionality
33. **ATSEvaluateCubit** - ATS evaluation
34. **GenerateCvCubit** - CV generation
35. **GenerateSummaryCubit** - Summary generation
36. **SearchUsersCubit** - User search functionality

---

## 🏗️ Features (30 Total)

### Authentication & Onboarding
1. **auth/** - Complete authentication system
   - Login functionality
   - Company registration
   - Employee registration
   - Job seeker registration
   - Password reset
   - Email confirmation

2. **onboarding/** - User onboarding screens
3. **choosing_role/** - Role selection interface
4. **splash_screen/** - Application splash screen

### Core Navigation & Home
5. **home_screen/** - Main home screen functionality
6. **hame_nav_bar/** - Home navigation bar
7. **company_home_nav_bar/** - Company navigation bar
8. **company_home_screen/** - Company home screen
9. **menu_screen/** - Menu functionality

### Social & Community Features
10. **feed/** - News feed functionality
11. **company_feed/** - Company-specific feed
12. **create_post/** - Post creation for users
13. **company_create_post/** - Post creation for companies
14. **community/** - Community features
15. **company_community/** - Company community features

### Job Management
16. **job_search/** - Job search functionality
17. **job_post/** - Job posting system
18. **job_application/** - Job application system
19. **applications/** - Applications management
20. **my_applications/** - User's applications

### Profile Management
21. **seeker_profile/** - Job seeker profile management
22. **company_profile/** - Company profile management
23. **company_edit_profile/** - Company profile editing
24. **people_search/** - People search functionality

### Professional Tools
25. **skill_test/** - Skill testing system
26. **ats_evaluate/** - ATS evaluation tool
27. **generate_cv/** - CV generation tool
28. **generate_summary/** - Summary generation tool

---

## 📈 State Management Analysis

### State Classes (35 Total)
Each cubit has a corresponding state class:
- **Initial States**: Loading/initial states
- **Loading States**: Processing states
- **Loaded States**: Success states with data
- **Error States**: Error handling states
- **Specific States**: Feature-specific states (e.g., ProfileUpdated, QuizSubmitted)

### State Management Pattern
- **Flutter Bloc** with **Cubit** pattern
- **Equatable** for state comparison
- **Immutable** state classes
- **Feature-based** organization

---

## 🎯 Feature Categories Breakdown

### 🔐 Authentication & Security (4 features)
- User registration (3 types)
- Login system
- Password management
- Email verification

### 👥 Social & Networking (6 features)
- News feed
- Post creation
- Community features
- Friend/connection management
- Comments and likes

### 💼 Job & Career (5 features)
- Job posting
- Job search
- Job applications
- Application management
- Professional tools

### 👤 Profile & User Management (4 features)
- User profiles
- Company profiles
- Profile editing
- People search

### 🛠️ Professional Tools (4 features)
- Skill testing
- ATS evaluation
- CV generation
- Summary generation

### 🏠 Core App Features (7 features)
- Navigation
- Home screens
- Menu system
- Onboarding
- Splash screen

---

## 📊 Complexity Analysis

### High Complexity Features
- **auth/** - Multiple user types, complex registration flows
- **seeker_profile/** - Extensive profile management
- **job_post/** - Complete job posting system
- **feed/** - Social media-like functionality

### Medium Complexity Features
- **job_application/** - Application workflow
- **community/** - Social networking features
- **skill_test/** - Assessment system

### Low Complexity Features
- **splash_screen/** - Simple loading screen
- **choosing_role/** - Basic role selection
- **menu_screen/** - Navigation menu

---

## 🎨 Architecture Highlights

### Clean Architecture Implementation
- **Presentation Layer**: UI components and state management
- **Domain Layer**: Business logic and data models
- **Data Layer**: API integration and local storage

### State Management Consistency
- All features follow the same Cubit pattern
- Consistent naming conventions
- Proper error handling
- Loading state management

### Feature Organization
- Self-contained feature modules
- Clear separation of concerns
- Reusable components
- Scalable structure

This comprehensive analysis shows that AspireHire is a well-structured, feature-rich application with 35 data models, 35 cubits, and 30 main features, demonstrating excellent architectural practices and comprehensive functionality for a job recruitment platform. 
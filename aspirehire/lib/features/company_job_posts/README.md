# Company Job Posts Feature

This feature allows companies to view all their posted job positions in a dedicated screen.

## Features

- **View Job Posts**: Display all job posts created by the company
- **Job Status**: Shows whether each job post is active or archived
- **Job Details**: Displays comprehensive information including:
  - Job title and category
  - Salary information
  - Location (city and country)
  - Job type and period
  - Required skills (with chip display)
  - Posting date
  - Application count (placeholder for future implementation)
- **Empty State**: Shows a helpful message when no job posts exist
- **Pull to Refresh**: Allows users to refresh the job posts list
- **Error Handling**: Displays appropriate error messages and retry options

## File Structure

```
lib/features/company_job_posts/
├── company_job_posts_screen.dart          # Main screen
├── components/
│   └── company_job_post_card.dart         # Job post card component
├── state_management/
│   ├── company_job_posts_cubit.dart       # Business logic
│   └── company_job_posts_state.dart       # State definitions
└── README.md                              # This file
```

## Usage

The feature is integrated into the company navigation bar as a "My Jobs" tab. Users can access it by:

1. Logging in as a company user
2. Navigating to the "My Jobs" tab in the bottom navigation
3. Viewing their job posts or creating new ones

## API Integration

The feature uses the existing profile endpoint (`/profile`) to fetch job posts data. The job posts are extracted from the `jobPosts` field in the profile response.

## State Management

Uses BLoC pattern with the following states:
- `CompanyJobPostsInitial`: Initial state
- `CompanyJobPostsLoading`: Loading state
- `CompanyJobPostsSuccess`: Success state with job posts data
- `CompanyJobPostsFailure`: Error state with error message

## Dependencies

- `flutter_bloc`: State management
- `dio`: HTTP client for API calls
- `equatable`: For state comparison
- Existing app components and models

## Future Enhancements

- Add job post editing functionality
- Add job post deletion
- Add application management for each job post
- Add job post analytics
- Add job post archiving/unarchiving
- Add search and filtering capabilities 
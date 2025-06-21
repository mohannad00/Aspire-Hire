# Job Applications Feature

This feature allows companies to view all applications for a specific job post, providing comprehensive applicant information and management capabilities.

## Features

- **View Applications**: Display all applications for a specific job post
- **Applicant Information**: Show applicant details including name, profile picture, and application date
- **Application Status**: Color-coded status badges (Pending, Accepted, Rejected, Under Review)
- **Cover Letter Preview**: Display a preview of the applicant's cover letter
- **Resume Download**: Download button for applicant resumes (placeholder for future implementation)
- **Application Details**: Navigate to detailed application view with comprehensive information
- **Accept/Decline Applications**: Accept or decline pending applications with API integration
- **Pull to Refresh**: Refresh applications list
- **Error Handling**: Proper error states and retry functionality
- **Enhanced Empty State**: Comprehensive empty state when no applications exist, including job post details and tips for getting more applications

## Navigation

The feature is accessed by:
1. Going to "My Jobs" tab in company navigation
2. Clicking on any job post card
3. Viewing all applications for that specific job post

## API Integration

Uses the endpoint: `GET /jobpost/:jobPostId/application`

The endpoint returns application data including:
- Applicant profile information
- Cover letter content
- Resume file information
- Application status
- Application date

### API Response Structure
```json
{
    "success": true,
    "data": {
        "_id": "685461e2a80edc8b01e46b00",
        "jobPost": "684831e5fd4a896203792b4e",
        "employeeId": "6841da8c765a1597bf51f5dc",
        "coverLetter": "Cover letter content...",
        "resume": {
            "secure_url": "https://res.cloudinary.com/...",
            "public_id": "hiro/pdf/jobs/..."
        },
        "status": "Pending",
        "createdAt": "2025-06-19T19:15:46.451Z",
        "updatedAt": "2025-06-19T19:15:46.451Z",
        "employee": [
            {
                "profileId": "6841da8c765a1597bf51f5dc",
                "role": "Employee",
                "profilePicture": {
                    "secure_url": "https://res.cloudinary.com/..."
                },
                "firstName": "Farouk",
                "lastName": "Elbaz"
            }
        ]
    }
}
```

### Error Handling
- **404 Errors**: Treated as "no applications yet" - shows empty state instead of error
- **Network Errors**: Displayed with retry functionality
- **Other Errors**: Shown with appropriate error messages
- **Model Parsing**: Handles both string and object formats for jobPost field

## File Structure

```
lib/features/job_applications/
├── job_applications_screen.dart          # Main screen
├── components/
│   └── application_card.dart             # Application card component
├── state_management/
│   ├── job_applications_cubit.dart       # Business logic
│   └── job_applications_state.dart       # State definitions
└── README.md                             # This file
```

## Models

### JobApplication
Main model containing all application data:
- `id`: Application ID
- `jobPost`: Job post information
- `employeeId`: Employee ID
- `coverLetter`: Cover letter content
- `resume`: Resume file information
- `status`: Application status
- `createdAt`: Application date
- `employee`: Employee profile information

### Employee
Employee profile information:
- `profileId`: Employee profile ID
- `role`: Employee role
- `profilePicture`: Profile picture URL
- `firstName`: First name
- `lastName`: Last name

### Resume
Resume file information:
- `secureUrl`: Download URL
- `publicId`: File ID

## State Management

Uses BLoC pattern with the following states:
- `JobApplicationsInitial`: Initial state
- `JobApplicationsLoading`: Loading state
- `JobApplicationsSuccess`: Success state with applications data
- `JobApplicationsFailure`: Error state with error message

## UI Components

### ApplicationCard
Displays individual application information:
- Applicant profile picture and name
- Application date
- Status badge with color coding
- Cover letter preview (truncated to 150 characters)
- Resume download button

### JobApplicationsScreen
Main screen showing:
- Job post title in header
- List of applications
- Enhanced empty state when no applications exist, including:
  - Job post details card
  - Tips for getting more applications
  - Refresh and edit job post buttons
- Error state with retry functionality
- Pull-to-refresh capability

## Empty State Handling

When a job post has no applications, the screen displays a comprehensive empty state with:

### Visual Elements
- Large people outline icon in a circular container
- Clear "No Applications Yet" title
- Job post details card showing title, type, period, salary, and location

### Informational Content
- Explanatory text about why no applications are shown
- Tips section with actionable advice:
  - Make job description clear and detailed
  - Set competitive salary range
  - Include required skills and qualifications
  - Share job post on social media and job boards

### Action Buttons
- **Refresh**: Reload applications
- **Edit Job Post**: Navigate to edit job post screen (future feature)

## Usage

1. **Access**: Navigate to "My Jobs" tab and tap any job post
2. **View Applications**: See all applications for the selected job post
3. **Empty State**: If no applications exist, view job details and tips
4. **Application Details**: Tap any application card to view comprehensive details
5. **Accept/Decline**: Use accept/decline buttons for pending applications
6. **Resume Download**: Tap download button to get applicant resume (future feature)
7. **Refresh**: Pull down to refresh the applications list

## Future Enhancements

- Application filtering and sorting
- Resume download functionality
- Application analytics and insights
- Email notifications for new applications
- Bulk application management
- Application notes and comments
- Edit job post functionality from empty state 
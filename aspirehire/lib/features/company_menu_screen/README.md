# Company Menu Screen

A dedicated menu screen for company users, providing easy access to company-specific features and management tools.

## Features

- **Company Profile Display**: Shows company name and profile picture in the header
- **My Job Posts**: Quick access to view all company job posts
- **Post New Job**: Navigate to job posting screen
- **Search People**: Access to people search functionality
- **Analytics**: Placeholder for future analytics features
- **Settings**: Placeholder for future settings features
- **Logout**: Secure logout functionality with confirmation dialog

## Design

- **Gradient Background**: Professional gradient from primary blue to gray
- **Animated Cards**: Interactive menu cards with scale animations
- **Responsive Layout**: 2-column grid layout that adapts to screen size
- **Company Branding**: Business icon for companies without profile pictures
- **Consistent Styling**: Matches the app's design language and color scheme

## Navigation

The screen integrates with the company navigation system and provides navigation to:

- Company Job Posts Screen
- Post Job Screen
- People Search Screen
- Future Analytics and Settings screens

## State Management

Uses the existing `CompanyProfileCubit` to fetch and display company profile information.

## File Structure

```
lib/features/company_menu_screen/
├── company_menu_screen.dart    # Main screen implementation
└── README.md                   # This documentation
```

## Usage

The Company Menu Screen is automatically integrated into the company navigation bar as the "Menu" tab. Company users can access it by:

1. Logging in as a company user
2. Navigating to the "Menu" tab in the bottom navigation
3. Selecting from the available menu options

## Components

### _MenuItem
Internal class for defining menu items with icon, label, color, and action.

### _AnimatedMenuCard
Interactive card component with scale animations for better user experience.

### _CompanyImageWithLoader
Profile image component with loading states and error handling.

## Future Enhancements

- Analytics dashboard for job post performance
- Company settings and preferences
- Notification management
- Company branding customization
- Advanced search and filtering options 
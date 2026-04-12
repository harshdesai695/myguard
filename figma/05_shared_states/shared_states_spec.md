# Shared States — Design Specifications

## Loading States
- **Spinner**: 40px CircularProgressIndicator, primary color, centered
- **Shimmer Card**: Rectangle with rounded corners, shimmer animation base=#E8EAED highlight=#F8F9FA
- **Shimmer List**: 5× shimmer cards with 12px spacing, 16px padding

## Empty States
- **Layout**: Centered column
  - Icon: 80px, grey300 color
  - Message: bodyMedium grey600, centered, 16px below icon
  - CTA Button (optional): primary small button, 24px below message
- **Variants**: No visitors, No tickets, No notices, No vehicles, No pets, No listings, No documents

## Error States
- **Layout**: Centered column
  - Icon: 64px error_outline, grey400
  - Message: bodyMedium grey600, centered, 16px below
  - Retry Button: outlined small, "Retry" + refresh icon, 24px below
- **Snackbar Errors**: Floating snackbar, md radius, icon + message

## Dark Mode
- All screens must support dark theme
- Surface: #1E1E1E, Background: #121212, OnSurface: #E8EAED
- Divider: #3C4043, Primary accent: #4A9AF5

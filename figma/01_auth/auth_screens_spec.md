# Auth Screens — Design Specifications

## Splash Screen (splash_screen)
- **Frame**: 390×844, full bleed primary (#1A73E8) background
- **Layout**: Centered column
  - App icon: 100×100 white container, radius 24, shield icon 60px
  - "MyGuard" displayLarge white, 24px below icon
  - "Your Community, Secured" bodyLarge white/80%, 8px below title
  - Spinner: 24×24 white, 48px below tagline
- **States**: Loading only (transitions to login or home)

## Login Screen (login_screen)
- **Frame**: 390×844, white background
- **Layout**: SafeArea, scrollable, 24px padding
  - Top: 48px spacer
  - App icon: 72×72, centered, primary bg, shield icon
  - Title: "Welcome Back" displayMedium centered, 24px below
  - Subtitle: "Sign in to continue" bodyMedium grey, 4px below
  - Email field: 48px below, email icon prefix
  - Password field: 16px below, lock icon, show/hide toggle
  - "Forgot Password?" text button, right-aligned, 8px below
  - Sign In button: primary filled, full width, 24px below
  - "Don't have an account? Register" row centered, 32px below
- **States**: Default, loading (button spinner), error (snackbar)

## Register Screen (register_screen)
- **Frame**: 390×844, white background
- **Layout**: AppBar with back arrow, scrollable 24px padding
  - Title: "Create Account" displayMedium
  - Fields: Name, Email, Phone, Role selector (segmented), Password, Confirm Password
  - Create Account button: primary filled, full width
  - "Already have an account? Sign In" row
- **States**: Default, loading, error

## Forgot Password Screen (forgot_password_screen)
- **Frame**: 390×844, AppBar with back
- **Layout**: Email field + Send Reset Link button
- **States**: Default, loading, success (snackbar + pop)

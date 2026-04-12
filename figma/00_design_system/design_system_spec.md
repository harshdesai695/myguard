# MyGuard Design System — Design Specifications

## Color Palette
| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| primary | #1A73E8 | #4A9AF5 | Primary actions, links, nav |
| secondary | #34A853 | #5CBC6E | Success, secondary CTA |
| surface | #F8F9FA | #1E1E1E | Card/sheet backgrounds |
| error | #D93025 | #D93025 | Destructive, error states |
| warning | #F9AB00 | #F9AB00 | Pending, caution |
| onSurface | #202124 | #E8EAED | Primary text |
| grey500 | #9AA0A6 | #9AA0A6 | Secondary text |

## Typography (Inter font family)
| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| displayLarge | 32 | Bold | Hero headlines |
| displayMedium | 28 | Bold | Page titles |
| headingLarge | 22 | SemiBold | Section headings |
| headingMedium | 20 | SemiBold | Card titles |
| titleMedium | 14 | SemiBold | List item titles |
| bodyMedium | 14 | Regular | Body text |
| bodySmall | 12 | Regular | Secondary text |
| labelSmall | 10 | Medium | Badges, chips |
| caption | 12 | Regular | Metadata |

## Spacing Scale
| Token | Value |
|-------|-------|
| xxs | 2px |
| xs | 4px |
| sm | 8px |
| md | 16px |
| lg | 24px |
| xl | 32px |
| xxl | 48px |

## Border Radius
| Token | Value |
|-------|-------|
| sm | 8px |
| md | 12px |
| lg | 16px |
| xl | 24px |
| full | 999px |

## Component Inventory
- AppButton (primary, secondary, outline, text, danger × small, medium, large)
- AppTextField (label, hint, prefix/suffix icon, password toggle, error state)
- AppLoader (spinner, shimmer card, shimmer list)
- AppErrorWidget (icon + message + retry CTA)
- AppEmptyWidget (icon + message + optional CTA)
- AppSnackbar (default, success, error, warning)
- StatusChip (pending/yellow, approved/green, rejected/red, completed/blue)
- NavigationBar (5-tab bottom nav per role)
- Card (outlined with md radius)

## Frame Spec
- Base: 390 × 844 (iPhone 14)
- Status bar: 44px
- Bottom nav: 80px
- Safe area bottom: 34px

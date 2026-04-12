# Guard Screens — Design Specifications

## Guard Home (guard_home_screen)
- **Header**: "Guard Dashboard"
- **Stat Cards**: 3 cards vertically
  - Pending Entries (warning icon, count)
  - Patrol Status (shield icon, status text)
  - Shift (clock icon, "Active" text)

## Visitor Entry (visitor_entry_screen)
- **AppBar**: "Log Visitor Entry" + QR scan action button
- **Form**: Name, Phone, Purpose, Flat Number, Vehicle (optional)
- **Photo Button**: Outlined "Capture Photo" button
- **Submit**: "Log Entry" primary button

## Patrol Screen (patrol_screen)
- **AppBar**: "Patrol"
- **List**: Checkpoint cards with location icon, name, location text, "Scan" button

## Panic Alerts (panic_alerts_screen)
- **Empty State**: Green circle with check icon, "All Clear", "No active panic alerts"
- **Alert State**: Red cards with flat, resident, timestamp, "Resolve" button

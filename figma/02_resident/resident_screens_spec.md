# Resident Screens — Design Specifications

## Resident Home (resident_home_screen)
- **Header**: Greeting text + "Welcome Home" heading
- **Quick Actions**: 3×2 grid (Pre-Approve, SOS, Daily Helps, Amenities, Helpdesk, Notices)
  - Each: surface bg, md radius, icon 28px primary + labelSmall
- **Recent Activity**: Section header + placeholder card

## Visitor History (visitor_history_screen)
- **AppBar**: "Visitor History"
- **FAB**: Extended, "Pre-Approve" with person_add icon
- **List**: ListView.builder, cards with avatar initial + name + purpose + status chip
- **Status Chips**: PENDING/yellow, APPROVED/green, REJECTED/red, COMPLETED/blue

## Visitor Pre-Approve (visitor_pre_approve_screen)
- **AppBar**: "Pre-Approve Visitor"
- **Form**: Name, Phone, Purpose fields + Pre-Approve button

## Visitor Detail (visitor_detail_screen)
- **Header Card**: Circle avatar (initial), name, status chip
- **Info Card**: Phone, purpose, flat, vehicle, entry/exit times
- **Actions**: Approve (green filled) + Reject (red outline) buttons for PENDING status

## Daily Help List (daily_help_list_screen)
- **AppBar**: "Daily Helps", **FAB**: "Add Help"
- **List**: Cards with type icon (maid/cook/driver/nanny), name, type, phone, attendance button

## Amenity List (amenity_list_screen)
- **AppBar**: "Amenities"
- **Grid**: 2-column, cards with icon header, name, type, capacity, status badge

## Helpdesk Tickets (helpdesk_ticket_list_screen)
- **AppBar**: "Helpdesk", **FAB**: "New Ticket"
- **List**: Cards with title, priority badge, description preview, category, status badge

## Notice Board (notice_board_screen)
- **AppBar**: "Notice Board"
- **List**: Cards with type badge (GENERAL/URGENT/MAINTENANCE), date, title, body preview

## Poll List (poll_list_screen)
- **List**: Cards with question, option buttons (outlined), vote count

## Vehicle List (vehicle_list_screen)
- **AppBar**: "My Vehicles", **FAB**: "Add Vehicle"
- **List**: Cards with vehicle icon, plate, make/model/color, type badge

## Marketplace Browse (marketplace_browse_screen)
- **AppBar**: "Marketplace", **FAB**: "Sell"
- **Grid**: 2-column, photo, title, price, condition badge

## Pet Directory (pet_directory_screen)
- **AppBar**: "Pet Directory", **FAB**: "Register Pet"
- **List**: Cards with photo avatar, name, breed/type, vaccination status

## Emergency Contacts (emergency_contacts_screen)
- **SOS Card**: Red card, SOS icon, "Press and hold for emergency"
- **Contacts List**: Cards with type icon, name, phone, call button

## Material Gatepass (material_gatepass_screen)
- **AppBar**: "Material Gatepass", **FAB**: "New Gatepass"
- **List**: Cards with INWARD/OUTWARD badge, description, vehicle, status

## Documents (documents_screen)
- Empty state with folder icon

## Services Screen (services_screen)
- Grid of service tiles linking to: Amenities, Helpdesk, Vehicles, Marketplace, Pets, Documents, Material Gatepass

## Community Screen (community_screen)
- Grid of community tiles: Notices, Polls, Groups, Directory

## Profile Screen (profile_screen)
- Avatar, name, email, role badge, flat info
- Settings list: Edit Profile, Change Password, Notifications, About, Sign Out

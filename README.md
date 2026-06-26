# Track Biit Visitors - Frontend

A Flutter based frontend application developed for the **Track Biit Visitors** system. The application provides a clean and role based interface for managing visitors, monitoring cameras, handling alerts, viewing visitor movement paths, and accessing reports through integration with the backend API.

This frontend is part of a Final Year Project built to support an intelligent visitor tracking system using camera based monitoring and face recognition.

---

## Overview

Track Biit Visitors Frontend is designed as the user interface layer of the visitor tracking platform. It connects with the backend system to display visitor information, camera data, alerts, paths, reports, and administrative controls.

The application is structured into multiple screens and modules, making it easy for admins, guards, monitors, and directors to access the features relevant to their roles.

---

## Key Features

- Role based login and dashboard experience
- Visitor registration and visitor record management
- Camera and location management screens
- Floor, block, and destination management
- Live/current visitor tracking interface
- Visitor path and visit history views
- Alert monitoring and restricted location handling
- Unknown visitor review screens
- Guard duty and monitoring related screens
- Visitor reports and dashboard summaries
- Backend API integration for data fetching and updates
- Mobile friendly Flutter user interface

---

## Application Modules

### Authentication and Role Access

| Screen / Module | Purpose |
|---|---|
| `Login.dart` | Handles user login and authentication flow |
| `StartingScreen.dart` | Initial application screen |
| `Admin.dart` | Admin role dashboard and navigation |
| `Guard.dart` | Guard role interface |
| `Monitor.dart` | Monitor role interface |
| `MonitorDashBoard.dart` | Monitoring dashboard screen |

---

### Visitor Management

| Screen / Module | Purpose |
|---|---|
| `AddVisitor.dart` | Adds new visitor information |
| `AddNewVisit.dart` | Creates a new visitor visit record |
| `CurrentVisitors.dart` | Shows visitors currently inside the premises |
| `SearchVisitor.dart` | Searches visitor records |
| `ExitVisitor.dart` | Handles visitor exit process |
| `EndVisit.dart` | Ends an active visit |
| `BlockVisitor.dart` | Blocks restricted visitors |
| `Unknowns.dart` | Displays unknown or unrecognized visitors |
| `VisitorReport.dart` | Shows visitor related reports |
| `VisitPathHistory.dart` | Displays visitor path history |

---

### Camera, Location, and Path Management

| Screen / Module | Purpose |
|---|---|
| `AddCamera.dart` | Adds camera information |
| `CameraConnection.dart` | Manages camera-location connections |
| `DetectedCameras.dart` | Shows detected camera information |
| `CameraCost.dart` | Displays camera cost related information |
| `Locations.dart` | Manages locations |
| `Floors.dart` | Manages floor records |
| `AddDestination.dart` | Adds destination information |
| `Paths.dart` | Manages visitor paths |
| `LocationPaths.dart` | Displays paths between locations |
| `DestinationPaths.dart` | Shows destination based paths |
| `RestrictLocation.dart` | Handles restricted locations |
| `Reroute.dart` | Supports rerouting flow |
| `ReRouteVisitor.dart` | Reroutes visitor movement |

---

### Alerts, Reports, and Dashboards

| Screen / Module | Purpose |
|---|---|
| `AllAlerts.dart` | Displays system alerts |
| `VisitorDashBoard.dart` | Visitor dashboard related tasks |
| `DirectorDashBoard.dart` | Director level dashboard view |
| `TodayVisitors.dart` | Shows visitors for the current day |
| `LastWeekVisitors.dart` | Shows visitor data from the last week |
| `SearchTodayVisitor.dart` | Searches today's visitor records |
| `ShowBlockVisitors.dart` | Displays blocked visitor records |
| `NewVisitorMode.dart` | Handles new visitor mode flow |
| `VisitorMode.dart` | Handles visitor mode functionality |

---

## Project Structure

```text
Track-Biit-Visitors-Frontend/
│
├── android/                  # Android platform configuration
├── ios/                      # iOS platform configuration
├── lib/                      # Main Flutter source code
│   ├── APIHandler/           # Backend API connection and request handling
│   ├── CommonUtils.dart/     # Common utilities and dialogs
│   ├── CustomWidgets/        # Reusable UI widgets
│   ├── GetPostAllDataFromAPI/# API data fetching and posting modules
│   ├── Global/               # Global role based state/configuration
│   ├── Model/                # Data models
│   ├── Screens/              # Application screens
│   └── Tasks/                # Dashboard and task based modules
│
├── asset/                    # Images, icons, and videos used by the app
├── test/                     # Flutter test files
├── pubspec.yaml              # Flutter dependencies and asset configuration
├── pubspec.lock              # Locked dependency versions
└── README.md                 # Project documentation
```

---

## Technology Stack

- **Framework:** Flutter
- **Language:** Dart
- **Architecture:** Screen based modular frontend structure
- **Backend Integration:** REST API based communication
- **Platform Support:** Android, iOS, and Flutter supported targets
- **UI Components:** Custom reusable widgets and role based screens

---

## Main Data Models

| Model | Purpose |
|---|---|
| `UserModel.dart` | Stores user related data |
| `VisitorModel.dart` | Stores visitor information |
| `CameraModel.dart` | Stores camera information |
| `LocationModel.dart` | Stores location details |
| `FloorModel.dart` | Stores floor information |
| `BlockModel.dart` | Stores block related data |
| `PictureModel.dart` | Stores image related information |
| `CameraLocationConnectionModel.dart` | Handles camera and location mapping data |

---

## How the Application Works

1. The user logs in through the Flutter frontend.
2. The system identifies the user role such as admin, guard, monitor, or director.
3. The relevant dashboard and screens are displayed based on that role.
4. The frontend sends and receives data through backend API calls.
5. Visitor, camera, location, alert, and report information is shown in the app.
6. Guards and monitors can track visitors, review alerts, and manage visit related actions.
7. Admin users can manage system data such as users, cameras, locations, floors, and paths.

---

## Getting Started

### Prerequisites

Make sure Flutter is installed on your system.

```bash
flutter --version
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```

### Build APK

```bash
flutter build apk
```

---

## Backend Connection

This frontend is designed to work with the Track Biit Visitors backend API. Before running the application, make sure the backend server is running and the API base URL inside the Flutter project is configured correctly.

The API related logic is located inside:

```text
lib/APIHandler/
lib/GetPostAllDataFromAPI/

---

## Disclaimer

This project was developed for academic and demonstration purposes. Before production deployment, additional improvements are required in authentication, API security, error handling, data privacy, testing, and deployment configuration.

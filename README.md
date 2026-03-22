# ProgrammerApp

Native **iOS** app built with **SwiftUI** for exploring programming history, concepts, and practice—famous programmers, topics with code samples, curated videos, quizzes, code challenges, achievements, and learning statistics. Content is bundled locally; progress and preferences are stored on device.

## Requirements

| Item | Version |
|------|---------|
| iOS | **17.0** or later |
| Xcode | **15** or later (recommended) |
| Swift | **5** (as set in the Xcode project) |

## Quick start

1. Clone the repository and open the folder that contains `ProgrammerApp.xcodeproj`.
2. Open the project:
   ```bash
   open ProgrammerApp.xcodeproj
   ```
3. Select the **ProgrammerApp** scheme, choose a simulator or device, then run (**⌘R**).

Unit and UI test targets (**ProgrammerAppTests**, **ProgrammerAppUITests**) are included; run them with **⌘U** when needed.

## Features

- **Programmers** — Profiles, search, favorites, detail views, optional Wikipedia links.
- **Topics** — Concept explanations, multi-language snippets, read/study tracking, search and category filtering.
- **Videos** — Embedded playback (WebKit), categories, search, and sorting.
- **Extras** — Quizzes (timer, review), code challenges (difficulty, hints, solutions), achievements, daily tips.
- **Profile** — Statistics (study time, topics, quizzes, streaks), theme (light / dark / system), notification-related settings backed by `UserNotifications`.

## Project layout

Repository root:

```
.
├── ProgrammerApp.xcodeproj
├── ProgrammerApp/             # Main app target (sources)
│   ├── Models/
│   ├── Views/
│   ├── ViewModels/
│   ├── Repositories/
│   ├── Services/
│   ├── Components/
│   ├── Theme/
│   ├── Constants/
│   └── Assets.xcassets/
├── ProgrammerAppTests/
└── ProgrammerAppUITests/
```

## Architecture

The app uses **MVVM**: SwiftUI views, observable view models, protocol-oriented **repositories** for data, and **services** for persistence (`UserDefaults`), statistics, haptics, image caching, and notifications. Shared dependencies are wired through `DependencyContainer` and injected via the SwiftUI environment.

For more detail:

- [ARCHITECTURE.md](ARCHITECTURE.md) — structure and data flow
- [COMPONENTS.md](COMPONENTS.md) — reusable UI and related notes

## Tech stack

- SwiftUI, Combine, Foundation  
- UIKit (tab bar appearance, haptics, some bridging)  
- WebKit (in-app video / web content)  
- UserNotifications (reminders and achievement alerts where enabled)

## Permissions

If the user enables reminders or similar options, the app may request **notification** authorization through the system dialog. No other special entitlements are required for the default feature set.

## Contributing

Fork the repo, use a focused branch, and open a pull request with a short description of behavior changes. Match existing style and keep diffs scoped to the feature or fix.

## License

Add a `LICENSE` file and describe terms here when you publish the project.

---

*Author: Roman Shevchenko*

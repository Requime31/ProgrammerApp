# ProgrammerApp Components Documentation

This document provides detailed API documentation for all services, ViewModels, repositories, models, and components in ProgrammerApp.

## Table of Contents

- [Services](#services)
- [ViewModels](#viewmodels)
- [Repositories](#repositories)
- [Models](#models)
- [Components](#components)
- [Protocols](#protocols)

## Services

### PersistenceService

**Location:** `Services/PersistenceService.swift`

**Purpose:** Handles data persistence using UserDefaults with proper error handling.

**Protocol:** `PersistenceServiceProtocol`

**Key Methods:**

```swift
// Codable types
func set<T: Codable>(_ value: T, forKey key: String) throws
func get<T: Codable>(_ type: T.Type, forKey key: String) throws -> T?

// Primitive types
func set(_ value: Int, forKey key: String)
func getInt(forKey key: String) -> Int
func set(_ value: Bool, forKey key: String)
func getBool(forKey key: String) -> Bool
func set(_ value: String, forKey key: String)
func getString(forKey key: String) -> String?
func set(_ value: Double, forKey key: String)
func getDouble(forKey key: String) -> Double

// Utility
func remove(forKey key: String)
```

**Error Handling:**
- Throws `AppError.encodingError` when encoding fails
- Throws `AppError.decodingError` when decoding fails

**Usage Example:**
```swift
let persistenceService = PersistenceService()

// Save Codable
try persistenceService.set(programmers, forKey: "favorites")

// Load Codable
if let favorites: [Programmer] = try persistenceService.get([Programmer].self, forKey: "favorites") {
    // Use favorites
}

// Save primitive
persistenceService.set(42, forKey: "count")
let count = persistenceService.getInt(forKey: "count")
```

---

### StatisticsService

**Location:** `Services/StatisticsService.swift`

**Purpose:** Tracks and calculates user statistics including quiz scores, study time, streaks, and achievements.

**Protocol:** `StatisticsServiceProtocol`

**Key Methods:**

```swift
func getQuizzesCompleted() -> Int
func getTopicsCompleted() -> Int
func getCurrentStreak() -> Int
func getLongestStreak() -> Int
func getTotalStudyTime() -> TimeInterval
func getAverageQuizScore() -> Double
func getAchievementsUnlocked() -> Int
func getTotalAchievements() -> Int
func recordQuizScore(_ score: Int, outOf total: Int)
func addStudyTime(_ time: TimeInterval)
func updateLongestStreakIfNeeded()
```

**Usage Example:**
```swift
let statisticsService = StatisticsService(persistenceService: persistenceService)

// Record quiz completion
statisticsService.recordQuizScore(8, outOf: 10)

// Add study time
statisticsService.addStudyTime(3600) // 1 hour in seconds

// Get statistics
let quizzesCompleted = statisticsService.getQuizzesCompleted()
let averageScore = statisticsService.getAverageQuizScore()
```

**Dependencies:**
- `PersistenceServiceProtocol` for data storage

---

### HapticService

**Location:** `Services/HapticService.swift`

**Purpose:** Provides haptic feedback for better user experience.

**Type:** Singleton (`HapticService.shared`)

**Key Methods:**

```swift
// Impact feedback
func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium)
func impactLight()
func impactMedium()
func impactHeavy()

// Notification feedback
func notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
func success()
func warning()
func error()

// Selection feedback
func selection()
```

**Usage Example:**
```swift
let haptic = HapticService.shared

// On button tap
haptic.impactLight()

// On success
haptic.success()

// On error
haptic.error()

// On selection change
haptic.selection()
```

---

### ImageCacheService

**Location:** `Services/ImageCacheService.swift`

**Purpose:** Manages image caching with in-memory and disk storage.

**Type:** Singleton (`ImageCacheService.shared`)

**Key Methods:**

```swift
func getImage(for key: String) -> UIImage?
func setImage(_ image: UIImage, for key: String)
func clearCache()
```

**Cache Configuration:**
- In-memory: 50 items, 50 MB limit
- Disk: Persistent cache directory

**Usage Example:**
```swift
let cache = ImageCacheService.shared

// Store image
if let image = UIImage(named: "photo") {
    cache.setImage(image, for: "photo_key")
}

// Retrieve image
if let cachedImage = cache.getImage(for: "photo_key") {
    // Use cached image
}

// Clear cache
cache.clearCache()
```

**Error Handling:**
- Errors are logged but don't fail operations
- Falls back gracefully if disk operations fail

---

### DependencyContainer

**Location:** `Services/DependencyContainer.swift`

**Purpose:** Centralized dependency injection container managing all services, repositories, and ViewModels.

**Type:** Singleton (`DependencyContainer.shared`)

**Properties:**

```swift
// Services
let persistenceService: PersistenceServiceProtocol
let hapticService: HapticService
let imageCacheService: ImageCacheService

// Repositories
let programmerRepository: ProgrammerRepositoryProtocol
let topicRepository: TopicRepositoryProtocol
let videoRepository: VideoRepositoryProtocol
let quizRepository: QuizRepositoryProtocol
let codeChallengeRepository: CodeChallengeRepositoryProtocol

// Shared ViewModels
let gamificationViewModel: GamificationViewModel
let topicsViewModel: TopicsViewModel
let statisticsViewModel: StatisticsViewModel

// App Settings
let appSettings: AppSettings
let tabCoordinator: TabCoordinator
```

**Factory Methods:**

```swift
func makeProgrammersViewModel() -> ProgrammersViewModel
func makeVideosViewModel() -> VideosViewModel
func makeQuizViewModel() -> QuizViewModel
func makeCodeChallengeViewModel() -> CodeChallengeViewModel
```

**Usage Example:**
```swift
let container = DependencyContainer.shared

// Access shared ViewModels
let statisticsVM = container.statisticsViewModel

// Create view-specific ViewModels
let programmersVM = container.makeProgrammersViewModel()
```

---

## ViewModels

### ProgrammersViewModel

**Location:** `ViewModels/ProgrammersViewModel.swift`

**Purpose:** Manages state and business logic for the programmers list view.

**Key Properties:**

```swift
@Published var programmers: [Programmer] = []
@Published var isLoading: Bool = false
@Published var searchText: String = ""
@Published var sortOption: ProgrammerSortOption = .nameAscending
@Published var showFavoritesOnly: Bool = false
@Published var searchHistory: [String] = []
@Published var errorMessage: String?
@Published var hasError: Bool = false
```

**Key Methods:**

```swift
func loadProgrammers()
func isFavorite(_ programmer: Programmer) -> Bool
func toggleFavorite(_ programmer: Programmer)
func setSortOption(_ option: ProgrammerSortOption)
func setShowFavoritesOnly(_ show: Bool)
func addToSearchHistory(_ query: String)
func clearSearchHistory()
func refresh() async
func clearError()
```

**Computed Properties:**

```swift
var filteredProgrammers: [Programmer] // Filtered and sorted list
```

**Dependencies:**
- `ProgrammerRepositoryProtocol`
- `PersistenceServiceProtocol`

---

### TopicsViewModel

**Location:** `ViewModels/TopicsViewModel.swift`

**Purpose:** Manages state and business logic for the topics list view.

**Key Properties:**

```swift
@Published var topics: [Topic] = []
@Published var isLoading: Bool = false
@Published var searchText: String = ""
@Published var studiedTopicIds: Set<UUID> = []
@Published var topicLastStudiedDates: [UUID: Date] = [:]
@Published var searchHistory: [String] = []
@Published var errorMessage: String?
@Published var hasError: Bool = false
```

**Key Methods:**

```swift
func loadTopics()
func markTopicAsStudied(_ topicId: UUID, gamificationViewModel: GamificationViewModel?)
func isTopicStudied(_ topicId: UUID) -> Bool
func getLastStudiedDate(for topicId: UUID) -> Date?
func addToSearchHistory(_ query: String)
func clearSearchHistory()
func refresh() async
func clearError()
```

**Computed Properties:**

```swift
var filteredTopics: [Topic] // Filtered by search text
```

**Dependencies:**
- `TopicRepositoryProtocol`
- `PersistenceServiceProtocol`

---

### VideosViewModel

**Location:** `ViewModels/VideosViewModel.swift`

**Purpose:** Manages state and business logic for the videos list view.

**Key Properties:**

```swift
@Published var videos: [Video] = []
@Published var selectedCategory: String? = nil
@Published var isLoading: Bool = false
@Published var searchText: String = ""
@Published var sortOption: VideoSortOption = .title
@Published var errorMessage: String?
@Published var hasError: Bool = false
```

**Key Methods:**

```swift
func loadVideos()
func setSortOption(_ option: VideoSortOption)
func refresh() async
func clearError()
```

**Computed Properties:**

```swift
var availableCategories: [String] // Unique categories
var filteredVideos: [Video] // Filtered and sorted list
```

**Dependencies:**
- `VideoRepositoryProtocol`
- `PersistenceServiceProtocol`

---

### QuizViewModel

**Location:** `ViewModels/QuizViewModel.swift`

**Purpose:** Manages quiz state, question flow, and scoring.

**Key Properties:**

```swift
@Published var currentQuestionIndex: Int = 0
@Published var selectedAnswerIndex: Int? = nil
@Published var showResult: Bool = false
@Published var score: Int = 0
@Published var questions: [QuizQuestion] = []
@Published var isQuizCompleted: Bool = false
@Published var selectedCategory: QuizCategory? = nil
@Published var selectedDifficulty: QuizDifficulty? = nil
@Published var timerEnabled: Bool = false
@Published var timeRemaining: Int = 0
@Published var incorrectAnswers: [QuizQuestion] = []
@Published var showReview: Bool = false
@Published var errorMessage: String?
@Published var hasError: Bool = false
```

**Key Methods:**

```swift
func startQuiz()
func selectAnswer(_ index: Int)
func nextQuestion()
func resetQuiz()
func startReview()
func stopTimer()
func clearError()
```

**Computed Properties:**

```swift
var currentQuestion: QuizQuestion? // Current question
var progress: Double // Quiz progress (0.0 to 1.0)
```

**Dependencies:**
- `QuizRepositoryProtocol`
- `PersistenceServiceProtocol`
- `GamificationViewModel`
- `StatisticsViewModel`

---

### CodeChallengeViewModel

**Location:** `ViewModels/CodeChallengeViewModel.swift`

**Purpose:** Manages code challenge state and progress.

**Key Properties:**

```swift
@Published var challenges: [CodeChallenge] = []
@Published var currentChallenge: CodeChallenge?
@Published var completedChallengeIds: Set<UUID> = []
@Published var selectedDifficulty: CodeChallenge.Difficulty? = nil
@Published var selectedLanguage: CodeChallenge.ProgrammingLanguage? = nil
@Published var showSolution: Bool = false
@Published var currentHintIndex: Int = 0
@Published var errorMessage: String?
@Published var hasError: Bool = false
```

**Key Methods:**

```swift
func loadChallenges()
func filterChallenges()
func startChallenge(_ challenge: CodeChallenge)
func completeChallenge(_ challengeId: UUID)
func isChallengeCompleted(_ challengeId: UUID) -> Bool
func getNextHint() -> String?
func resetHints()
func clearError()
```

**Computed Properties:**

```swift
var progress: Double // Completion progress
var completedCount: Int
var totalCount: Int
```

**Dependencies:**
- `CodeChallengeRepositoryProtocol`
- `PersistenceServiceProtocol`

---

### StatisticsViewModel

**Location:** `ViewModels/StatisticsViewModel.swift`

**Purpose:** Aggregates and formats statistics for display.

**Key Properties:**

```swift
@Published var totalStudyTime: TimeInterval = 0
@Published var topicsCompleted: Int = 0
@Published var quizzesTaken: Int = 0
@Published var averageQuizScore: Double = 0
@Published var currentStreak: Int = 0
@Published var longestStreak: Int = 0
@Published var achievementsUnlocked: Int = 0
@Published var totalAchievements: Int = 0
@Published var errorMessage: String?
@Published var hasError: Bool = false
```

**Key Methods:**

```swift
func loadStatistics()
func recordQuizScore(_ score: Int, outOf total: Int)
func addStudyTime(_ time: TimeInterval)
func clearError()
```

**Computed Properties:**

```swift
var formattedStudyTime: String // "2h 30m" format
var completionPercentage: Double // Achievement completion
```

**Dependencies:**
- `PersistenceServiceProtocol`
- `StatisticsServiceProtocol`

---

### GamificationViewModel

**Location:** `ViewModels/GamificationViewModel.swift`

**Purpose:** Manages gamification features including achievements and progress tracking.

**Key Properties:**

```swift
@Published var quizzesCompleted: Int = 0
@Published var topicsStudied: Int = 0
@Published var dailyTipsOpened: Int = 0
@Published var lastDailyTipDate: Date? = nil
@Published var consecutiveDays: Int = 0
@Published var errorMessage: String?
@Published var hasError: Bool = false
```

**Key Methods:**

```swift
func loadProgress()
func saveProgress()
func incrementQuizzesCompleted()
func incrementTopicsStudied()
func openDailyTip()
func getUnlockedAchievements() -> [Achievement]
func clearError()
```

**Computed Properties:**

```swift
var totalProgress: Double // Overall progress (0.0 to 1.0)
```

**Dependencies:**
- `PersistenceServiceProtocol`

---

### TabCoordinator

**Location:** `ViewModels/TabCoordinator.swift`

**Purpose:** Manages tab navigation and cross-tab coordination.

**Key Properties:**

```swift
@Published var selectedTab: Int = 0
@Published var selectedVideoCategory: String? = nil
```

**Key Methods:**

```swift
func switchToVideosTab(withCategory category: String?)
func clearVideoCategory()
```

---

## Repositories

### ProgrammerRepository

**Location:** `Repositories/ProgrammerRepository.swift`

**Protocol:** `ProgrammerRepositoryProtocol`

**Methods:**

```swift
func getAllProgrammers() -> [Programmer]
```

**Current Implementation:** Returns sample data. Can be extended to fetch from API or database.

---

### TopicRepository

**Location:** `Repositories/TopicRepository.swift`

**Protocol:** `TopicRepositoryProtocol`

**Methods:**

```swift
func getAllTopics() -> [Topic]
```

**Current Implementation:** Returns sample data. Can be extended to fetch from API or database.

---

### VideoRepository

**Location:** `Repositories/VideoRepository.swift`

**Protocol:** `VideoRepositoryProtocol`

**Methods:**

```swift
func getAllVideos() -> [Video]
```

**Current Implementation:** Returns sample data. Can be extended to fetch from API or database.

---

### QuizRepository

**Location:** `Repositories/QuizRepository.swift`

**Protocol:** `QuizRepositoryProtocol`

**Methods:**

```swift
func getAllQuestions() -> [QuizQuestion]
```

**Current Implementation:** Returns sample questions. Can be extended to fetch from API or database.

---

### CodeChallengeRepository

**Location:** `Repositories/CodeChallengeRepository.swift`

**Protocol:** `CodeChallengeRepositoryProtocol`

**Methods:**

```swift
func getAllChallenges() -> [CodeChallenge]
```

**Current Implementation:** Returns sample challenges. Can be extended to fetch from API or database.

---

## Models

### Programmer

**Location:** `Models/Programmer.swift`

**Structure:**
```swift
struct Programmer: Identifiable, Codable {
    let id: UUID
    let name: String
    let bio: String
    let fullBiography: String
    let photoName: String
    let funFacts: [String]
    let wikipediaURL: String
}
```

**Properties:**
- `id`: Unique identifier
- `name`: Programmer's name
- `bio`: Short biography
- `fullBiography`: Complete biography text
- `photoName`: Image asset name
- `funFacts`: Array of interesting facts
- `wikipediaURL`: Link to Wikipedia page

---

### Topic

**Location:** `Models/Topic.swift`

**Structure:**
```swift
struct Topic: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let detailedInfo: String
    let iconName: String
    let color: TopicColor
    let codeSnippets: [CodeSnippet]
    let funFacts: [String]
    let relatedVideoCategory: String?
}
```

**Properties:**
- `id`: Unique identifier
- `title`: Topic title
- `description`: Short description
- `detailedInfo`: Detailed explanation
- `iconName`: SF Symbol name
- `color`: Color theme
- `codeSnippets`: Code examples in different languages
- `funFacts`: Interesting facts about the topic
- `relatedVideoCategory`: Related video category

---

### Video

**Location:** `Models/Video.swift`

**Structure:**
```swift
struct Video: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let category: String
    let duration: String
    let youtubeVideoID: String?
    let thumbnailURL: URL?
}
```

**Properties:**
- `id`: Unique identifier
- `title`: Video title
- `description`: Video description
- `category`: Video category
- `duration`: Duration string (e.g., "10:30")
- `youtubeVideoID`: YouTube video ID for embedding
- `thumbnailURL`: Thumbnail image URL

---

### Quiz

**Location:** `Models/Quiz.swift`

**Key Types:**

```swift
struct QuizQuestion: Identifiable {
    let id: UUID
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
    let category: QuizCategory
    let difficulty: QuizDifficulty
}

enum QuizCategory: String, CaseIterable {
    case history
    case languages
    case concepts
    case algorithms
}

enum QuizDifficulty: String, CaseIterable {
    case easy
    case medium
    case hard
}
```

---

### CodeChallenge

**Location:** `Models/CodeChallenge.swift`

**Structure:**
```swift
struct CodeChallenge: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let difficulty: Difficulty
    let problem: String
    let solution: String
    let hints: [String]
    let language: ProgrammingLanguage
}

enum Difficulty: String, CaseIterable {
    case easy
    case medium
    case hard
}

enum ProgrammingLanguage: String, CaseIterable {
    case swift
    case python
    case javascript
    case java
    case cpp
}
```

---

### Achievement

**Location:** `Models/Achievement.swift`

**Structure:**
```swift
struct Achievement: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let iconName: String
    let requirement: Int
    let category: AchievementCategory
}

enum AchievementCategory {
    case quiz
    case learning
    case favorites
    case daily
}
```

---

### AppError

**Location:** `Models/AppError.swift`

**Purpose:** Centralized error handling enum.

**Types:**
```swift
enum AppError: LocalizedError {
    case persistenceError(String)
    case networkError(String)
    case decodingError(String)
    case encodingError(String)
    case invalidData(String)
    case notFound(String)
    case unknown(Error)
}
```

**Usage:**
```swift
throw AppError.persistenceError("Failed to save data")
let appError = AppError.from(someError)
```

---

### AppSettings

**Location:** `Models/AppSettings.swift`

**Purpose:** Manages user preferences and app settings.

**Properties:**
```swift
@Published var colorScheme: ColorScheme?
@Published var notificationsEnabled: Bool
```

**Dependencies:**
- `PersistenceServiceProtocol`

---

## Components

### ErrorAlert

**Location:** `Components/ErrorAlert.swift`

**Purpose:** SwiftUI modifier for displaying error alerts.

**Usage:**
```swift
.errorAlert(errorMessage: $viewModel.errorMessage)
```

**Features:**
- Automatic alert display when error message is set
- Dismissal callback support

---

### ErrorStateView

**Location:** `Components/ErrorStateView.swift`

**Purpose:** Full-screen error state view with retry functionality.

**Parameters:**
- `errorMessage: String` - Error message to display
- `retryAction: (() -> Void)?` - Optional retry action
- `iconName: String` - Custom icon (default: "exclamationmark.triangle.fill")

**Usage:**
```swift
ErrorStateView(
    errorMessage: "Failed to load data",
    retryAction: {
        viewModel.loadData()
    }
)
```

---

### EmptyStateView

**Location:** `Components/EmptyStateView.swift`

**Purpose:** Displays empty state when no data is available.

**Parameters:**
- `iconName: String` - Icon to display
- `title: String` - Title text
- `message: String` - Description message
- `actionTitle: String?` - Optional action button title
- `action: (() -> Void)?` - Optional action closure

**Usage:**
```swift
EmptyStateView(
    iconName: "magnifyingglass",
    title: "No Results Found",
    message: "Try adjusting your search",
    actionTitle: "Clear Search",
    action: { viewModel.clearSearch() }
)
```

---

### LoadingView

**Location:** `Components/LoadingView.swift`

**Purpose:** Displays loading indicator.

**Usage:**
```swift
if viewModel.isLoading {
    LoadingView()
}
```

---

### SkeletonView

**Location:** `Components/SkeletonView.swift`

**Purpose:** Skeleton loading states for better perceived performance.

**Types:**
- `SkeletonCardView` - Generic card skeleton
- `VideoCardSkeleton` - Video card skeleton
- `ProgrammerCardSkeleton` - Programmer card skeleton

**Usage:**
```swift
if isLoading {
    SkeletonCardView()
}
```

---

### SearchBarView

**Location:** `Components/SearchBarView.swift`

**Purpose:** Search input with history support.

**Parameters:**
- `searchText: Binding<String>` - Search text binding
- `placeholder: String` - Placeholder text
- `searchHistory: [String]` - Search history
- `onHistoryItemSelected: (String) -> Void` - History item selection handler

**Features:**
- Debounced search (300ms)
- Search history display
- Clear button

---

### HeaderView

**Location:** `Components/HeaderView.swift`

**Purpose:** Consistent header component across views.

**Parameters:**
- `title: String` - Header title
- `showBackButton: Bool` - Show back button
- `onBackButtonTapped: (() -> Void)?` - Back button action

---

### GradientBackground

**Location:** `Components/GradientBackground.swift`

**Purpose:** App-wide gradient background.

**Usage:**
```swift
ZStack {
    GradientBackground()
    // Content
}
```

---

### CardStyle

**Location:** `Components/CardStyle.swift`

**Purpose:** View modifier for consistent card styling.

**Usage:**
```swift
VStack {
    // Content
}
.cardStyle(useGradient: true)
```

**Parameters:**
- `cornerRadius: CGFloat` - Corner radius (default: from theme)
- `useGradient: Bool` - Use gradient background

---

## Protocols

All repositories and services use protocol-based design for testability and flexibility.

### Repository Protocols

- `ProgrammerRepositoryProtocol`
- `TopicRepositoryProtocol`
- `VideoRepositoryProtocol`
- `QuizRepositoryProtocol`
- `CodeChallengeRepositoryProtocol`

### Service Protocols

- `PersistenceServiceProtocol`
- `StatisticsServiceProtocol`

**Benefits:**
- Easy mocking for testing
- Flexible implementations
- Clear contracts
- Dependency inversion

---

## Error Handling Patterns

### Standard Error Handling in ViewModels

```swift
private func handleError(_ error: Error) {
    let appError = AppError.from(error)
    errorMessage = appError.errorDescription
    hasError = true
    HapticService.shared.error()
}

func clearError() {
    errorMessage = nil
    hasError = false
}
```

### Error Display in Views

```swift
if viewModel.hasError {
    ErrorStateView(
        errorMessage: viewModel.errorMessage ?? "An error occurred",
        retryAction: {
            viewModel.clearError()
            viewModel.loadData()
        }
    )
}
.errorAlert(errorMessage: $viewModel.errorMessage)
```

---

## Best Practices

1. **Always use protocols** for services and repositories
2. **Handle errors properly** - don't silently fail
3. **Use @Published** for reactive state updates
4. **Clear errors** before retrying operations
5. **Use dependency injection** via DependencyContainer
6. **Follow MVVM** - keep business logic in ViewModels
7. **Use computed properties** for derived data
8. **Debounce search** for performance
9. **Provide retry mechanisms** for error states
10. **Use haptic feedback** for better UX

---

## Future Enhancements

The component architecture supports:

- **API Integration**: Repository pattern allows easy API integration
- **Offline Support**: Persistence layer ready for offline-first design
- **Real-time Updates**: Combine framework supports reactive updates
- **Modularization**: Clear boundaries support feature modules
- **Testing**: Protocol-based design enables comprehensive testing

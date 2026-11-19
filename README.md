# 📖 Journal App

### A Simple and Personal Space to Capture Your Thoughts

**Journal App** is an iOS application designed to provide a simple, comfortable, and organized space for users to write, manage, and save their personal thoughts and daily experiences.

The app focuses on creating a distraction-free journaling experience with a clean interface, intuitive navigation, and a structured approach to managing journal entries.

---

## ✨ Features

- **Create Journal Entries:** Write and save personal thoughts, experiences, and daily reflections.
- **Edit Entries:** Update existing journal entries whenever needed.
- **Delete Entries:** Remove entries you no longer want to keep.
- **Bookmark Entries:** Save important or favorite entries for quick access.
- **Automatic Timestamps:** Keep track of when entries were created and last updated.
- **Organized Interface:** Enjoy a clean and intuitive user experience.
- **Splash Screen:** A welcoming introduction when opening the application.

---

## 🛠️ Technologies Used

The application is built using Apple's development technologies:

| Technology | Purpose |
|---|---|
| **Swift** | Main programming language |
| **SwiftUI** | Building the user interface |
| **SwiftData** | Local data persistence and storage |
| **MVVM Architecture** | Organizing application logic and UI |
| **Xcode** | Development environment |

---

## 🏗️ Architecture

The project follows the **Model-View-ViewModel (MVVM)** architectural pattern to maintain clean, organized, and maintainable code.

The application is divided into three main layers:

### 1. Model
Responsible for defining the structure of journal entries and managing their data.

- `Journal.swift`
- Defines journal properties such as:
  - ID
  - Title
  - Content
  - Creation Date
  - Updated Date
  - Bookmark Status

### 2. View
Responsible for displaying the user interface and handling user interactions.

The Views are built using SwiftUI and are separated into reusable components and screens.

### 3. ViewModel
Responsible for handling application logic and communication between the Model and View.

- `JournalViewModel.swift`
  - Fetch journal entries.
  - Add new entries.
  - Update existing entries.
  - Delete entries.
  - Toggle bookmarks.
  - Save changes.

This separation makes the application easier to understand, maintain, and expand.

---

## 📂 Project Structure

The project is organized into the following folders:

```text
JournalApp/
│
├── Models/
│   └── Journal.swift
│
├── ViewModels/
│   ├── JournalViewModel.swift
│   └── AppViewModel.swift
│
├── Views/
│   ├── SplashView.swift
│   ├── EmptyStateView.swift
│   └── JournalEditorView.swift
│
├── Resources/
│   └── JournalColors.swift
│
├── ContentView.swift
│
└── JournalApp.swift
```

---

## 🚀 Getting Started

Follow these steps to run the application locally.

### Requirements

- A Mac running macOS.
- Xcode 16 or later.
- iOS 17 or later.
- Basic knowledge of Swift and SwiftUI.

### Installation

1. Clone this repository:

   ```bash
   git clone YOUR_REPOSITORY_URL
   ```

2. Open the project folder.

3. Open the `.xcodeproj` file using Xcode.

4. Select an iOS Simulator or a connected iPhone.

5. Press **Run (▶)** in Xcode to build and launch the application.

---

## 🎯 Project Goals

The main goals of this project are to:

- Build a functional and user-friendly journaling application.
- Practice developing iOS applications using SwiftUI.
- Understand and implement the MVVM architecture.
- Learn how to manage and persist data using SwiftData.
- Improve code organization and reusable component design.

---

## 🌱 Future Improvements

Potential features for future development include:

- Search and filter journal entries.
- Categories and tags for better organization.
- Mood tracking.
- Image attachments.
- Calendar-based journal navigation.
- iCloud synchronization.

---

## 👩🏻‍💻 Developer

Developed as an iOS development project to explore SwiftUI, MVVM architecture, and data persistence using SwiftData.

**Built with SwiftUI and ❤️**

---

*Your thoughts deserve a place to stay.*

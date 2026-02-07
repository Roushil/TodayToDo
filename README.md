# Today Tasks App (iOS Case Study)

This is an iOS application built to manage and display tasks for the current day.  
The project focuses on clean architecture, testable business logic, and predictable time-based behavior, following modern iOS engineering best practices. The app demonstrates how to structure a simple product feature in a scalable, production-ready way.

## Features

**Today’s Tasks List**  
Displays tasks scheduled for the current day in a clean, lightweight SwiftUI interface.

**Automatic Task Cleanup**  
Outdated tasks are automatically filtered and removed based on the current date.

**Deterministic Time Handling**  
System time is abstracted to allow predictable behavior and reliable unit testing.

## Modern Architecture

- MVVM (Model–View–ViewModel)
- Protocol-oriented design
- Dependency injection for system dependencies
- Clear separation of UI, business logic, and services

## Core Components

*Views*
- TodayTasksView
- TaskRow

*ViewModel*
- TodayTasksViewModel

*Services*
- DateProvider
- TaskCleanUpService

*Models*
- TodayTask

## Scalable & Adaptive UI

- Built using SwiftUI
- Stateless, reusable row components
- Responsive layout across device sizes
- Minimal logic inside views

## Unit Tests

- ViewModel-focused tests
- Deterministic time-based testing using mocked DateProvider
- XCTest-based validation of cleanup and state logic

## Tech Stack

UI: SwiftUI  
Architecture: MVVM  
State Handling: @Published  
Business Logic: ViewModel, Service layer  
Testing: XCTest  

## How to Run

1. Clone the repository  
2. Open the project in Xcode  
3. Select any iPhone simulator  
4. Run the app  

You’ll see an empty list of tasks initially filtered for **today**. You will see the option to add the task

## Testing

To run unit tests:
- Cmd + U

**Covered Modules**
- TodayTasksViewModel
- TaskCleanUpService
- DateProvider-based logic

## Engineering Values

*Clean Code*  
Clear folder structure, focused responsibilities, protocol-oriented components

*Testability*  
No direct system dependencies in ViewModels, deterministic logic

*Scalability*
Services and ViewModels can be extended without touching UI

*Maintainability*  
Business rules isolated from UI and presentation layers

*Reusability*  
Lightweight views and shared logic components

## Why This Architecture?

This app is designed to scale beyond a simple task list.  
By separating concerns and abstracting system dependencies like time, the codebase remains easy to test, reason about, and extend as requirements grow.

MVVM ensures UI remains declarative and predictable, while services keep business rules isolated and reusable.

Built by `~ROUSHIL~`

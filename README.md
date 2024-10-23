<p align="center">
    <a href="https://github.com/festivals-App/timetablekit-ios/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/festivals-App/timetablekit-ios?style=flat"></a>
    <a href="https://github.com/festivals-app/timetablekit-ios/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/festivals-app/timetablekit-ios?style=flat"></a>
    <a href="https://github.com/Carthage/Carthage" title="Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
    <a href="./LICENSE" title="License"><img src="https://img.shields.io/github/license/festivals-app/timetablekit-ios.svg"></a>
</p>

<h1 align="center">
    <br/><br/>
    TimetableKit
    <br/><br/>
</h1>

The TimetableKit provides you with a timetable view that manages an ordered collection of events and presents them in the planned order.

![Figure 1: UI Screens for Apple iOS](https://github.com/Festivals-App/timetablekit-ios/blob/main/ExampleApp/Screenshots/architecture_overview_timetable.svg "Figure 1: UI Screens for Apple iOS")

<hr/>
<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#development">Development</a> •
  <a href="#usage">Usage</a> •
  <a href="#installation">Installation</a> •
    <a href="#architecture">Architecture</a> •
  <a href="#engage">Engage</a> •
  <a href="#licensing">Licensing</a>
</p>
<hr/>

## Overview

A timetable view is made up of sections each with its own locations. Each location has one or more event tiles. When adding a timetable view to your user interface, your app’s main job is to manage the event data associated with that timetable view.

The structure of the timetable includes the following components:

* **Event**:
    Events are the elementary data for the timetable. An event is an entity which is defined by it's occurence in time specified by a time interval a name attribute and a location where it occures.

* **Location**:
    A group of events associated with the same location where they occure.

* **Section**:
    A number of locations which are grouped together by theme or motto. This can be anything, for a festival there could be one section for the stages and one for the food shops.
    
Sections are identified by their index number within the timetable view, and locations are identified by their index number within a section. Event tiles are identified by their index number within the location.
    
### Limitations

* The timetable view is not able to display overlapping or simultan occuring events at the same location, you have to split these locations into multiple locations.
* The timetable view is meant for displaying events that have a duration of hours not days. If you need to display lengthy events please consider to use a calendar view.

## Development

### Setup

1. Install and setup Xcode 15 or higher
2. Install jazzy
   ```console
   brew install jazzy
   ```
3. Install bartycrouch
   ```console
   brew install bartycrouch
   ```
   
### Build
    
There is an [ExampleApp](https://github.com/Festivals-App/timetablekit-ios/blob/main/ExampleApp) for developing and testing which you can build using Xcode.
    
### Requirements

-  iOS 13.0+
-  Xcode 13.1+
-  swift-tools-version:5.3+
-  [jazzy](https://github.com/realm/jazzy) 0.13.6+ for building the documentation
-  [bartycrouch](https://github.com/Flinesoft/BartyCrouch) 4.8.0+ for string localization

## Usage

After installing the TimtableKit in your project you can use the [TimetableView](https://github.com/Festivals-App/timetablekit-ios/blob/main/Sources/TimetableKit/TimetableView.swift) the same way you use the build-in UIViews. If you want to use the timetable in a SwiftUI based project you can see an example [wrapper implementation](https://github.com/Festivals-App/timetablekit-ios/blob/main/ExampleApp/TimetableView_wrapper.swift).  For more information about using UIViews within SwiftUI see [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable).
    
The timetable view is driven by the delegation pattern. After you created and installed the view the way you need it, the timetable will ask its delegate to determin what and how to display its content. You can implemen four different delegate protocols to influence the behavior of the timetable: `TimetableDataSource`, `TimetableDelegate`, `TimetableAppearanceDelegate` and `TimetableClock`
    
- You are *required* to implement the `TimetableDataSource` as it provides the data to display.
- The `TimetableDelegate` allows you to react to the user interacting with the timetable and is also *required* to implement. 
- By implementing the `TimetableAppearanceDelegate` you can fine tune the timetables appearance.
- Implementing `TimetableClock` allows the delegate to determin the current date and time displayed by the timetable.
    
## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate TimetableKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Festivals-App/timetablekit-ios" ~> 0.1
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but TimetableKit does support its use on supported platforms.

Once you have your Swift package set up, adding TimetableKit as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/Festivals-App/timetablekit-ios.git", .upToNextMajor(from: "0.1"))
]
```

## Architecture

The TimetableKit is not coupled with other projects from the FestivalsApp and can be used within any other project unrelated to it. To find out more about architecture and technical information see the [ARCHITECTURE](./ARCHITECTURE.md) document.

The full documentation for the FestivalsApp is in the [festivals-documentation](https://github.com/festivals-app/festivals-documentation) repository. The documentation repository contains technical documents, architecture information, UI/UX specifications, and whitepapers related to this implementation.

## Engage

I welcome every contribution, whether it is a pull request or a fixed typo. The best place to discuss questions and suggestions regarding the timetable is the projects [issues](https://github.com/Festivals-App/timetablekit-ios/issues) section. More general information and a good starting point if you want to get involved is the [festival-documentation](https://github.com/Festivals-App/festivals-documentation) repository.

If this doesn't fit you proposal or reason to contact me, there are some more general purpose communication channels where you can reach me, listed in the following table.

| Type                     | Channel                                                |
| ------------------------ | ------------------------------------------------------ |
| **General Discussion**   | <a href="https://github.com/festivals-app/festivals-documentation/issues/new/choose" title="General Discussion"><img src="https://img.shields.io/github/issues/festivals-app/festivals-documentation/question.svg?style=flat-square"></a> </a>   |
| **Other Requests**    | <a href="mailto:simon.cay.gaus@gmail.com" title="Email me"><img src="https://img.shields.io/badge/email-Simon-green?logo=mail.ru&style=flat-square&logoColor=white"></a>   |

## Licensing

Copyright (c) 2020-2024 Simon Gaus. Licensed under the [**GNU Lesser General Public License v3.0**](./LICENSE)

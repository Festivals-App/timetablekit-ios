<h1 align="center">
    TimetableKit
</h1>

<p align="center">
   <a href="https://github.com/festivals-App/timetablekit-ios/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/festivals-App/timetablekit-ios?style=flat"></a>
   <a href="https://github.com/festivals-app/timetablekit-ios/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/festivals-app/timetablekit-ios?style=flat"></a>
   <a href="./LICENSE" title="License"><img src="https://img.shields.io/github/license/festivals-app/timetablekit-ios.svg"></a>
</p>

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#development">Development</a> •
  <a href="#usage">Usage</a> •
  <a href="#installation">Installation</a> •
  <a href="#engage">Engage</a> •
  <a href="#licensing">Licensing</a>
</p>

The TimetableKit provides you with a timetable view that manages an ordered collection of events and presents them in the planned order.

## Overview

A timetable view is made up of sections each with its own locations. Each location has one ore more event tiles. When adding a timetable view to your user interface, your app’s main job is to manage the event data associated with that timetable view.

![Figure 1: UI Screens for Apple iOS](https://github.com/Festivals-App/timetablekit-ios/blob/main/ExampleApp/Screenshots/timetable.png "Figure 1: UI Screens for Apple iOS")

### Data Structure

The structure of the timetable includes following components:

* Event:
    Events are the elementary data for the timetable. An event is basically an entity which is defined by it's occurence in time specified by a time interval a name attribute and a location where it occures.

* Location:
    A group of events associated with the same location where they occure.

* Section:
    A number of locations which are grouped together by theme or motto. This can be anything, for a festival there could be one section for the stages and one for the food shops.
    
Sections are identified by their index number within the timetable view, and locations are identified by their index number within a section. Event tiles are identified by their index number within the location.
    
### Limitations

    * The timetable view is not able to display overlapping or simultan occuring events at the same location, you have to split these locations into sub-locations if this happens in your scenario.
    * The timetable view is meant for displaying events that have a duration of hours not days. If you need to display lengthy events please consider to use a calendar view.

## Development

TBA

### Setup

1. Install and setup Xcode 13.1 or higher
2. Install jazzy

   ```console
   brew install jazzy
   ```
3. Install bartycrouch

   ```console
   brew install bartycrouch
   ```
### Build
    
There is an [ExampleApp](https://github.com/Festivals-App/festivals-api-ios/blob/master/ExampleApp) for developing and testing which you can build using Xcode.
    
### Requirements

-  iOS 13.0+
-  Xcode 13.1+
-  swift-tools-version:5.3+
-  [jazzy](https://github.com/realm/jazzy) 0.13.6+ for building the documentation
-  [bartycrouch](https://github.com/Flinesoft/BartyCrouch) 4.8.0+ for string localization

## Usage

After installing the TimtableKit in your project you can use the [TimetableView](https://github.com/Festivals-App/timetablekit-ios/blob/main/Sources/TimetableKit/TimetableView.swift) the same way you use the build-in UIViews. If you want to use the timetable in a SwiftUI based project you can see an example [wrapper implementation](https://github.com/Festivals-App/timetablekit-ios/blob/main/ExampleApp/TimetableView_wrapper.swift).  For more information about using UIViews within SwiftUI see [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable).
    
The timetable view is driven by the delegation pattern. After you created and installed the view the way you need it, the tableview will ask its delegate to determin what and how to display its content. You can implemen four different delegate protocols to influence the behavior of the timetable: `TimetableDataSource` `TimetableDelegate` `TimetableAppearanceDelegate` and `TimetableClock`
    
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

### Manually

If you prefer not to use Carthage or the Swift Package Manager, you can integrate TimetableKit into your project manually.
You only need to build and add the TimetableKit framework (TimetableKit.framework) to your project. 

## Engage

TBA

The following channels are available for discussions, feedback, and support requests:

| Type                     | Channel                                                |
| ------------------------ | ------------------------------------------------------ |
| **General Discussion**   | <a href="https://github.com/festivals-app/festivals-documentation/issues/new/choose" title="General Discussion"><img src="https://img.shields.io/github/issues/festivals-app/festivals-documentation/question.svg?style=flat-square"></a> </a>   |
| **Concept Feedback**    | <a href="https://github.com/festivals-app/festivals-documentation/issues/new/choose" title="Open Concept Feedback"><img src="https://img.shields.io/github/issues/festivals-app/festivals-documentation/architecture.svg?style=flat-square"></a>  |
| **Other Requests**    | <a href="mailto:phisto05@gmail.com" title="Email Festivals Team"><img src="https://img.shields.io/badge/email-Festivals%20team-green?logo=mail.ru&style=flat-square&logoColor=white"></a>   |

## Licensing

Copyright (c) 2020-2021 Simon Gaus.

Licensed under the **GNU Lesser General Public License v3.0** (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at https://www.gnu.org/licenses/lgpl-3.0.html.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the [LICENSE](./LICENSE) for the specific language governing permissions and limitations under the License.

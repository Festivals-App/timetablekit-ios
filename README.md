<h1 align="center">
    TimetableKit
</h1>

<p align="center">
   <a href="https://github.com/festivals-App/timetablekit-ios/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/festivals-App/timetablekit-ios?style=flat"></a>
   <a href="https://github.com/festivals-app/timetablekit-ios/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/festivals-app/timetablekit-ios?style=flat"></a>
   <a href="./LICENSE" title="License"><img src="https://img.shields.io/github/license/festivals-app/timetablekit-ios.svg"></a>
</p>

<p align="center">
  <a href="#usage">Usage</a> •
  <a href="#installation">Installation</a> •
  <a href="#participate">Participate</a> •
  <a href="#licensing">Licensing</a>
</p>

The TimetableKit provides you with a timetable view that manages an ordered collection of event items and presents them in the planned order.

## Usage

When adding a timetable view to your user interface, your app’s main job is to manage the event data associated with that timetable view. The timetable view gets its data from the data source object, which is an object that conforms to the `TimetableDataSource` protocol and is provided by your app. Data in the timetable view is organized into individual event items, which can then be grouped into locations and sections for presentation. An event item is the elementary data for the timetable view.

A timetable view is made up of zero or more sections, each with its own locations. Sections are identified by their index number within the timetable view, and locations are identified by their index number within a section. Each row has one ore more event tiles. Event tiles are identified by their index number within the location.

### Data Structure

The structure of the timetable includes following components:

* Event
    Events are the elementary data for the timetable. An event is basically an entity which is defined by it's occurence in time specified by a time interval a name attribute and a location where it occures.

* Location
    A group of events associated with the same location where they occure.

* Section
    A number of locations which are grouped together by theme or motto. This can be anything, for a festival there could be one section for the stages and one for the food shops.

### Requirements

-  iOS 10.0+
-  Xcode 10.1+

### Limitations

* The timetable view is not able to display overlapping or simultan occuring events at the same location, you have to split these locations into sub-locations if this happens in your scenario.
* The timetable view is meant for displaying events that have a duration of hours not days. If you need to display lengthy events please consider to use a calendar view.

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate TimetableKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Phisto/TimetableKit-Swift" ~> 0.1
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but TimetableKit does support its use on supported platforms.

Once you have your Swift package set up, adding TimetableKit as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/Phisto/TimetableKit-Swift.git", .upToNextMajor(from: "0.1"))
]
```

### Manually

If you prefer not to use Carthage or the Swift Package Manager, you can integrate TimetableKit into your project manually.
You only need to build and add the TimetableKit framework (TimetableKit.framework) to your project. 

## Participate

TBA

The following channels are available for discussions, feedback, and support requests:

| Type                     | Channel                                                |
| ------------------------ | ------------------------------------------------------ |
| **General Discussion**   | <a href="https://github.com/festivals-app/festivals-documentation/issues/new/choose" title="General Discussion"><img src="https://img.shields.io/github/issues/festivals-app/festivals-documentation/question.svg?style=flat-square"></a> </a>   |
| **Concept Feedback**    | <a href="https://github.com/festivals-app/festivals-documentation/issues/new/choose" title="Open Concept Feedback"><img src="https://img.shields.io/github/issues/festivals-app/festivals-documentation/architecture.svg?style=flat-square"></a>  |
| **Other Requests**    | <a href="mailto:phisto05@gmail.com" title="Email Festivals Team"><img src="https://img.shields.io/badge/email-Festivals%20team-green?logo=mail.ru&style=flat-square&logoColor=white"></a>   |

## Licensing

Copyright (c) 2020 Simon Gaus.

Licensed under the **GNU Lesser General Public License v3.0** (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at https://www.gnu.org/licenses/lgpl-3.0.html.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the [LICENSE](./LICENSE) for the specific language governing permissions and limitations under the License.

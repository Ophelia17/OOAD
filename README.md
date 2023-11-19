# Enono

### CSN-291 Course Project, IITR

Enono is a meeting scheduler app built in flutter to optimize your time.



## Getting Started

### Prerequisites

git version : ^2.32.0
flutter version : 3.3.1
dart version : ^2.18.0

A detailed guide for multiple platforms flutter setup could be find [here](https://docs.flutter.dev/get-started/install)

### Installation

To clone the repository, either use the Git GUI if you have one installed or enter the following commands:
```bash
git clone https://github.com/Coder-Manan/Enono.git
cd Enono
```

### Setup

- `flutter pub get` to get all the dependencies.
- `flutter run`

This app uses Google Firebase as backend, for setup of the same:

1. Create a firebase project.
2. Download `google-services.json` from firebase and place in `android/app/`.



## About

### Features

App features include:
1. Directory for IITR campus
2. Find your friend
3. Search for optimal destinations to meet
4. Manage your friends list
5. Personal Scheduler

### Description

The base for Enono is the mam of IITR campus with major locations fed into it.

One can send friend requests. A request once accepted gives you permission to view the friend's location.

At a time you can choose any of your friends and search for the best places to meet-n-greet. Search for these optimal destinations will be based on proximity from both the users and what's the motive of the meet (can be eat, study or anything falling in the provided categories).

Complementary feature includes a personal scheduler to manage your day-to-day activities.

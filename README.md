# Wellness Creator App

## Overview
Wellness Creator is an iOS app built using SwiftUI that integrates with Metal shaders, HealthKit, ChartKit, and AVAudio. The app allows users to create customizable breath sessions, similar to Apple’s Breathe app, with additional features such as customizable shapes, colors, and audio. This app is also integrated with HealthKit to display heart rate data and uses ChartKit to show weekly heart rate trends. Users can save their creations in a JSON format, which is easily compatible with document-based databases like MongoDB. The app will soon feature a marketplace for users to buy and sell wellness content, as well as a searchable library for discovering wellness sessions.

## Key Features

### Customizable Breathing Sessions
- **Shape & Pattern Customization**: Users can choose from a variety of shapes, or create their own, using Metal Shaders and the default Apple Shapes library.
- **Audio Integration**: Add relaxing sounds or music to enhance the breathing experience. Audio is seamlessly managed using AVAudio.
- **Colors & Themes**: Personalize the look of each session with custom colors and transitions.

### HealthKit Integration
- **Heart Rate Monitoring**: HealthKit is used to display daily and weekly heart rate data.
- **Visual Heart Rate Trends**: Weekly heart rate trends are visualized using ChartKit.

### JSON Export & Document DB Compatibility
- **Save Creations**: Sessions can be saved and exported in JSON format, making it easy to integrate with external document databases like MongoDB.
- **Future Marketplace**: Plans to introduce a marketplace for users to sell and buy wellness content.

### Searchable Wellness Library
- **Explore Creations**: Users can explore a library of pre-created wellness sessions, which can be searched by type, shape, color, and audio.

## Requirements

- **iOS 18** or later
- Xcode (latest version) for building the project
- A physical iPhone running iOS 18 to test and deploy

## Setup Guide

### 1. Clone the Repository
First, clone the repository to your local machine:

```
git clone https://github.com/your-repo/wellness-creator.git
```

### 2. Open the Project in Xcode
- Navigate to the project directory and open the .xcodeproj file with Xcode.

### 3. Set Up Your iOS Device
-  Ensure you have a physical iPhone running iOS 18 or later, as the app requires this version to function properly.
- Connect your iPhone to your Mac using a USB cable.
- Select your iPhone as the target device in Xcode.
- Trust the device if prompted.


## 4. Build and Run the Project
- In Xcode, click the Run button or press Cmd + R to build and deploy the app to your connected device.

5. Testing
Once the app is installed, you can start creating breathing sessions, check your heart rate data, and experiment with the available shapes, colors, and audio options.

Architecture

The app is built using modern iOS development principles, utilizing MVVM. 

---
## Upcoming Features

Marketplace: Soon, you’ll be able to sell and buy wellness creations.
Community Creations: Upload and share your personalized sessions with other users.
Extended Database Support: The app will soon be integrated with a document-based DB (e.g., MongoDB) for storing user data and wellness creations.
Contributing

We welcome contributions! If you have ideas for new features, bug fixes, or general improvements, feel free to open an issue or submit a pull request. Be sure to fork the repo and follow standard contribution practices.

License

This project is licensed under the MIT License - see the LICENSE file for details.

# Demo-iOS-ARKit
This  demo app utilizes the ARKit framework and Transport for London's API. The purpose of the app is to showcase a visual representation of a bus route and stops. The app uses data from TFL's API to obtain information about the bus routes and their corresponding geographical coordinates. By leveraging coreLocation and the obtained data, the app calculates the position of each bus stop in the ARKit view, allowing users to see the bus routes and stops in an augmented reality environment.

![ezgif com-optimize](https://github.com/Ade-Conjure/Demo-iOS-ARKit/assets/127490348/2d8d0a9a-2904-498e-9f78-6192830a16c7)


CoreLocation plays a crucial role in providing the user's coordinates. By leveraging the coreLocation framework, the app determines the precise geographical coordinates of the user. This data serves as a reference point for positioning the user's location relative to the bus stops in the view.

To visually represent the bus stops, the app employs cubes as markers in the ARKit view. Each cube represents a bus stop along the bus routes. The app calculates the position of each cube based on the user's location obtained through coreLocation and the coordinates of the bus stops fetched from TFL's API.

The cubes not only serve as visual markers but also provide interactive functionality. When a user taps on a cube representing a bus stop, the app responds by displaying the name of the corresponding bus stop. This feature enhances the user experience by providing additional information and facilitating easy identification of bus stops within the AR environment.

Overall, using coreLocation, the demo app accurately determines the user's location, allowing the view to display the user's position relative to the bus stops. The cubes in the ARKit view represent the bus stops, and tapping on a cube triggers the display of the corresponding bus stop's name, providing an interactive and informative experience for the user.

## Requirements
This project requires that you enable location services on your device, and permission to use camera on the device. Also, you will need to get a Transport for London API id and key from their developer's webpage.

Once you have the API id and key, please enter them in the Constants.swift file in the Xcode project.

```swift
    struct Constants {
        static let transportForLondonKey = "ENTER_TFL_API_KEY"
        static let transportForLondonAppID = "ENTER_TFL_API_ID"
    }
```

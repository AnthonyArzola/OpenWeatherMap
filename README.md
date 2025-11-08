## OpenWeatherMap

**OpenWeatherMap** is a **Swift Package** that simplifies communication with OpenWeatherMap API to retrieve weather information.

Currently, this packages does not have any third-party dependencies.

## Getting Started

1. Get OpenWeatherMap API [key](https://openweathermap.org/appid)

2. Add package to your project (Xcode > File > Swift Packages > Add Package Dependency... )
3. Update project target to reference OpenWeatherMap library (Targets > Frameworks, Libraries, and Embedded Content > touch "+" button)
4. Add `import OpenWeatherMap` to your Swift file

5. Call methods, get weather and enjoy!


## Example

The OpenWeatherMap service supports three concurrency patterns: **Closures**, **Combine**, and **Async-Await**.

### Closure-based

```swift
let weatherService = OpenWeatherMapService(apiKey: "YOUR_API_KEY")

// Get weather by coordinates
weatherService.currentWeatherAt(latitude: 37.7749, longitude: -122.4194) { (success: Bool, weather: CityWeather?) in
    if success, let weather = weather {
        print("Temperature: \(weather.currentWeather.temp)")
    } else {
        print("Failed to retrieve weather")
    }
}
```

### Combine

```swift
import Combine

let weatherService = OpenWeatherMapService(apiKey: "YOUR_API_KEY")
var cancellables = Set<AnyCancellable>()

// Get weather by city name
weatherService.currentWeatherAt(cityName: "San Francisco")
    .sink { completion in
        // Handle completion
    } receiveValue: { weather in
        print("City: \(weather.name)")
    }
    .store(in: &cancellables)
```

### Async-Await

```swift
let weatherService = OpenWeatherMapService(apiKey: "YOUR_API_KEY")

Task {
    do {
        // Get weather for multiple cities around coordinates
        let results = try await weatherService.currentWeatherAt(latitude: 37.7749, longitude: -122.4194, cityCount: 10)
        print("Found \(results.results.count) cities")
        
    } catch {
        print("Error: \(error)")
    }
}
```


## Weather Images
OpenWeatherMap API specifies image name and provides a basic set of images. For alternative images, look at [LocalWeatherImages](https://github.com/AnthonyArzola/LocalWeatherImages "LocalWeatherImages on GitHub")


## License
The MIT License (MIT)

Copyright (c) 2019 Anthony Arzola

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


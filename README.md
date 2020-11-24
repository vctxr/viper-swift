# VIPER Architecture in iOS 🐍

<p float="left">
  <img src="/Assets/main.png" width="300" height="auto" hspace="50"/>
  <img src="/Assets/filter.png" width="300" height="auto" hspace="50"/>
</p>

iOS app for searching Rick and Morty Characters. Built using UIKit and VIPER architecture to fetch and retrieve data from the API. I built this app to learn about VIPER to have a more hands on approach on the topic.

> **Note:** The VIPER architecture implemented in this app is **NOT** a strict VIPER architecture as I am still learning this architecture and there may be some things that is different from the original VIPER.

# ✨ Features

- Fetch data from the API
- Infinite scrolling to fetch more data from the API
- Async image loading and caching to save user's mobile data and less battery usage
- Search for characters with search throttling to make sure we don't send unnecessary request to the API
- Error handling (no data, no internet, bad response, failed to decode)
- Loading indicators
- Filter characters by status
- Supports dark mode and works on notch or notchless iPhones
- No third-party dependencies/libraries
- VIPER architecture

# Flickr Party (TDD)
**FlickrParty** is a simple iOS app built using [Test Driven Development \(TDD\)](https://en.wikipedia.org/wiki/Test-driven_development). in the [Swift](http://swift.org/) programming language.

It also **_tries_** to implement the following practices:

- SOLID Object Oriented Design Principles. \[[Read More...](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design))\]
-  Object Oriented Design (OOD) in Swift. \[[View](https://github.com/ochococo/OOD-Principles-In-Swift)\]
- The Official [raywenderlich.com](http://raywenderlich.com) Swift Style Guide. [View](https://github.com/raywenderlich/swift-style-guide)
- No `Storyboards` or `Nib` files
- Lean ViewController and proper use of MVC
- Use as few external dependencies, frameworks and libraries as possible.

#### Depedencies: ####

This app uses the following external frameworks:
- [Kingfisher](https://github.com/onevcat/Kingfisher) : A lightweight and pure Swift implemented library for downloading and caching image from the web.
- [Reachability](https://github.com/ashleymills/Reachability.swift) : Replacement for Apple's Reachability re-written in Swift 

The dependencies have been added using [Carthage](https://github.com/Carthage/Carthage) : A simple, decentralized dependency manager for Cocoa.

##### How to use: #####
1. Clone or Download the repository
2. Launch the `Terminal` app and run `carthage update` from the project's root directory.
3. Open the project in `Xcode` (Tested on `Xcode 7.3.1`)..
4. Change the `applicationKey` value in the `Config` struct in `FlickrAPIService` (FlickrTDD > Model > Flickr > FlickrAPIService.swift file) to a valid **FlickrAPI application key**.
5. `Build` and `Run`

#### Notes: ####
This project is intended to be part of a learning process for me. I plan to make several changes to this repo based on new findings / learnings. My objective is to write - clean and maintainable code.

I welcome all feedback, criticism, suggestions for improvements.
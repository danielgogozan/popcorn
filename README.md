# popcorn
*Popcorn* is an iOS app that fetches data from [TMDB](https://www.themoviedb.org/) so that the user is able to discover movies and find details about their cast, reviews and other information.

# purpose
The main challenges of this app were to:
- develop a proper **MVVM** architecture
- understand **Coordinator** pattern
- understand **RxSwift concepts** in order to fulfill different requirements
- build an abstract and reusable **networking layer**
- implement a **custom UI** only by code in order to gain a better understanding of constraints, constraint priorities and other concepts
- integrate **Swiftgen**
- write **tests**

Also the app is using a bunch of custom views, different approaches on collection views and table views.

# explore

![App flow](https://i.ibb.co/5hRqCFH/popcorn-screens.jpg)

Clone the project, open Popcorn.xcworkspace, run *pod install* and see the results.

# note
You will notice some of the buttons having no effect or images with erroneous ratios. This is due to the fact that these are not necessarily the subject of the application which is intended to be more demonstrative of the points mentioned in the purpose section.

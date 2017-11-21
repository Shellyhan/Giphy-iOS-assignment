# Giphy-iOS-assignment

### Structure:
MVVM

### Setup:
Swift 3, Xcode 8
(Adapted older versions for better performance with Rx libraries)

### Major Pods used:
1. RxSwift
2. RxCocoa
3. Moya provider
4. SnapKit for detial cell's views layout
5. Kingfisher for Gif image display and cache
6. CoreData for user's favorite gifs

### Features:

####Table view for trending/searched gifs:

1. SearchBar auto searching
2. Like/unlike button (only gif URL stored locally, since KingFisher provides caching)
3. Pagination


####Collection view for favorites gifs:

1. Like/unlike button
2. Auto update between two tabs


### References:
1. https://github.com/avicks/GIFApp for Gif and API model setup
2. https://github.com/devxoul/RxTodo for core data intergration
3. https://github.com/DroidsOnRoids/RxSwiftExamples for structure setup
4. https://developers.giphy.com/docs/ for Giphy API

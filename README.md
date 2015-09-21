# RottenTomatoes

Simple implementation of Flixster app


Time spent: ~ 20 hours


Here is what I have implemented:
- User can view a list of movies from Rotten Tomatoes. Poster images loading asynchronously.
- User can view movie details by tapping on a cell.
- Used MBProgressHUD to show loading state while waiting for response from movies API.
- User sees error message when there's a networking error.
- User can pull to refresh the movie list.
- Added a tab bar for Box Office and DVD. [O]
- Added a search bar. [O]
- All images fade in. [O]
- For the large poster, loading the low-res image first, and switching to high-res when complete [O]
- Customize the navigation bar. [O]
- Customized the highlight and selection effect of the cell (partly): 
  - deselecting the selected cell after punching into detail view


Not Implemented yet:
- Implement segmented control to switch between list view and grid view


I couldnt figure out the following, and appreciate any pointers:
- How to add pan gesture to movie detail view and show more synopsis.
- How to change the selected color for UITabBar.
- I think the fade in effect for pictures is kicking in for pictures in cache as well. How do I debug this?


Walkthrough:
![alt tag](https://github.com/udaymitra/RottenTomatoes/blob/master/walkthrough.gif)



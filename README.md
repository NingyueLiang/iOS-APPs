# iOS-APPs
## Foocus: 
### A Productivity App built with SwiftUI and Xcode for students and laborers who aimed to improve their effectiveness
App Name: Foocus

Features: Add/Edit/Delete Tasks and all fields in the tasks Setting label for each task Text for description Add an image for each task (Image will be stored in our database) Customize color theme for each task (Notice: We give user free & the right to choose their ideal colors. However, light colors may affect readability) Adding a file to each task which can preview/export that file for convenience (Notice: file can be selected from the local storage/ iCloud.) Setting priority of task Sortable based on priority / Timeline (Todo/doing/done) Group by labels / priority / Timeline Searching for specific task with the name Set due date for each task Realtime Progress bar showing time remaining for each task before the due date

Framework: Swift-UI Database: SQLite

## Movie App: 
### A Movie App built with Xcode and MovieDB API to provide recent/popular movie

New Features: \

a.Favorite List Part 
Saving all the information about a favorited movie locally, so that user can click on the favorite movie and see the movie detail page. 
The favorite button will be disable if the movie is already in the favorite list
User can clear all favorites by the clear button \

b.Recommendation Part
Add getting recommendation function to get similar movies from a particular movie. In the detailed view, clicking on the "get recommendations" button will get user a list of movies recommended according to current movie. User can further click on the recommend movies to see details and favorite them.Usage: If there's no recommendation available yet, an alert will show up to notice user.
Showing popular movies when the app launches \

c. YouTube previews & clips
User can watch the previews & clips on YouTube about a particular movie inside the app, by clicking on the "Youtube Preview" button in the detailed view  \


How to add those features and what the process involved: \
a. Saving all the information using userDefault and load the detailed page from the information stored in userDefault. Push a detail view controller to the navigation controller in the favorite list view.
Check the userDefault to see if a movie is already in the favorite list.
Remove related information in the local storage. \

b. I use additional MvDb API together with the information stored in the userDefault to create a tableView with list of recommendation movies.
New view controllers are pushed to navigation controller when getting recommandations and view details. UIAlert is used to notice people if there is no recommandation available yet.
Create an API call to fetch popular movie at initialization.\

c. When user click the button, a new view controller is pushed and I use the WebKit, UIWebkit View, together with URLRequest to implement the feature \

Why I added it: \
a. It is very meaningful to save your favorite list and you can see the details of your favorite list at any time. It's also important and convenient to check if a movie is already stored to the favorite list and clear the list at once. \

b. An interesting and significant part of movie apps is to figure out what to watch and getting recommendations, so I implemented this feature to find similar movies of your loved ones. \

c. It will be great to have a chance to preview a movie / watch some clips before deciding whether to see the full movie. The YouTube functionality will help you to archieve that! \

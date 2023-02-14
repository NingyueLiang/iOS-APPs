CSE438 Movie App
Frank Liang
486475

Creative Potion:
1. What you added (and how to use it)
a.Favorite List Part
Saving all the information about a favorited movie locally, so that user can click on the favorite movie and see the movie detail page. (10)
The favorite button will be disable if the movie is already in the favorite list (3)
User can clear all favorites by the clear button (3)

b.Recommendation Part
Add getting recommendation function to get similar movies from a particular movie. In the detailed view, clicking on the "get recommendations" button will get user a list of movies recommended according to current movie. User can further click on the recommend movies to see details and favorite them.Usage: If there's no recommendation available yet, an alert will show up to notice user. (10)
Showing popular movies when the app launches (5)

c. YouTube previews & clips
User can watch the previews & clips on YouTube about a particular movie inside the app, by clicking on the "Youtube Preview" button in the detailed view (10)


2. How you added it and what the process involved
a. Saving all the information using userDefault and load the detailed page from the information stored in userDefault. Push a detail view controller to the navigation controller in the favorite list view.
Check the userDefault to see if a movie is already in the favorite list.
Remove related information in the local storage.

b. I use additional MvDb API together with the information stored in the userDefault to create a tableView with list of recommendation movies.
New view controllers are pushed to navigation controller when getting recommandations and view details. UIAlert is used to notice people if there is no recommandation available yet.
Create an API call to fetch popular movie at initialization.

c. When user click the button, a new view controller is pushed and I use the WebKit, UIWebkit View, together with URLRequest to implement the feature

3. Why you added it
a. It is very meaningful to save your favorite list and you can see the details of your favorite list at any time. It's also important and convenient to check if a movie is already stored to the favorite list and clear the list at once.

b. An interesting and significant part of movie apps is to figure out what to watch and getting recommendations, so I implemented this feature to find similar movies of your loved ones.

c. It will be great to have a chance to preview a movie / watch some clips before deciding whether to see the full movie. The YouTube functionality will help you to archieve that!

Extra Credit:
1. Submitted Studio 3 (5)
2. Implement a Context Menu for the movies in the UICollectionView and have "add to favorite" function implemented through contextMenuConfigurationForItemAt in collection view and userDefault (10)


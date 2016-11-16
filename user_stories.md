# User Stories

## *Auth Screen:*
- [X]  Create view controller (logo and fb button)
- [X] Add click event to authenticate
- [X] Authenticate with Facebook
- [X] Store current user variable
- [ ] Store user in database
- [X] Segue to the map view

Map Screen:
- [ ] Create view controller (map, search bar, navigation controller, tab bar)
- [X] Allow location services
- [X] Display map on your current location
- [ ] Show the markers for any activities close to you on the map
- [ ] Open "create new activity" window modally when clicking on the map
- [ ] Bonus: display a info bubble when you tap an activity on the map giving you a summary of the activity
- [ ] Add segmented control to switch between map view and list view
  - [ ] Clicking on map segment should show map
  - [ ] Clicking on list segment should show list
    - [ ] Order list by proximity
- [ ] Add search bar
  - [ ] Filter activity list by name of activity
  - [ ] Filter activity dots in map by name of activity
- [ ] Add filter button
  - [ ] Place filter button left of the search bar
  - [ ] Link onClick event modally to the filter screen view controller
- [ ] Add tab bar
  - [ ] Create three sections: settings, create activity, profile
  - [ ] Display settings screen when clicking settings
  - [ ] Display profile screen when clicking profile
  - [ ] Display new activity screen modally when clicking the new activity button
- [ ] Link to activity details page
  - [ ] Open activity details screen when tapping on an activity on the map
  - [ ] Open activity details screen when tapping on an activity on the list view

Filter Screen:
- [ ] Add view controller
- [ ] Add cancel button which closes filter modal screen
- [ ] Add search button which closes filter modal screen and passes back filtered parameters
- [ ] Add search filters to the view
  - [ ] Start time ui element
  - [ ] End time ui element
  - [ ] Bonus: Maximum distance radius slider
  - [ ] Add tags
    - [ ] Text field with autocomplete
    - [ ] View showing tags that have been added
    - [ ] Add delete x next to tag name to be able to remove it
  - [ ] Add "Clear All" button to clear all filters   
- [ ] Pass filters object back to map screen through segue

New Activity Screen:
- [ ] Add view controller
- [ ] Add cancel button that closes modal
- [ ] Add save button that closes modal and saves activity to DB
- [ ] Search for location in Google places search bar
  - [ ] Implement google places search bar
  - [ ] When typing address it should start autocompleting addresses
  - [ ] After selecting address, field should display address
  - [ ] If you click field again you can start typing again  
- [ ] Optional: Add event image through camera roll
- [ ] Add text field for event title
- [ ] Add text field for event description
- [ ] Add number of allowed participants
- [ ] Add start datetime
- [ ] Add end datetime
- [ ] Add tags
  - [ ] Text field with autocomplete
  - [ ] View showing tags that have been added
  - [ ] Add delete x next to tag name to be able to remove it
- [ ] Bonus: Validate form so required activity fields can't be empty
- [ ] Optional: Add ability to invite friends to event

Actity Details Screen:
- [ ] Create view controller
- [ ] Load activity from db using activity_id passed from segue
- [ ] Display event image
- [ ] Display event title
- [ ] Display event description
- [ ] Display written address
  - [ ] Optional: if you click on the address it should segue into a map view of the address
- [ ] Display start and end time
- [ ] Display list of tags associated to the activity  
- [ ] Display the organizer small profile image and name
  - [ ] Click on organizer should take you to his or her profile screen
- [ ] Display "attendee" section with the picture and name of any other attendees
  - [ ] Ability to see that users profile by tapping on the users name  
- [ ] Add button to "enroll" in the activity
  - [ ] click event should add user to the activity in the db
  - [ ] should add users image and name to the attendee list
  - [ ] Should change "enroll" button to unenroll
    - [ ] If clicked unenroll it should remove user from attendee list and database
  - [ ] Optional: When clicking on enroll, it should create new chat between attendees in the chat section of the app
    - [ ] Display little icon that will segue you to the chat of that activity
- [ ] If user is the organizer of the activity form should show an edit button
  - [ ] When tapping on edit button it should convert screen into the "create activity screen"
  - [ ] It should allow user to change activity details
  - [ ] After saving it should show updated activity details page 
  - [ ] Events that already happened shouldn't give you the option to edit

Profile Screen:
- [ ] Create view controller
- [ ] First section: user info
  - [ ] Display user avatar
  - [ ] Display user name
  - [ ] Display user short bio
  - [ ] Display user interests
    - [ ] It could display facebook interests
    - [ ] Or, alternatively it could show the list of tags that the user has used in the past
- [ ] Second section: upcoming activities
  - [ ] Show table view list of upcoming events sorted by date
  - [ ] If tap on event should segue to event details page
- [ ] Third section: past activities
  - [ ] Show table view list of past events sorted by date
  - [ ] If tap on event should segue to event details page

Settings Screen:
  - [ ] Create view controller
  - [ ] Turn on, turn off notifications
  - [ ] Default activity length
  - [ ] Default number of attendees
  - [ ] Log Out
  - [ ] Delete account

Bonus:
Implement chat section in tab bar menu
  - [ ] Screen should show a table view list of all your active chats
  - [ ] Tapping into a chat should segue you into a chat window with the activity attendees
    - [ ] Create chat service in the backend
    - [ ] When an chat participant sends a message the other group members should receive a push notification
  - [ ] Optional: Chat should disappear when activity is finished

Implement push notifications:
  - [ ] Setup push notifications for different events
    - [ ] When attendee joins activity
    - [ ] X amount of minutes before the activity
    - [ ] When someone sends you a chat message






# Final Project - *Cita App - Sprint 2*

Time spent: **20** hours spent in total

## User Stories

SH -> Sara Hender  
SG -> Santiago Gomez  
SC -> Stephen Chudleigh  

The following functionality is completed:

## **Map Screen:** (SG)
- [X] Create view controller (map, search bar, navigation controller, tab bar)
- [X] Allow location services
- [X] Display map on your current location
- [X] Show the markers for any activities close to you on the map
- [X] Open "create new activity" window modally when clicking on the map
- [X] Add segmented control to switch between map view and list view
  - [X] Clicking on map segment should show map
  - [X] Clicking on list segment should show list
    - [X] Order list by proximity
- [X] Add search bar
- [X] Add filter button
  - [X] Place filter button left of the search bar
  - [X] Link onClick event modally to the filter screen view controller
- [X] Add tab bar
  - [X] Create three sections: settings, create activity, profile
  - [X] Display settings screen when clicking settings
  - [X] Display profile screen when clicking profile
  - [X] Display new activity screen modally when clicking the new activity button
- [X] Link to activity details page
  - [X] Open activity details screen when tapping on an activity on the map
  - [X] Open activity details screen when tapping on an activity on the list view
### Bonus
- [ ] Filter activity list by name of activity
- [ ] Filter activity dots in map by name of activity

## **New Activity Screen:** (SC)
- [X] Add view controller
- [X] Add Back button that closes modal
- [X] Add save button that closes modal and saves activity to DB
- [X] Add text field for event name
- [X] Add text field for event description
- [X] Add number of allowed participants
- [X] Add start datetime
- [X] Add end datetime
- [X] Validate form so required activity fields can not be empty
### Bonus
- [ ] Add ability to invite friends to event
- [ ] Add event image through camera roll

## **Back End Realtime Integration** (SC)
- [X] Create activity observer to update the list of activities
- [X] Create search functionatlity to filter db activities by query params

## **Actity Details Screen:** (SH)
- [X] Create view controller
- [X] Load activity from db using activity_id passed from segue
- [X] Display event title
- [X] Display event description
- [X] Display written address
  - [ ] Optional: if you click on the address it should segue into a map view of the address
- [X] Display start and end time
- [X] Display the organizer small profile image and name
- [X] Display "attendee" section with the picture and name of any other attendees
- [X] Add button to "enroll" in the activity
  - [X] click event should add user to the activity in the db
  - [X] should add users image and name to the attendee list
  - [X] If clicked unenroll it should remove user from attendee list and database
### Bonus
- [ ] When clicking on enroll, it should create new chat between attendees in the chat section of the app
  - [ ] Display little icon that will segue you to the chat of that activity

## Video Walkthrough

Here's a walkthrough of implemented user stories:

[Imgur](http://i.imgur.com/vK7ERVt.gifv)
<img src='http://i.imgur.com/vK7ERVt.gifv' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2016] [Codepath Cita]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

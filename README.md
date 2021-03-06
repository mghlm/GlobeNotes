# Globe Notes

*Globe Notes is an app that lets users add notes based on their current location, and explore other notes added around the world either in a map or as a list.*

### Approach taken

The app is built using a simple MVP (model-view-presenter) architecture, where the presenter is responsible for most of the business logic as well as the navigation. To scale this app, a coordinator pattern could be introduced as further separation of concerns and easier testing.

The app is built using a protocol oriented approach.

### Technologies used

- [Swift](https://developer.apple.com/swift/)
(Main language used to built the app.)

- [Firebase](https://firebase.google.com/)
(Backend)

### How to test it

To login, simply create a new user with a valid email address format and a password containing both letters and numbers.
You are also welcome to use the following test account:
Email: "Testaccount@gmail.com"
Password: "test123"

### Known issues

- Delete button has no functionality yet

- UI feedback of bad formatting of email / password not implemented yet

- Extremely slow or disabled network is not handled

- Apple's rate on geolocate requests are time limited, meaning if a user is to navigate back and forth between the home screen and the details screen, the location of the note (city and country) might not be able to be fetched. From Apple's documentation on the subbject: *Geocoding requests are rate-limited for each app, so making too many requests in a short period of time may cause some of the requests to fail. When the maximum rate is exceeded, the geocoder passes an error object with the value network to your completion handler.* https://developer.apple.com/reference/corelocation/clgeocoder/1423621-reversegeocodelocation

### Future Improvements / Additions

- Add more unit tests

- Add end-to-end UI tests (screens are set up with UI-elements)

- Introducing a coordinator pattern 

- Option to add photo to note

- Add Acitivity-Indicator

- Add refresh controller

- Add buttons to map to toggle between all/one note and center on location

### Screenshots

![alt text](https://i.imgur.com/ZWIRN0o.jpg)

### User stories for MVP:

```
As a user (of the application) I can see my current location on a map
```
```
As a user I can save a short note at my current location
```
```
As a user I can see notes that I have saved at the location they were saved on the map
```
```
As a user I can see the location, text, and user-name of notes other users have saved
```
```
As a user I have the ability to search for a note based on contained text or user-name
```

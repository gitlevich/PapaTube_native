# Papa Tube

## Goal

To allow an elderly person with physical or mental deficiencies to watch YouTube videos on iPad 
without navigating complexities of the native YouTube player.

## Definitions

1. Player: the main, simplified interface the elderly interacts with
2. Video: a YouTube video
3. Current video: the playlist video currently displayed in the Playlist 
4. Playlist: a list of videos in a specific order, built by the caretaker and available for the elderly
5. Controls: 
    - play/pause toggle button: pressing it toggles video from paused to playing and back and updates the button icon
    - previous video button: pressing it causes the next video in the playlist to show in the player; 
        disabled if current video is the first
    - next video button: pressing it causes the prev video in the playlist to show in the player; 
        disabled if current video is the last
    - scrub bar: scrubbing it right fast forwards the video to the frame where it is released; 
        scrubbing left rewinds it to the frame where it's released 

## Stories

The target user of this app is a person with difficulties controlling a tablet or a computer. 
I modeled the stories below on the needs of my father, who developed aphasia and apraxia as the result of stroke, making
it impossible for him to navigate any UI that requires planning, reading text, etc.

**Primary User (PU)**: 

As a person using the app for entertainment, I want to: 

### Onboard

1. when first opening the app, to select my preferred language 
    so that the app generates the initial playlist in the language i understand.     

### Watching videos

1. open the app and see a full-screen player window with the first playlist video loaded and 3 big buttons: 
    previous, play and next, so that I could watch it
2. press play button so the current video plays
3. press forward button so I could go to the next video
4. press next button so I could go to the previous video
5. scrub through the video with an easy to touch scrub bar so i can skip boring places
6. not to see any text labels but clear obvious icons on any buttons so that I know what to press because i cannot read
7. be able to touch anywhere on the screen but the buttons and have the player NOT react to my touch so that it continues the action
    i explicitly chose with the button and not start/stop when I accidentally touch the screen with my unsteady hand. 
8. have the controls (3 buttons and the scrub bar) partially fade in 30 seconds so that they don't obscure the video
9. have the faded controls still visible enough so i could easily find them on the screen
10. have any touch of the screen outside controls bring them to full brightness so i can locate them if i did lose them 
11. have the screen not to turn off while i watch the video
12. have the screen turn off if the video is not playing and i have not touched 
13. have the app generate playlists based on my watch history
14. indicate whether i liked a video I watched to help the app build a better playlist 



--------------------  F U T U R E   O P T I O N A L   S T O R I E S  ----------------------------------------

### Manage the playlist

Here, we let the user build playlist by selecting their topics of interest (configured separately, eg during onboarding)
These stories describe interactions that may exceed the abilities of the primary user and require help of another. 
However the goal is to make them as trivial and clear as possible.

1. open playlist builder screen to build a playlist via a special interaction with the screen that is both simple enough for
    me to do and hard to trigger accidentally
2. on playlist builder screen, to see topics i am interested in as cards with clear visuals i can select to build my playlist
3. tap an unselected card to include it into the search
4. tap a selected card to exclude it from the search
5. tap a build button that will generate a playlist
6. preview the playlist as a filmstrip of included videos   
7. tap a video in the filmstrip to preview it in place  


### Onboarding

These stories describe interactions that may require help of a caretaker, so we describe them from the caretaker's point of view

As a **Caretaker**, I want to:

1. configure the language(s) of youtube videos to so that the Primary User builds playlist with videos in familiar language.
2. define topics my PU cares about to use as YT search criteria for to building playlists interesting to PU
3. specify max playlist length

# Papa Tube

## Goal

To allow an elderly person with physical or mental deficiencies to watch YouTube videos on iPad 
without navigating complexities of the native YouTube player.

## Definitions

1. Player: the main, simplified interface the elderly interacts with
2. Video: a YouTube video
3. Current video: the playlist video currently displayed in the Playlist 
4. Playlist: a list of videos in a specific order, built by the caretaker and available for the elderly
5. Playlist Controls: 
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

### Playlists

1. get the Regenerate Playlist button appear when i got bored with current playlist so that i could press it and have the
    app generate a new one
2. have the app generate playlists based on my watch history so that the included videos are relevant and interesting to me




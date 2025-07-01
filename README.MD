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
    - previous video button: pressing it causes the previous video in the playlist to show in the player; 
        disabled if current video is the first
    - next video button: pressing it causes the next video in the playlist to show in the player; 
        disabled if current video is the last
    - scrub bar: scrubbing it right fast forwards the video to the frame where it is released; 
        scrubbing left rewinds it to the frame where it's released 


## Stories

The target user of this app is a person with difficulties controlling a tablet or a computer. 
I modeled the stories below on the needs of my father, who developed aphasia and apraxia as the result of stroke, making
it impossible for him to navigate any UI that requires planning, reading text, etc.

As a person using the app for entertainment, I want to: 

### Onboard

1. when first opening the app, to select my preferred language so that the app generates the initial playlist in the language I understand.    

### Watching videos

1. open the app and see a full-screen player window with the first playlist video loaded and 3 big transport-icon buttons — previous, play/pause and next — so that I can start watching immediately
2. see only clear, obvious icons on all buttons (no text labels) so that I know what to press even though I cannot read
3. press the play/pause button so the current video starts or stops playing
4. press the next button so I can go to the next video in the playlist
5. press the previous button so I can return to the previous video in the playlist
6. scrub through the current video with an easy-to-touch scrub bar so I can skip boring parts
7. touch anywhere on the screen outside the controls and have the player NOT react so it continues the action I explicitly chose and does not start/stop when I accidentally touch the screen with my unsteady hand
8. have the screen stay awake while a video is playing so that playback is not interrupted
9. have the screen turn off if the video is paused and I have not touched anything for a while so that battery is not wasted
10. have the controls (3 buttons and the scrub bar) automatically fade out after 30 seconds of no interaction so they don't obscure the video
11. have the faded controls remain visible enough that I can still locate them on the screen
12. bring the controls back to full brightness with any touch of the screen outside the controls so I can easily find them again
13. reopen the app and have the video I watched last time displayed at the frame I last saw, so that I can continue watching from where I left off
14. navigate away from the current video and back, and have the video resume at the frame I last saw, so that I can continue watching seamlessly

### Playlists

1. see a Regenerate Playlist button when I get bored with the current playlist so I can press it to generate a new one
2. have the app generate playlists based on my watch history so that the included videos are relevant and interesting to me




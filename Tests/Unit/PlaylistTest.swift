//
//  PlaylistTest.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 7/1/25.
//

import Foundation
import Testing

@testable import PapaTube

@Suite("Playlist")
struct PlaylistTest {

        
    @Test
    func emptyPlaylistShouldHaveDeterministicDefaults() throws {
        let empty = Playlist.empty
        #expect(empty.videos.isEmpty)
        #expect(empty.currentVideo == .none)
        #expect(empty.currentVideoStart == 0)
    }
    
    @Test
    func emptyPlaylistShouldHaveNoNextVideo() throws {
        let empty = Playlist.empty
        #expect(empty.hasNext() == false)
    }
    
    @Test
    func emptyPlaylistShouldHaveNoPrevVideo() throws {
        let empty = Playlist.empty
        #expect(empty.hasPrev() == false)
    }

    @Test
    func newPlaylistShouldDefaultToFirstVideo() throws {
        let playlist = Playlist.playlistOf3
        #expect(playlist.currentVideo == playlist.videos.first)
    }

    @Test
    func newPlaylistShouldHaveNoPrevVideo() throws {
        let playlist = Playlist.playlistOf3
        #expect(playlist.hasPrev() == false)
    }

    @Test
    func newPlaylistWithMoreThan2VidosShouldHaveNextVideo() throws {
        let playlist = Playlist.playlistOf3
        #expect(playlist.hasNext() == true)
    }

    @Test
    func playlistOnLastVideoShouldHaveNoNext() throws {
        var playlist  = Playlist.playlistOf3
        #expect(playlist.size == 3, "precondition")
        
        playlist.moveToNext()
        playlist.moveToNext()
        #expect(playlist.next() == nil, "precondition: no next video exists")
        
        #expect(playlist.hasNext() == false, "next bookmark should not exist")
    }

    @Test
    func playlistParkedOnVideoInTheMiddleShouldHavePrevious() throws {
        var playlist = Playlist.playlistOf3
        playlist.moveToNext()

        #expect(playlist.currentVideo == playlist.videos[1], "precondition: should be on second video")
        #expect(playlist.hasPrev() == true, "precondition: previous video exists")

        #expect(playlist.previous() != nil, "previous bookmark should exist")
    }
    
    @Test
    func playlistParkedOnVideoInTheMiddleShouldHaveNext() throws {
        var playlist = Playlist.playlistOf3
        playlist.moveToNext() // move to middle video

        #expect(playlist.currentVideo == playlist.videos[1], "precondition: should be on second video")
        #expect(playlist.hasPrev() == true, "precondition: previous video exists")

        #expect(playlist.next() == Video.v3, "previous bookmark should exist")
    }
    
    @Test
    func navigationMutatesCurrentVideo() throws {
        var playlist = Playlist.playlistOf3
        
        #expect(playlist.videos.count == 3, "precondition")
        #expect(playlist.videos[0] == Video.v1, "precondition")
        #expect(playlist.videos[1] == Video.v2, "precondition")
        #expect(playlist.videos[2] == Video.v3, "precondition")

        // initial
        #expect(playlist.currentVideo == Video.v1)

        // next 1 -> 2
        playlist.moveToNext()
        #expect(playlist.currentVideo == Video.v2)
        #expect(playlist.hasPrev() == true)
        #expect(playlist.hasNext() == true)

        // next 2 -> 3
        playlist.moveToNext()
        #expect(playlist.currentVideo == Video.v3)
        #expect(playlist.hasNext() == false)

        // prev 3 -> 2
        playlist.moveToPrev()
        #expect(playlist.currentVideo == Video.v2)
    }

}

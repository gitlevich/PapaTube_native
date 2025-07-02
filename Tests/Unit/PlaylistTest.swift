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

    @Suite("Bookmark Navigation")
    struct BookmarkNavigation {
        
        @Test
        func emptyPlaylistShouldHaveNoBookmark() throws {
            let empty = Playlist.empty
            #expect(empty.bookmark == .none)
            #expect(empty.hasNext() == false)
            #expect(empty.hasPrev() == false)
        }
        
        @Test
        func emptyPlaylistShouldHaveNoNextBookmark() throws {
            let empty = Playlist.empty
            #expect(empty.hasNext() == false)
        }
        
        @Test
        func emptyPlaylistShouldHaveNoPrevBookmark() throws {
            let empty = Playlist.empty
            #expect(empty.hasPrev() == false)
        }

        @Test
        func newPlaylistShouldBookmarkFirstVideo() throws {
            let playlist = Playlist.playlistOf3
            #expect(playlist.bookmark.video == playlist.videos.first)
        }

        @Test
        func newPlaylistShouldHaveNoPrevBookmark() throws {
            let playlist = Playlist.playlistOf3
            #expect(playlist.hasPrev() == false)
        }

        @Test
        func newPlaylistWithMoreThan2VidosShouldHaveNextBookmark() throws {
            let playlist = Playlist.playlistOf3
            #expect(playlist.hasNext() == true)
        }

        @Test
        func prevBookmarkAtStartShouldBeNil() throws {
            let playlist = Playlist.playlistOf3

            #expect(playlist.hasPrev() == false, "precondition: no previous video exists")
            #expect(playlist.previousBookmark() == nil, "previous bookmark should not exist")
        }
    
        @Test
        func nextBookmarkAtRightEdgeShouldBeNil() throws {
            var playlist  = Playlist.playlistOf3
            playlist.moveToNext()
            playlist.moveToNext()

            #expect(playlist.nextBookmark() == nil, "precondition: no next video exists")
            #expect(playlist.hasNext() == false, "next bookmark should not exist")
        }

        @Test
        func playlistParkedOnVideoInTheMiddleShouldHavePreviousBookmark() throws {
            var playlist = Playlist.playlistOf3
            playlist.moveToNext()

            #expect(playlist.bookmark.video == playlist.videos[1], "precondition: should be on second video")
            #expect(playlist.hasPrev() == true, "precondition: previous video exists")

            #expect(playlist.previousBookmark() != nil, "previous bookmark should exist")
        }
        
        @Test
        func playlistParkedOnVideoInTheMiddleShouldHaveNextBookmark() throws {
            var playlist = Playlist.playlistOf3
            playlist.moveToNext() // move to middle video

            #expect(playlist.bookmark.video == playlist.videos[1], "precondition: should be on second video")
            #expect(playlist.hasNext() == true, "precondition: previous video exists")

            #expect(playlist.nextBookmark() != nil, "previous bookmark should exist")
        }
        
        @Test
        func navigationMutatesBookmark() throws {
            var playlist = Playlist.playlistOf3
            
            #expect(playlist.videos.count == 3, "precondition")
            #expect(playlist.videos[0] == Video.v1, "precondition")
            #expect(playlist.videos[1] == Video.v2, "precondition")
            #expect(playlist.videos[2] == Video.v3, "precondition")

            // initial
            #expect(playlist.bookmark.video == Video.v1)

            // next 1 -> 2
            playlist.moveToNext()
            #expect(playlist.bookmark.video == Video.v2)
            #expect(playlist.hasPrev() == true)
            #expect(playlist.hasNext() == true)

            // next 2 -> 3
            playlist.moveToNext()
            #expect(playlist.bookmark.video == Video.v3)
            #expect(playlist.hasNext() == false)

            // prev 3 -> 2
            playlist.moveToPrev()
            #expect(playlist.bookmark.video == Video.v2)
        }

    }
}

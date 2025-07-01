//
//  PlaylistTest.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 7/1/25.
//

import Testing
import Foundation

@testable import PapaTube

@Suite("Playlist")
struct PlaylistTest {
    
    // Helper to create playlist with stubs.
    private func makePlaylist(_ videos: [Video]) -> Playlist {
        let spec = PlaylistSpec.reasonableDefault
        return Playlist(id: spec.cacheKey,
                        name: "test",
                        videos: videos,
                        spec: spec)
    }

    @Test("empty playlist defaults bookmark to .none")
    func bookmarkDefaultsToNone() throws {
        let empty = Playlist(id: "x", name: "empty", videos: [], spec: .reasonableDefault)
        #expect(empty.bookmark == .none)
        #expect(empty.hasNext() == false)
        #expect(empty.hasPrev() == false)
    }

    @Test("new playlist with videos bookmarks first video")
    func newPlaylistBookmarksFirstVideo() throws {
        let v1 = Video.stub(id: "1")
        let v2 = Video.stub(id: "2")
        let pl = makePlaylist([v1, v2])
        #expect(pl.bookmark.video == v1)
        #expect(pl.hasPrev() == false)
        #expect(pl.hasNext() == true)
    }

    @Test("moveToNext and moveToPrev navigate correctly")
    func navigationMutatesBookmark() throws {
        var pl = makePlaylist([.stub(id: "1"), .stub(id: "2"), .stub(id: "3")])

        // initial
        #expect(pl.bookmark.video.youtubeId == "1")

        // next 1 -> 2
        pl.moveToNext()
        #expect(pl.bookmark.video.youtubeId == "2")
        #expect(pl.hasPrev() == true)
        #expect(pl.hasNext() == true)

        // next 2 -> 3
        pl.moveToNext()
        #expect(pl.bookmark.video.youtubeId == "3")
        #expect(pl.hasNext() == false)

        // prev 3 -> 2
        pl.moveToPrev()
        #expect(pl.bookmark.video.youtubeId == "2")
    }

    @Test("next/previousBookmark return nil at boundaries")
    func bookmarkHelpersReturnNilAtEdges() throws {
        let vids: [Video] = [.stub(id: "1")]
        var pl = makePlaylist(vids)

        #expect(pl.previousBookmark() == nil)
        #expect(pl.hasPrev() == false)

        #expect(pl.nextBookmark() == nil)
        #expect(pl.hasNext() == false)

        // Add one more video and test nextBookmark()
        pl = makePlaylist([.stub(id:"1"), .stub(id:"2")])
        #expect(pl.nextBookmark()?.video.youtubeId == "2")
    }
}

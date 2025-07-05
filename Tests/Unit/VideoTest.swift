//
//  VideoTest.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 7/4/25.
//

//
//  PlaylistTest.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 7/1/25.
//

import Foundation
import Testing

@testable import PapaTube

@Suite("Video Tests")
struct VideoTest {
    
    private var sixtySecondsVideo = Video.v1
    
    @Test
    func progressAtStartShouldBe0Precent() throws {
        #expect(sixtySecondsVideo.progressAt(second: 0) == 0)
    }
    
    @Test
    func progressAtEndShouldBe100Percent() throws {
        #expect(sixtySecondsVideo.progressAt(second: 60) == 100)
    }
    
    @Test
    func progressAtQuarterShouldBe25Percent() throws {
        #expect(sixtySecondsVideo.progressAt(second: 15) == 25)
    }
    
    @Test
    func progressAtHalfShouldBe50Percent() throws {
        #expect(sixtySecondsVideo.progressAt(second: 30) == 50)
    }
    
    @Test
    func secondsFromStartShouldBeRecoverableFromProgress() {
        #expect(sixtySecondsVideo.secondsFromStart(at: 0.0) == 0)
        #expect(sixtySecondsVideo.secondsFromStart(at: 0.25) == 15)
        #expect(sixtySecondsVideo.secondsFromStart(at: 0.5) == 30)
        #expect(sixtySecondsVideo.secondsFromStart(at: 0.75) == 45)
        #expect(sixtySecondsVideo.secondsFromStart(at: 1.0) == 60)
    }
}

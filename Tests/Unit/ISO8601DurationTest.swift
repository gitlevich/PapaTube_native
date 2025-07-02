import Foundation
import Testing

@testable import PapaTube

@Suite("ISO8601Duration")
struct ISO8601DurationTests {

    @Test("parses hours, minutes and seconds")
    func parsesHMS() throws {
        let seconds = ISO8601Duration.seconds(from: "PT1H23M45S")
        #expect(seconds == 5025)
    }

    @Test("parses days and hours")
    func parsesDaysAndHours() throws {
        let seconds = ISO8601Duration.seconds(from: "P2DT4H")
        #expect(seconds == 172800 + 14400)   // 2 days + 4 hours
    }

    @Test("returns 0 for malformed strings")
    func returnsZeroForMalformedStrings() throws {
        #expect(ISO8601Duration.seconds(from: "foo") == 0)
        #expect(ISO8601Duration.seconds(from: "T5M") == 0)
    }
} 
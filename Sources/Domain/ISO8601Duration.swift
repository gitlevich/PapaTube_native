import Foundation

/// Lightweight helper for parsing ISO-8601 duration strings like "PT1H23M45S".
/// Only the components used by the YouTube Data API are supported (weeks, days,
/// hours, minutes, seconds). Invalid strings yield `0` seconds just like the
/// previous implementation that relied on `ISO8601DurationFormatter`.
enum ISO8601Duration {

    private static let regex: NSRegularExpression = {
        // P[nW][nD](T[nH][nM][nS])? – every numeric capture is optional
        let pattern = #"^P(?:(\d+)W)?(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?)?$"#
        return try! NSRegularExpression(pattern: pattern, options: [])
    }()

    /// Returns the total number of seconds represented by the ISO-8601
    /// duration `string`. Malformed input returns `0` (same behaviour as
    /// before the formatter was removed).
    static func seconds(from string: String) -> Double {
        let range = NSRange(location: 0, length: string.utf16.count)
        guard let match = regex.firstMatch(in: string, options: [], range: range) else {
            return 0
        }

        func value(at index: Int) -> Double {
            guard let r = Range(match.range(at: index), in: string) else { return 0 }
            return Double(string[r]) ?? 0
        }

        let weeks   = value(at: 1)
        let days    = value(at: 2)
        let hours   = value(at: 3)
        let minutes = value(at: 4)
        let seconds = value(at: 5)

        return weeks   * 604_800 +
               days    * 86_400  +
               hours   * 3_600   +
               minutes * 60      +
               seconds
    }
} 

//
//  Cubase TrackArchive BasicMarkers.swift
//  DAWFileKit • https://github.com/orchetect/DAWFileKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) // XMLNode only works on macOS

import XCTest
@testable import DAWFileKit
import OTCore
import TimecodeKit

class Cubase_TrackArchive_BasicMarkers: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testBasicMarkers() throws {
        // load file
        
        let filename = "BasicMarkers"
        guard let rawData = loadFileContents(
            forResource: filename,
            withExtension: "xml",
            subFolder: .cubaseTrackArchiveXML
        )
        else { XCTFail("Could not form URL, possibly could not find file."); return }
        
        // parse
        
        var parseMessages: [Cubase.TrackArchive.ParseMessage] = []
        let trackArchive = try Cubase.TrackArchive(data: rawData, messages: &parseMessages)
        
        // parse messages
        
        XCTAssertEqual(parseMessages.errors.count, 0)
        if !parseMessages.errors.isEmpty {
            dump(parseMessages.errors)
        }
        
        // ---- main ----
        
        // frame rate
        XCTAssertEqual(trackArchive.main.frameRate, ._23_976)
        
        // start timecode
        XCTAssertEqual(
            trackArchive.main.startTimecode?.components,
            TCC(d: 0, h: 00, m: 59, s: 59, f: 10, sf: 19)
        )
        
        // length timecode
        XCTAssertEqual(
            trackArchive.main.lengthTimecode?.components,
            TCC(d: 0, h: 00, m: 05, s: 00, f: 00, sf: 00)
        )
        
        // TimeType - not implemented yet
        
        // bar offset
        XCTAssertEqual(trackArchive.main.barOffset, 0)
        
        // sample rate
        XCTAssertEqual(trackArchive.main.sampleRate, 48000.0)
        
        // bit depth
        XCTAssertEqual(trackArchive.main.bitDepth, 24)
        
        // SampleFormatSize - not implemented yet
        
        // RecordFile - not implemented yet
        
        // RecordFileType ... - not implemented yet
        
        // PanLaw - not implemented yet
        
        // VolumeMax - not implemented yet
        
        // HmtType - not implemented yet
        
        // HMTDepth
        XCTAssertEqual(trackArchive.main.hmtDepth, 100)
        
        // ---- tempo track ----
        
        XCTAssertEqual(trackArchive.tempoTrack.events.count, 3)
        
        XCTAssertEqual(trackArchive.tempoTrack.events[safe: 0]?.tempo, 115.0)
        XCTAssertEqual(trackArchive.tempoTrack.events[safe: 0]?.type, .jump)
        
        XCTAssertEqual(trackArchive.tempoTrack.events[safe: 1]?.tempo, 120.0)
        XCTAssertEqual(trackArchive.tempoTrack.events[safe: 1]?.type, .jump)
        
        XCTAssertEqual(trackArchive.tempoTrack.events[safe: 2]?.tempo, 155.74200439453125)
        XCTAssertEqual(trackArchive.tempoTrack.events[safe: 2]?.type, .jump)
        
        // ---- tracks ----
        
        XCTAssertEqual(trackArchive.tracks?.count, 3)
        
        // track 1 - musical mode
        
        let track1 = trackArchive.tracks?[0] as? Cubase.TrackArchive.MarkerTrack
        XCTAssertNotNil(track1)
        
        XCTAssertEqual(track1?.name, "Cues")
        
        let track1event1 = track1?.events[safe: 0] as? Cubase.TrackArchive.CycleMarker
        XCTAssertNotNil(track1event1)
        
        XCTAssertEqual(track1event1?.name, "Cycle Marker Name 1")
        
        XCTAssertEqual(
            track1event1?.startTimecode.components,
            TCC(d: 0, h: 01, m: 00, s: 01, f: 12, sf: 22)
        )
        // Cubase project displays 00:00:02:02.03 as the cycle marker length
        // but our calculations get 00:00:02:02.02
        XCTAssertEqual(
            track1event1?.lengthTimecode.components,
            TCC(d: 0, h: 00, m: 00, s: 02, f: 02, sf: 02)
        )
        
        // track 2 - musical mode
        
        let track2 = trackArchive.tracks?[1] as? Cubase.TrackArchive.MarkerTrack
        XCTAssertNotNil(track2)
        
        XCTAssertEqual(track2?.name, "Stems")
        
        let track2event1 = track2?.events[safe: 0] as? Cubase.TrackArchive.CycleMarker
        XCTAssertNotNil(track2event1)
        
        XCTAssertEqual(track2event1?.name, "Cycle Marker Name 2")
        
        XCTAssertEqual(
            track2event1?.startTimecode.components,
            TCC(d: 0, h: 01, m: 00, s: 03, f: 14, sf: 25)
        )
        // Cubase project displays 00:00:02:02.03 as the cycle marker length
        // but our calculations get 00:00:02:02.02
        XCTAssertEqual(
            track2event1?.lengthTimecode.components,
            TCC(d: 0, h: 00, m: 00, s: 02, f: 02, sf: 02)
        )
        
        // track 3 - linear mode (absolute time)
        
        let track3 = trackArchive.tracks?[2] as? Cubase.TrackArchive.MarkerTrack
        XCTAssertNotNil(track3)
        
        XCTAssertEqual(track3?.name, "TC Markers")
        
        let track3event1 = track3?.events[safe: 0] as? Cubase.TrackArchive.Marker
        XCTAssertNotNil(track3event1)
        
        XCTAssertEqual(track3event1?.name, "Marker at One Hour")
        XCTAssertEqual(
            track3event1?.startTimecode.components,
            TCC(d: 0, h: 01, m: 00, s: 00, f: 00, sf: 00)
        )
    }
}

#endif

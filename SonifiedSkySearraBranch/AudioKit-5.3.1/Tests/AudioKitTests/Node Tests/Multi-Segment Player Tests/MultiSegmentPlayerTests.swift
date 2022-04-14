import AudioKit
import AVFoundation
import XCTest

class MultiSegmentPlayerTests: XCTestCase {
    func testPlaySegment() {
        guard let url = Bundle.module.url(forResource: "TestResources/12345", withExtension: "wav"),
              let file = try? AVAudioFile(forReading: url)
        else {
            XCTFail("Didn't get test file")
            return
        }
        
        let engine = AudioEngine()
        let player = MultiSegmentAudioPlayer()
        let segment = ExampleSegment(audioFile: file)
        engine.output = player
        
        let audio = engine.startTest(totalDuration: 5.0)
        
        player.playSegments(audioSegments: [segment])
        
        player.play()
        audio.append(engine.render(duration: 5.0))
        
        testMD5(audio)
    }
    
    func testPlaySegmentInTheFuture() {
        guard let url = Bundle.module.url(forResource: "TestResources/12345", withExtension: "wav"),
              let file = try? AVAudioFile(forReading: url)
        else {
            XCTFail("Didn't get test file")
            return
        }
        
        let engine = AudioEngine()
        let player = MultiSegmentAudioPlayer()
        let segment = ExampleSegment(audioFile: file, playbackStartTime: 1.0)
        engine.output = player
        
        let audio = engine.startTest(totalDuration: 5.0)
        
        player.playSegments(audioSegments: [segment])
        
        player.play()
        audio.append(engine.render(duration: 5.0))
        
        testMD5(audio)
    }
    
    func testPlayMultipleSegments() {
        guard let url = Bundle.module.url(forResource: "TestResources/12345", withExtension: "wav"),
              let file = try? AVAudioFile(forReading: url)
        else {
            XCTFail("Didn't get test file")
            return
        }
        
        let engine = AudioEngine()
        let player = MultiSegmentAudioPlayer()
        let segmentA = ExampleSegment(audioFile: file)
        let segmentB = ExampleSegment(audioFile: file, fileStartTime: 1.0)
        let segmentC = ExampleSegment(audioFile: file, playbackStartTime: 1.0)
        let segmentD = ExampleSegment(audioFile: file, playbackStartTime: 1.0, fileStartTime: 1.0)
        engine.output = player
        
        let audio = engine.startTest(totalDuration: 5.0)
        
        player.playSegments(audioSegments: [segmentA, segmentB, segmentC, segmentD])
        
        player.play()
        audio.append(engine.render(duration: 5.0))
        
        testMD5(audio)
    }
    
    func testPlayWithinSegment() {
        guard let url = Bundle.module.url(forResource: "TestResources/12345", withExtension: "wav"),
              let file = try? AVAudioFile(forReading: url)
        else {
            XCTFail("Didn't get test file")
            return
        }
        
        let engine = AudioEngine()
        let player = MultiSegmentAudioPlayer()
        let segment = ExampleSegment(audioFile: file)
        engine.output = player
        
        let audio = engine.startTest(totalDuration: 5.0)
        
        player.playSegments(audioSegments: [segment], referenceTimeStamp: 1.0)
        
        player.play()
        audio.append(engine.render(duration: 5.0))
        
        testMD5(audio)
    }
}

/// NOT INTENDED FOR PRODUCTION - Test Class Adopting StreamableAudioSegment for MultiSegmentPlayerTests
private class ExampleSegment: StreamableAudioSegment {
    var audioFile: AVAudioFile
    var playbackStartTime: TimeInterval = 0
    var fileStartTime: TimeInterval = 0
    var fileEndTime: TimeInterval
    var completionHandler: AVAudioNodeCompletionHandler?
    
    /// Segment starts at the beginning of file at zero reference time
    init(audioFile: AVAudioFile) {
        self.audioFile = audioFile
        self.fileEndTime = audioFile.duration
    }
    
    /// Segment starts some time into the file (past the starting location) at zero reference time
    init(audioFile: AVAudioFile, fileStartTime: TimeInterval) {
        self.audioFile = audioFile
        self.fileStartTime = fileStartTime
        self.fileEndTime = audioFile.duration
    }
    
    /// Segment starts at the beginning of file with an offset on the playback time (plays in future when reference time is 0)
    init(audioFile: AVAudioFile, playbackStartTime: TimeInterval) {
        self.audioFile = audioFile
        self.playbackStartTime = playbackStartTime
        self.fileEndTime = audioFile.duration
    }
    
    /// Segment starts some time into the file with an offset on the playback time (plays in future when reference time is 0)
    init(audioFile: AVAudioFile, playbackStartTime: TimeInterval, fileStartTime: TimeInterval) {
        self.audioFile = audioFile
        self.playbackStartTime = playbackStartTime
        self.fileStartTime = fileStartTime
        self.fileEndTime = audioFile.duration
    }
}

//
//  Project39Tests.swift
//  Project39Tests
//
//  Created by Tanner Quesenberry on 2/20/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import XCTest
@testable import Project39

class Project39Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAllWordsLoaded() {
        let playData = PlayData()
        XCTAssertEqual(playData.allWords.count, 18440, "allWords must be 18440")
    }

    func testWordCountsAreCorrect() {
        let playData = PlayData()
        XCTAssertEqual(playData.wordCounts["Master"], 225, "Master does not appear 225 times")
        XCTAssertEqual(playData.wordCounts["recover"], 16, "recover does not appear 16 times")
        XCTAssertEqual(playData.wordCounts["tis"], 380, "tis does not appear 380 times")
    }
}

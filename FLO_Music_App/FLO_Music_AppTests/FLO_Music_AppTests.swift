//
//  FLO_Music_AppTests.swift
//  FLO_Music_AppTests
//
//  Created by yoon tae soo on 2020/11/09.
//

import XCTest
@testable import FLO_Music_App

class FLO_Music_AppTests: XCTestCase {

    var apiViewModel : ApiViewModel!
    
    override func setUp() {
        super.setUp()
        apiViewModel = ApiViewModel()
    }
    
    override func tearDown() {
        apiViewModel = nil
        super.tearDown()
    }
    
    //Test For NetWorking
    func test_returnMusicinfo(){
        
        let expectation = self.expectation(description: "성공적으로 일을 마침")
        
        let url : String = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
        
        let inputUrl = apiViewModel.returnURL(url: url)
        
        //Nil 값이 아니라면 패스 - Nil 값이면 오류 발생
        XCTAssertNotNil(inputUrl)
        
        apiViewModel.returnMusicinfo(inputUrl!) { (result) in
            
            switch result {
            
            case .success(let infos):
                XCTAssertNotNil(infos)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.rawValue)
            }
            
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
        
    }
    
    //Test for ReguarExpression
    func test_returnStringByRex(){
        
        guard let result = apiViewModel.returnStringByRex(pattern: "[0-9][0-9]:[0-9][0-9]", word: "[00:16:200]we wish you a merry christmas").first else {
            XCTFail("모든게 비어 있음")
            return
        }
        
        XCTAssertEqual(result, "00:16")
        
    }
    
    //Test For expected Dictionary
    func test_getlyrics(){
     
        let inputData = "[00:16:200]we wish you a merry christmas\n[00:18:300]we wish you a merry christmas"
        
        let expectation = self.expectation(description: "성공적으로 일을 마침")
        
        apiViewModel.getlyrics(lyrics: inputData) { (result) in
            
            if result == [16 : "we wish you a merry christmas" , 18 : "we wish you a merry christmas" ] {
                expectation.fulfill()
            }
            else{
                XCTFail("Not Same")
            }
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
        
    }
    
    //Test For expected Lyrics search Index
    func test_searchLyrics(){
        
        apiViewModel.search = [16, 18 , 21]
        
        let result = apiViewModel.searchLyrics(time: 17)
        
        XCTAssertEqual(result, 16)
        
        
    }

}

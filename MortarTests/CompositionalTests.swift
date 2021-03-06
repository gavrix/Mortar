//
//  CompositionalTests.swift
//  MortarTests
//
//  The MIT License (MIT)
//  
//  Copyright (c) 2017 Dima Bart
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import XCTest
import Mortar

class CompositionalTests: XCTestCase {
    
    // ----------------------------------
    //  MARK: - Async to X -
    //
    func testAsyncToAsyncSuccess() {
        let pipeline = addTwo_s <<- stringify_s
        
        pipeline(2) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, "String: 4")
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToAsyncFailure() {
        let pipeline = addTwo_f <<- stringify_s
        
        pipeline(2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    func testAsyncToSyncSuccess() {
        let pipeline = addTwo_s <<- double_s
        
        pipeline(2) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 8)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToSyncFailure() {
        let pipeline = addTwo_f <<- double_s
        
        pipeline(2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    func testAsyncToSimpleSuccess() {
        let pipeline = addTwo_s <<- triple_s
        
        pipeline(2) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 12)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToSimpleFailure() {
        let pipeline = addTwo_f <<- triple_s
        
        pipeline(2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Sync to X -
    //
    func testSyncToSyncSuccess() {
        let pipeline = double_s <<- double_s
        
        switch pipeline(2) {
        case .success(let value):
            XCTAssertEqual(value, 8)
        case .failure:
            XCTFail()
        }
    }
    
    func testSyncToSyncFailure() {
        let pipeline = double_f <<- double_s
        
        switch pipeline(2) {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, .generic)
        }
    }
    
    func testSyncToAsyncSuccess() {
        let pipeline = double_s <<- addTwo_s
        
        pipeline(2) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 6)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testSyncToAsyncFailure() {
        let pipeline = double_f <<- addTwo_s
        
        pipeline(2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    func testSyncToSimpleSuccess() {
        let pipeline = double_s <<- triple_s
        
        switch pipeline(2) {
        case .success(let value):
            XCTAssertEqual(value, 12)
        case .failure:
            XCTFail()
        }
    }
    
    func testSyncToSimpleFailure() {
        let pipeline = double_f <<- triple_s
        
        switch pipeline(2) {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, .generic)
        }
    }
    
    // ----------------------------------
    //  MARK: - Simple to X -
    //
    func testSimpleToSimple() {
        let pipeline = triple_s <<- triple_s
        
        XCTAssertEqual(pipeline(2), 18)
    }
    
    func testSimpleToSync() {
        let pipeline = triple_s <<- double_s
        
        switch pipeline(2) {
        case .success(let value):
            XCTAssertEqual(value, 12)
        case .failure:
            XCTFail()
        }
    }
    
    func testSimpleToAsync() {
        let pipeline = triple_s <<- addTwo_s
        
        pipeline(2) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 8)
            case .failure:
                XCTFail()
            }
        }
    }
}

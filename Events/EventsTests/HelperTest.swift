//
//  HelperTest.swift
//  EventsTests
//
//  Created by Alexander Supe on 05.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import XCTest
@testable import Events

class HelperTest: XCTestCase {

    //MARK: - 9
    func testLogout() {
        Helper.chain.set(true, forKey: "authenticated")
        Helper.logout()
        sleep(2)
        XCTAssertFalse(Helper.chain.getBool("authenticated") ?? true)
    }
    
    
    //MARK: - 10
    func test() {
        Helper.chain.set("alex", forKey: "username")
        XCTAssertTrue(Helper.username == "alex")
    }
}

//
//  StandupsListTests.swift
//  standupsTests
//
//  Created by Patrick Lown on 3/27/24.
//

import Foundation
import XCTest
import ComposableArchitecture
@testable import standups

@MainActor
final class StandupsListTests: XCTestCase {
    
    func testAddStandup() async {
        let store = TestStore(
            initialState: StandupsListFeature.State()
        ){
            StandupsListFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        var standup = Standup(
          id: UUID(0),
          attendees: [Attendee(id: UUID(1))]
        )
        
        await store.send(.addButtonTapped) {
          $0.addStandup = StandupFormFeature.State(
            standup: standup
          )
        }
        
        standup.title = "Point-Free Morning Sync"
        await store.send(.addStandup(.presented(.set(\.standup, standup)))) {
          $0.addStandup?.standup.title = "Point-Free Morning Sync"
        }
        
        await store.send(.saveStandupButtonTapped) {
            $0.addStandup = nil
            $0.standups[0] = Standup(id: UUID(0),
                                     attendees: [Attendee(id: UUID(1))],
                                     title: "Point-Free Morning Sync")
        }
    }
    
}

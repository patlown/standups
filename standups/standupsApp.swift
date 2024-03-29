//
//  standupsApp.swift
//  standups
//
//  Created by Patrick Lown on 3/24/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct standupsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
//                StandupsList(store: Store(initialState: StandupsListFeature.State(
//                    addStandup: StandupFormFeature.State(focus: .title, standup: .mock)
//                )) {
//                    StandupsListFeature()
//                })
                
                StandupsList(store: Store(initialState: StandupsListFeature.State(

                )) {
                    StandupsListFeature()
                })
            }
        }
    }
}

//
//  StandupsList.swift
//  standups
//
//  Created by Patrick Lown on 3/24/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct StandupsListFeature {
    @ObservableState
    struct State {
        var standups: IdentifiedArrayOf<Standup> = []
    }
    
    enum Action {
        case addButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in 
            switch action {
            case .addButtonTapped:
                state.standups.append(
                    Standup(id: UUID(), theme: .allCases.randomElement()!)
                )
                return .none
            }
        }
    }
}

struct StandupsList: View {
    let store: StoreOf<StandupsListFeature>
    
    var body: some View {
        List {
            ForEach(store.standups) { standup in
                CardView(standup: standup)
                    .listRowBackground(standup.theme.mainColor)
            }
        }
        .navigationTitle("Daily Standups")
        .toolbar {
            ToolbarItem {
                Button("Add") {
                    store.send(.addButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StandupsList(
            store: Store(initialState: StandupsListFeature.State(
                standups: [.mock])) {
                StandupsListFeature()
            }
        )
    }
}

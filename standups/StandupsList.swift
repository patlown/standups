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
    struct State: Equatable {
        @Presents var addStandup: StandupFormFeature.State?
        var standups: IdentifiedArrayOf<Standup> = []
    }
    
    enum Action {
        case addButtonTapped
        case addStandup(PresentationAction<StandupFormFeature.Action>)
        
        case cancelStandupButtonTapped
        case saveStandupButtonTapped
    }
    
    
    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        Reduce { state, action in 
            switch action {
                
            case .cancelStandupButtonTapped:
                state.addStandup = nil
                return .none
                
            case .saveStandupButtonTapped:
                guard let standup = state.addStandup?.standup
                else { return .none }
                state.standups.append(standup)
                state.addStandup = nil
                return .none
                
            case .addStandup:
                return .none
                
            case .addButtonTapped:
                state.addStandup = StandupFormFeature.State(standup: Standup(id: uuid()))
                return .none
            }
        }
        .ifLet(\.$addStandup, action: /Action.addStandup) {
            StandupFormFeature()
        }
    }
}

struct StandupsList: View {
    @Bindable var store: StoreOf<StandupsListFeature>
    
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
        .sheet(item: $store.scope(state: \.addStandup, action: \.addStandup)) { standupFormFeature in
            NavigationStack {
                StandupFormView(store: standupFormFeature)
                    .navigationTitle("New standup")
                    .toolbar {
                        ToolbarItem {
                            Button("Save") {
                                store.send(.saveStandupButtonTapped)
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                store.send(.cancelStandupButtonTapped)
                            }
                        }
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

//
//  StandupDetail.swift
//  standupsTests
//
//  Created by Patrick Lown on 3/28/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct StandupDetailView: View {
  let store: StoreOf<StandupDetailFeature>

  var body: some View {
      List {
        Section {
          NavigationLink {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something@*//*@END_MENU_TOKEN@*/
          } label: {
            Label("Start Meeting", systemImage: "timer")
              .font(.headline)
              .foregroundColor(.accentColor)
          }
          HStack {
            Label("Length", systemImage: "clock")
            Spacer()
            Text(store.standup.duration.formatted(.units()))
          }

          HStack {
            Label("Theme", systemImage: "paintpalette")
            Spacer()
            Text(store.standup.theme.name)
              .padding(4)
              .foregroundColor(store.standup.theme.accentColor)
              .background(store.standup.theme.mainColor)
              .cornerRadius(4)
          }
        } header: {
          Text("Standup Info")
        }

        if !store.standup.meetings.isEmpty {
          Section {
            ForEach(store.standup.meetings) { meeting in
              NavigationLink {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something@*//*@END_MENU_TOKEN@*/
              } label: {
                HStack {
                  Image(systemName: "calendar")
                  Text(meeting.date, style: .date)
                  Text(meeting.date, style: .time)
                }
              }
            }
            .onDelete { indices in
              store.send(.deleteMeetings(atOffsets: indices))
            }
          } header: {
            Text("Past meetings")
          }
        }

        Section {
          ForEach(store.standup.attendees) { attendee in
            Label(attendee.name, systemImage: "person")
          }
        } header: {
          Text("Attendees")
        }

        Section {
          Button("Delete") {
            store.send(.deleteButtonTapped)
          }
          .foregroundColor(.red)
          .frame(maxWidth: .infinity)
        }
      }
      .navigationTitle(store.standup.title)
      .toolbar {
        Button("Edit") {
          store.send(.editButtonTapped)
        }
      }
      .sheet(store: self.store.scope(state: \.$editStandup, action: { .editStandup($0) })) { formStore in
        NavigationStack {
          StandupFormView(store: formStore)
            .navigationTitle("Edit standup")
            .toolbar {
              ToolbarItem {
                  Button("Save") { store.send(.saveStandupButtonTapped) }
              }
              ToolbarItem(placement: .cancellationAction) {
                  Button("Cancel") { store.send(.cancelStandupButtonTapped) }
              }
            }
        }
      }
  }
}


@Reducer
struct StandupDetailFeature {
    
    @ObservableState
    struct State: Equatable {
        var standup: Standup
        @Presents var editStandup: StandupFormFeature.State?
    }
    
    enum Action {
        case deleteButtonTapped
        case deleteMeetings(atOffsets: IndexSet)
        case editButtonTapped
        
        case editStandup(PresentationAction<StandupFormFeature.Action>)
        
        case cancelStandupButtonTapped
        case saveStandupButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .deleteButtonTapped:
                return .none
            case let .deleteMeetings(indices):
                state.standup.meetings.remove(atOffsets: indices)
                return .none
                
            case .editButtonTapped:
                state.editStandup = StandupFormFeature.State(standup: state.standup)
                return .none
                
            case .editStandup:
                return .none
                
            case .cancelStandupButtonTapped:
                state.editStandup = nil
                return .none
                
            case .saveStandupButtonTapped:
                guard let editStandup = state.editStandup
                else { return .none }
                
                state.standup = editStandup.standup
                state.editStandup = nil
                return .none
            }
        }
        .ifLet(\.$editStandup, action: /Action.editStandup) {
            StandupFormFeature()
        }
    }
    
}

#Preview {
  MainActor.assumeIsolated {
    NavigationStack {
      StandupDetailView(
        store: Store(initialState: StandupDetailFeature.State(standup: .mock)) {
          StandupDetailFeature()
        }
      )
    }
  }
}

//
//  StandupForm.swift
//  standups
//
//  Created by Patrick Lown on 3/24/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct StandupFormFeature {
    
    @Dependency(\.uuid) var uuid
    @ObservableState
    struct State: Equatable {
        var focus: Field?
        var standup: Standup
        enum Field: Hashable {
            case attendee(Attendee.ID)
            case title
        }
        
        init(focus: Field? = .title, standup: Standup) {
            self.focus = focus
            self.standup = standup
            if self.standup.attendees.isEmpty {
                self.standup.attendees.append(Attendee(id: UUID()))
            }
        }
    }
    
    enum Action: BindableAction {
        case addAttendeeButtonTapped
        case deleteAttendees(atOffsets: IndexSet)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addAttendeeButtonTapped:
                let id = uuid()
                state.standup.attendees.append(Attendee(id: id))
                state.focus = .attendee(id)
                return .none
                
            case let .deleteAttendees(atOffsets: indices):
                state.standup.attendees.remove(atOffsets: indices)
                if state.standup.attendees.isEmpty {
                    state.standup.attendees.append(Attendee(id: uuid()))
                }
                guard let firstIndex = indices.first
                else { return .none }
                let index = min(firstIndex, state.standup.attendees.count - 1)
                state.focus = .attendee(state.standup.attendees[index].id)
                return .none
                
            case .binding:
                
                return .none
            }
        }
    }
}

extension Duration {
    fileprivate var minutes: Double {
        get { Double(self.components.seconds / 60) }
        set { self = .seconds(newValue * 60)}
    }
}

struct StandupFormView: View {
    @Bindable var store: StoreOf<StandupFormFeature>
    @FocusState var focus: StandupFormFeature.State.Field?
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $store.standup.title)
                    .focused(self.$focus, equals: .title)
                HStack {
                    Slider(value: $store.standup.duration.minutes, in: 5...30, step: 1) {
                        Text("Length")
                    }
                    Spacer()
                    Text(store.standup.duration.formatted(.units()))
                }
                ThemePicker(selection: $store.standup.theme)
            } header: {
                Text("Standup Info")
            }
            
            Section {
                ForEach($store.standup.attendees) { $attendee in
                    TextField("name", text: $attendee.name)
                        .focused(self.$focus, equals: .attendee(attendee.id))
                }
                .onDelete { indices in
                    store.send(.deleteAttendees(atOffsets: indices))
                }
                Button("Add attendee") {
                    store.send(.addAttendeeButtonTapped)
                }
            } header: {
                Text("Attendees")
            }
        }
        .bind($store.focus, to: self.$focus)
    }
}

struct ThemePicker: View {
  @Binding var selection: Theme

  var body: some View {
    Picker("Theme", selection: self.$selection) {
      ForEach(Theme.allCases) { theme in
        ZStack {
          RoundedRectangle(cornerRadius: 4)
            .fill(theme.mainColor)
          Label(theme.name, systemImage: "paintpalette")
            .padding(4)
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal: false, vertical: true)
        .tag(theme)
      }
    }
  }
}


#Preview {
    NavigationStack {
        StandupFormView(store: Store(initialState: StandupFormFeature.State(standup: .mock)) {
            StandupFormFeature()
        })
    }
}

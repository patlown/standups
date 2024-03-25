//
//  Models.swift
//  standups
//
//  Created by Patrick Lown on 3/24/24.
//

import Foundation
import SwiftUI

struct Standup: Equatable, Identifiable, Codable {
    // TODO: type specific identifiers, Modern SwiftUI
    let id: UUID
    var attendees: [Attendee] = []
    var duration = Duration.seconds(60 * 5)
    var meetings: [Meeting] = []
    var theme: Theme = .bubblegum
    var title = ""
    
    var durationPerAttendee: Duration {
        self.duration / self.attendees.count
    }
}

struct Attendee: Equatable, Identifiable, Codable {
    let id: UUID
    var name = ""
}

struct Meeting: Equatable, Identifiable, Codable {
    let id: UUID
    let date: Date
    var transcript: String
}

enum Theme: String, CaseIterable, Equatable, Hashable, Identifiable, Codable {
    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case poppy
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
    
    var id: Self { self }
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan,
                .teal, .yellow:
            return .black
        case .indigo, .magenta, .navy, .oxblood, .purple:
            return .white
        }
    }
    
    var mainColor: Color { Color(self.rawValue) }
    
    var name: String { self.rawValue.capitalized }
}


extension Standup {
    
    static let sampleData: [Standup] =
    [
        Standup(id: UUID(),
                attendees: [Attendee(id: UUID(), name: "Cathy"), Attendee(id: UUID(), name: "Daisy")],
                duration: Duration.seconds(900),
                theme: .bubblegum,
                title: "Design"),
        Standup(id: UUID(),
                attendees: [Attendee(id: UUID(), name: "Cathy"), Attendee(id: UUID(), name: "Daisy")],
                duration: Duration.seconds(950),
                theme: .orange,
                title: "App Dev"),
        Standup(id: UUID(),
                attendees: [Attendee(id: UUID(), name: "Cathy"), Attendee(id: UUID(), name: "Daisy")],
                duration: Duration.seconds(750),
                theme: .poppy,
                title: "Web Dev")
    ]
}

extension Standup {
  static let mock = Self(
    id: Standup.ID(),
    attendees: [
      Attendee(id: Attendee.ID(), name: "Blob"),
      Attendee(id: Attendee.ID(), name: "Blob Jr"),
      Attendee(id: Attendee.ID(), name: "Blob Sr"),
      Attendee(id: Attendee.ID(), name: "Blob Esq"),
      Attendee(id: Attendee.ID(), name: "Blob III"),
      Attendee(id: Attendee.ID(), name: "Blob I"),
    ],
    duration: .seconds(60),
    meetings: [
      Meeting(
        id: Meeting.ID(),
        date: Date().addingTimeInterval(-60 * 60 * 24 * 7),
        transcript: """
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor \
          incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud \
          exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure \
          dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. \
          Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt \
          mollit anim id est laborum.
          """
      )
    ],
    theme: .orange,
    title: "Design"
  )
}

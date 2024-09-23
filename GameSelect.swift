//
//  GameSelect.swift
//  StatVision
//
//  Created by Noah Torres on 1/9/24.
//

import SwiftUI

class GameInfo: ObservableObject {
    @Published var gameName: String = ""
    
    static let shared = GameInfo() // Singleton instance
    
    public init() {}
}

struct GameSelect: View {
    @EnvironmentObject var sm: sm
    @State private var selectedTeamIndex = 0
    @State private var isAlertPresented = false
    @State private var gameName: String = ""
    @State private var selectedPlayerIndex: Int?

    var body: some View {
            VStack {
                TextField("Enter Game Name", text: $gameName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)

                Picker(selection: $selectedTeamIndex, label: Text("Select Team")) {
                    ForEach(0..<$sm.teams.count, id: \.self) { index in
                        Text(sm.teams[index].teamName).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .padding(.horizontal, 20)

                Button("Start Tracking") {
                    isAlertPresented = true
                    
                    guard !gameName.isEmpty else {
                        // Handle if game name is not entered
                        return
                    }
                    
                    guard !sm.teams.isEmpty else {
                        // Handle if teams is empty
                        return
                    }

                }
            .alert(isPresented: $isAlertPresented, content: {
                Alert(
                    title: Text("Game Info"),
                    message: Text("Game Name: \(gameName)\nSelected Team: \(sm.teams[selectedTeamIndex].teamName)"),
                    primaryButton: .default(
                        Text("OK"),
                        action: {
                            guard !gameName.isEmpty else {
                                // Handle if game name is not entered
                                return
                            }
                            
                            guard !sm.teams.isEmpty else {
                                // Handle if teams is empty
                                return
                            }

                            // Set the selected team and player in sm
                            sm.selectedTeam = sm.teams[selectedTeamIndex]
                            if let selectedPlayerIndex = selectedPlayerIndex {
                                sm.selectedPlayer = sm.teams[selectedTeamIndex].players[selectedPlayerIndex]
                            }

                            // Save the game name, selected team, and selected player
                            print("Game Name: \(gameName)")
                            print("Selected Team: \(sm.teams[selectedTeamIndex].teamName)")
                        }
                    ),
                    secondaryButton: .cancel()
                )
            })
        }
        .padding()
    }
}





struct GameSelect_Previews: PreviewProvider {
    static var previews: some View {
        @EnvironmentObject var stats: sm
        let teamManager = sm()
        teamManager.addTeam(team: Team(teamName: "Team 1"))
        teamManager.addTeam(team: Team(teamName: "Team 2"))
        teamManager.addTeam(team: Team(teamName: "Team 3"))

        return GameSelect(sm: _stats)
            .environmentObject(GameInfo())
            .environmentObject(sm())
    }
}


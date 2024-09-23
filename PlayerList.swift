//
//  PlayerList.swift
//  StatVision
//
//  Created by Noah Torres on 2/13/24.
//

import SwiftUI

struct PlayerView: View {
    @ObservedObject var team: Team

    var body: some View {
            VStack {
    
                List(team.players) { player in
                    Text("\(player.firstName) \(player.lastName)")
                        .padding()
                }
            }
            .padding()
        }
}

struct PlayerRow: View {
    var player: Player

    var body: some View {
        HStack {
            Text("Jersey Number: \(player.jerseyNumber)")
            Spacer()
            Text("Name: \(player.firstName) \(player.lastName)")
        }
        .padding()
    }
}

struct MainView: View {
    @ObservedObject var statManager = sm()

    var body: some View {
        NavigationView {
            List(statManager.teams) { team in
                NavigationLink(destination: PlayerView(team: team)) {
                    Text(team.teamName)
                }
            }
            .navigationBarTitle("Teams")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let teamManager = sm()

        let team1 = Team(teamName: "Team A")
        team1.addPlayer(player: Player(jerseyNumber: "23", firstName: "John", lastName: "Doe", position: "Guard"))

        let team2 = Team(teamName: "Team B")
        team2.addPlayer(player: Player(jerseyNumber: "15", firstName: "Jane", lastName: "Smith", position: "Forward"))

        teamManager.addTeam(team: team1)
        teamManager.addTeam(team: team2)

        return MainView(statManager: teamManager)
    }
}




//
//  TeamPage.swift
//  StatVision
//
//  Created by Noah Torres on 10/29/23.
//

import SwiftUI
import Combine
import Foundation

class Player: Identifiable, ObservableObject {
    var id = UUID()
    var jerseyNumber: String
    var firstName: String
    var lastName: String
    var position: String
    var stats: [String: Int]
    var player2PM: Int

    init(jerseyNumber: String, firstName: String, lastName: String, position: String) {
        self.jerseyNumber = jerseyNumber
        self.firstName = firstName
        self.lastName = lastName
        self.position = position
        self.stats = [:]
        self.player2PM = 0
    }
}

class Team: Identifiable, ObservableObject {
    var id = UUID()
    @Published var teamName: String
    @Published var players: [Player] = []
    @Published var isSelected: Bool = false

    init(teamName: String) {
        self.teamName = teamName
    }

    func addPlayer(player: Player) {
        players.append(player)
    }
}

class StatsViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var userInput: String = ""
    private var cancellable: AnyCancellable?

    func sendMessage(_ message: String) {
        let userMessage = ChatMessage(text: message, isUser: true)
        messages.append(userMessage)
        
        fetchResponse(for: message)
        
        let message = ""
    }

        func fetchResponse(for query: String) {
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://noah51022.pythonanywhere.com/get_stats?query=\(encodedQuery)") else {
                let errorMessage = ChatMessage(text: "Invalid URL", isUser: false)
                messages.append(errorMessage)
                print(errorMessage)
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle any error
                if let error = error {
                    let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
                    self.messages.append(errorMessage)
                    print(errorMessage)
                    return
                }

                // Ensure response status code is successful
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    let errorMessage = ChatMessage(text: "Invalid response from server", isUser: false)
                    self.messages.append(errorMessage)
                    print(errorMessage)
                    return
                }

                // Ensure data is not nil
                guard let responseData = data else {
                    let errorMessage = ChatMessage(text: "No data received from server", isUser: false)
                    self.messages.append(errorMessage)
                    print(errorMessage)
                    return
                }

                // Handle the response data
                do {
                    let decoder = JSONDecoder()
                    let apiResponse = try decoder.decode(ResponseModel.self, from: responseData)
                    let responseMessage = ChatMessage(text: apiResponse.result, isUser: false)
                    self.messages.append(responseMessage)
                } catch {
                    let errorMessage = ChatMessage(text: "Error decoding JSON: \(error.localizedDescription)", isUser: false)
                    self.messages.append(errorMessage)
                    print(errorMessage)
                }
            }

            // Start the data task
            task.resume()
        }

    }

struct TeamView: View {
    @EnvironmentObject private var statEntryViewManager: sm
    @EnvironmentObject private var team: Team
    @State private var newTeamName = ""
    @State private var selectedTeam: Team? = nil
    @State private var isStatPagePresented = false
    @State private var isChatPagePresented = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Create Team")) {
                        TextField("Enter Team Name", text: $newTeamName)
                        Button(action: {
                            guard !newTeamName.isEmpty else { return }
                            let newTeam = Team(teamName: newTeamName)
                            statEntryViewManager.addTeam(team: newTeam)
                            newTeamName = ""
                        }) {
                            Text("Create Team")
                        }
                    }

                    Section(header: Text("Your Teams")) {
                        List {
                            ForEach(statEntryViewManager.teams) { team in
                                NavigationLink(destination: TeamDetailView(team: team, selectedTeam: $selectedTeam)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(team.teamName)
                                        }
                                    }
                                }
                            }
                            .onDelete { indices in
                                // Delete teams when swiped
                                statEntryViewManager.teams.remove(atOffsets: indices)
                                selectedTeam = nil
                            }
                        }
                    }

                }
                .navigationBarTitle("Manage Teams")
        // Navigate to Stat Page
            Button(action: {
                isStatPagePresented = true
            }) {
                    Text("Go to Stat View")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
            }
            .fullScreenCover(isPresented: $isStatPagePresented) {
                ContentView()
                    .environmentObject(statEntryViewManager)
                }
        // Navigate to Chat Page
            Button(action: {
                isChatPagePresented = true
            }) {
                    Text("Chat")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
            }
            .fullScreenCover(isPresented: $isChatPagePresented) {
                ChatBotView()
                    .environmentObject(statEntryViewManager)
                }
            }
            .environmentObject(statEntryViewManager)
        }
    }
}

struct TeamDetailView: View {
    @State var team: Team
    @Binding var selectedTeam: Team?
    @State private var jerseyNumber = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var position = ""

    var body: some View {
        VStack {
            List {
                Section(header: Text("Players")) {
                    ForEach(team.players) { player in
                        Text("\(player.firstName) \(player.lastName) - \(player.position) - #\(player.jerseyNumber)")
                    }.onDelete { indices in
                        team.players.remove(atOffsets: indices)
                    }
                }
            }

            Form {
                Section(header: Text("Add Player")) {
                    TextField("Jersey Number", text: $jerseyNumber)
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Position", text: $position)

                    Button(action: {
                        guard !jerseyNumber.isEmpty, !team.players.contains(where: { $0.jerseyNumber == jerseyNumber }) else {
                            return
                        }
                        
                        let newPlayer = Player(jerseyNumber: jerseyNumber, firstName: firstName, lastName: lastName, position: position)
                        team.addPlayer(player: newPlayer)

                        // Clear input fields
                        jerseyNumber = ""
                        firstName = ""
                        lastName = ""
                        position = ""
                    }) {
                        Text("Add Player")
                    }
                }
            }
            .navigationBarTitle(team.teamName)
        }
        .environmentObject(sm())
    }
}

// Response Model
struct ResponseModel: Codable {
    let result: String
}

struct ChatMessage: Identifiable, Decodable {
    var id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatBotView: View {
    @EnvironmentObject var statView: sm
    @StateObject var viewModel = StatsViewModel()
    @State private var userInput = ""
    @State private var chatHistory: [ChatMessage] = []
    @State private var isTeamViewPresented = false
    @State private var isStatPagePresented = false
    @State private var apiResponse: String = ""
    
    
    var body: some View {
        // Navigation buttons to the other views
        VStack {
            Button(action: {
                isTeamViewPresented = true
            }) {
                Text("Go to Team View")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .fullScreenCover(isPresented: $isTeamViewPresented) {
                TeamView()
                    .environmentObject(sm())
            }
            Button(action: {
                isStatPagePresented = true
            }) {
                Text("Go to Stat View")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .fullScreenCover(isPresented: $isStatPagePresented) {
                ContentView()
            }
            Spacer()
            
            // Chat History
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.messages) { message in
                        ChatMessageView(message: message)
                    }
                }
                .padding()
            }
            // User Input
            HStack {
                TextField("Type your message...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: {
                        viewModel.sendMessage(userInput)
                }) {
                    Text("Send")
                }
                .padding()
                .foregroundColor(.white)
                .background(.blue)
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("ChatBot")
        .background(Color.purple)
        .environmentObject(statView)
    }
    
    
}
    
struct ChatMessageView: View {
    @EnvironmentObject var statView: sm
    var message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                Text(message.text)
                    .padding(10)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                Spacer()
            }
        }
    }
}

    
struct ChatBotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView()
            .environmentObject(sm())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
            .environmentObject(sm())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

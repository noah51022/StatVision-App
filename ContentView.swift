//
//  ContentView.swift
//  StatVision
//
//  Created by Noah Torres on 8/2/23.
//

import SwiftUI
import Firebase

var currentUserUID: String?


// class that lets stats be added to player object
class sm: ObservableObject {
    @Published var teams: [Team] = []

    func addTeam(team: Team) {
        teams.append(team)
    }
    
    @Published var selectedTeam: Team? {
        didSet {
            if let selectedTeam = selectedTeam {
                loadPlayers(for: selectedTeam)
            }
        }
    }
        
    @Published var selectedPlayer: Player?
    @Published var selectedTeamPlayers: [Player] = []
    @Published var teamScoreObject = 0
    @Published var OpponentScoreObject = 0
    @Published var twoPointersMade = 0
    @Published var threePointersMade = 0
    @Published var assistsObject = 0
    @Published var opponent3pointerMadeObject = 0
    @Published var opponent2pointerMadeObject = 0
    @Published var opponent3pointerAttemptedObject = 0
    @Published var opponent2pointerAttemptedObject = 0
    @Published var oppDefensiveReboundsObject = 0
    @Published var oppOffensiveReboundsObject = 0
    @Published var defensiveReboundsObject = 0
    @Published var offensiveReboundsObject = 0
    @Published var turnoversObject = 0
    @Published var chargesObject = 0
    @Published var personalFoulsObject = 0
    @Published var twoPointersAttemptedObject = 0
    @Published var threePointersAttemptedObject = 0
    @Published var freeThrowsAttemptedObject = 0
    @Published var freeThrowsMadeObject = 0
    @Published var OpponentfreeThrowsAttemptedObject = 0
    @Published var OpponentfreeThrowsMadeObject = 0
    @Published var stealsObject = 0
    @Published var blocksObject = 0
    
    
    func addStats(twoPoints: Int, threePoints: Int, defRebounds: Int, offRebounds: Int, assists: Int, twoPointerAttempt: Int, threePointerAttempt: Int, freeThrows: Int, freeThrowsAttempt: Int, steals: Int, blocks: Int, fouls: Int, turnovers: Int) {
        guard selectedPlayer != nil else {
            // Handle the case where no player is selected
            return
        }
    }
    
    func loadPlayers(for team: Team) {
        selectedTeamPlayers = team.players
    }
    
    func record2PointerMade(points2: Int, teamScoreObject: Int) {
        self.teamScoreObject += 2
        twoPointersMade += 1
        recordAction("2-Pointer Made")
        // Adding 2PM directly to player instance TEST
        if let selectedPlayer = selectedPlayer {
                selectedPlayer.player2PM += 1
                print("Player 2PM: ", selectedPlayer.player2PM)
            } else {
                print("No player selected.")
            }
       }
    
    func record2PointerAttempted(twoPointersAttempted: Int) {
        addStats(twoPoints: 0, threePoints: 0, defRebounds: 0, offRebounds: 0, assists: 0, twoPointerAttempt: 1, threePointerAttempt: 0, freeThrows: 0, freeThrowsAttempt: 0, steals: 0, blocks: 0, fouls: 0, turnovers: 0)
        twoPointersAttemptedObject += 1
        recordAction("2PA")
    }
    
    func record3PointerMade(points3: Int, teamScore: Int) {
        // Assuming you have an addStats function in your view model
        addStats(twoPoints: 0, threePoints: 1, defRebounds: 0, offRebounds: 0, assists: 0, twoPointerAttempt: 0, threePointerAttempt: 0, freeThrows: 0, freeThrowsAttempt: 0, steals: 0, blocks: 0, fouls: 0, turnovers: 0)
        self.teamScoreObject += 3
        threePointersMade += 1
        recordAction("3-Pointer Made")
    }
    
    func record3PointerAttempted(threePointersAttempted: Int) {
        self.threePointersAttemptedObject += 1
        recordAction("3PA")
    }
    
    func recordFreeThrowmade(freeThrowMade: Int) {
        self.freeThrowsMadeObject += 1
        teamScoreObject += 1
        recordAction("FT")
    }
    
    func recordFreeThrowAttempt(freeThrowAtt: Int) {
        self.freeThrowsAttemptedObject += 1
        recordAction("FTA")
    }
    
    func recordAssist(assists: Int) {
        self.assistsObject += 1
        recordAction("Assist")
    }
    
    func recordOffensiveRebound(offensiveRebounds: Int) {
        self.offensiveReboundsObject += 1
        recordAction("Off. Rebound")
    }
    
    func recordDefensiveRebound(defensiveRebounds: Int) {
        self.defensiveReboundsObject += 1
        recordAction("Def. Rebound")
    }
    
    func recordSteal(steals: Int) {
        self.stealsObject += 1
        recordAction("Steal")
    }
    
    func recordTurnover(turnovers: Int) {
        self.turnoversObject += 1
        recordAction("Turnover")
    }
    
    func recordCharge(chargesDrawn: Int) {
        self.chargesObject += 1
        recordAction("Charge")
    }
    
    func recordPersonalFoul(personalFouls: Int) {
        self.personalFoulsObject += 1
        recordAction("Per. Foul")
    }
    
    func recordOpponent2PointerMade(opponent2pointerMade: Int, opponentScore: Int) {
        self.OpponentScoreObject += 2
        self.opponent2pointerMadeObject += 1
           recordAction("Opp. 2PM")
       }
    
    func recordOpponent2PointerAttempted(opponent2pointerAttemped: Int) {
        self.opponent2pointerAttemptedObject += 1
           recordAction("Opp. 2PA")
       }
    
    func recordOpponent3PointerMade(opponent3pointerMade: Int, opponentScore: Int) {
        self.opponent3pointerMadeObject += 1
        self.OpponentScoreObject += 3
           recordAction("Opp. 3PM")
       }
    
    func recordOpponent3PointerAttempted(opponent3pointerAttemped: Int) {
        self.opponent3pointerAttemptedObject += 1
           recordAction("Opp. 3PA")
       }
    
    func recordOpponentDefReb(oppDefReb: Int) {
        oppDefensiveReboundsObject += 1
        recordAction("Opp. Def Reb")
    }
    
    func recordOpponentOffReb(oppOffReb: Int) {
        oppOffensiveReboundsObject += 1
        recordAction("Opp. Off Reb")
    }
    
}

var actionHistory: [String] = []



struct ContentView: View {
    @EnvironmentObject var sm: sm
    @EnvironmentObject var gameInfo: GameInfo
    @State private var isGameSelectPresented = false
    @State private var isTeamViewPresented = false
    @State private var isChatPresented = false
    @State private var isPlayerListPresented = false
    private var ref: DatabaseReference? = Database.database().reference()
    private var points: Double = 0.0
    private var pointsPerGame: Double = 0.0
    

 
    
    private var calculatePointsPerGame: Double {
        points / Double(totalGamesPlayed)
    }
    
    private var totalGamesPlayed: Int = 0 {
        didSet {
            pointsPerGame = calculatePointsPerGame
        }
    }
    
    init() {
        
   }
    
    var body: some View {
        let fakeTeam = Team(teamName: "faketeam")
        
        VStack {
            // Team Scores UI
            
            HStack {
                Text("Team Score: \(sm.teamScoreObject)")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(40.0)
                Text("Opponent Score: \(sm.OpponentScoreObject)")
                    .font(.title)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(40.0)
                Spacer()
                Button(action: {
                    isTeamViewPresented = true
                }) {
                        Text("Go to Teams View")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isTeamViewPresented) {
                    TeamView()
                }
                Button(action: {
                    isChatPresented = true
                }) {
                        Text("Chat")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isChatPresented) {
                    ChatBotView()
                }

                Button("Select Game") {
                    isGameSelectPresented = true
                }
                .popover(isPresented: $isGameSelectPresented, arrowEdge: .top) {
                    GameSelect(sm: _sm)
                }
            }
            
            
            Spacer()
            // UI Display variables for stats
            HStack {
                VStack {
                    Text("2-Pointers Made: \(sm.twoPointersMade)")
                    Text("2-Pointers Attempted: \(sm.twoPointersAttemptedObject)")
                    Text("3-Pointers Made: \(sm.threePointersMade)")
                    Text("3-Pointers Attempted: \(sm.threePointersAttemptedObject)")
                    Text("Free Throw: \(sm.freeThrowsMadeObject)")
                    Text("Free Throw Attempt: \(sm.freeThrowsAttemptedObject)")
                    Text("Assists: \(sm.assistsObject)")
                    Text("Off. Reb: \(sm.offensiveReboundsObject)")
                    Text("Def. Reb: \(sm.defensiveReboundsObject)")
                    Text("Steals: \(sm.stealsObject)")
                    Text("Turnovers: \(sm.turnoversObject)")
                    Text("Drawn Charges: \(sm.chargesObject)")
                    Text("Personal Fouls: \(sm.personalFoulsObject)")
                }
                VStack {
                    Text("Opponent 2PM: \(sm.opponent2pointerMadeObject)")
                    Text("Opponent 3PA: \(sm.opponent3pointerAttemptedObject)")
                    Text("Opponent 3PM: \(sm.opponent3pointerMadeObject)")
                    Text("Opp Def Reb: \(sm.oppDefensiveReboundsObject)")
                    Text("Opp Off Reb: \(sm.oppOffensiveReboundsObject)")
                }
                
                VStack {
                    if let team = sm.selectedTeam {
                        // Use onAppear to load players when the view appears
                        List(sm.selectedTeamPlayers) { player in
                            Text("Loaded Player: \(player.firstName) \(player.lastName)")
                            // You can add other views or customizations for each player
                        }
                        .onAppear {
                            sm.loadPlayers(for: team)
                        }
                    } else {
                        Text("No team selected.")
                    }
                }

            }
            Spacer()
            
            
            // Stat Buttons
            VStack {
                HStack {
                    Button(action: {
                        sm.record2PointerMade(points2: sm.twoPointersMade, teamScoreObject: sm.teamScoreObject)
                    }) {
                        Text("2PM")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    Button(action: {
                        sm.record2PointerAttempted(twoPointersAttempted: sm.twoPointersAttemptedObject)
                    }) {
                        Text("2PA")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }

                    Button(action: {
                        sm.record3PointerMade(points3: sm.threePointersMade, teamScore: sm.teamScoreObject)
                    }) {
                        Text("3PM")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.record3PointerAttempted(threePointersAttempted: sm.threePointersAttemptedObject)
                    }) {
                        Text("3PA")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.recordFreeThrowmade(freeThrowMade: sm.freeThrowsMadeObject)
                    }) {
                        Text("FTM")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.recordFreeThrowAttempt(freeThrowAtt: sm.freeThrowsAttemptedObject)
                    }) {
                        Text("FTA")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }

                    Button(action: {
                        sm.recordAssist(assists: sm.assistsObject)
                    }) {
                        Text("Assist")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }

                    Button(action: {
                        sm.recordOffensiveRebound(offensiveRebounds: sm.offensiveReboundsObject)
                    }) {
                        Text("Off Reb")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.recordDefensiveRebound(defensiveRebounds: sm.defensiveReboundsObject)
                    }) {
                        Text("Def Reb")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.recordSteal(steals: sm.stealsObject)
                    }) {
                        Text("Steal")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.recordTurnover(turnovers: sm.turnoversObject)
                    }) {
                        Text("TO")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.recordCharge(chargesDrawn: sm.chargesObject)
                    }) {
                        Text("CRG Drawn")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }

                }
                // Second Row
                HStack{
                    Button(action: {
                        sm.recordPersonalFoul(personalFouls: sm.personalFoulsObject)
                    }) {
                        Text("Per. Foul")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                    sm.recordOpponent2PointerMade(opponent2pointerMade:
                    sm.opponent2pointerMadeObject, opponentScore: sm.OpponentScoreObject)
                    }) {
                        Text("Opp. 2PM")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.recordOpponent2PointerAttempted(opponent2pointerAttemped: sm.opponent2pointerAttemptedObject)
                    }) {
                        Text("Opp. 2PA")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.recordOpponent3PointerMade(opponent3pointerMade: sm.opponent3pointerMadeObject, opponentScore: sm.OpponentScoreObject)
                    }) {
                        Text("Opp. 3PM")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.recordOpponent3PointerAttempted(opponent3pointerAttemped: sm.opponent3pointerAttemptedObject)
                    }) {
                        Text("Opp. 3PA")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    // Opp Rebounds
                    Button(action: {
                        sm.recordOpponentDefReb(oppDefReb: sm.oppDefensiveReboundsObject)
                    }) {
                        Text("Opp. Def Reb")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                    
                    Button(action: {
                        sm.recordOpponentOffReb(oppOffReb: sm.oppOffensiveReboundsObject)
                    }) {
                        Text("Opp. Off Reb")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(40.0)
                    }
                }
                
            }

            Button(action: {
                // Send the data to the Firebase database
                sendBasketballStats()
            }) {
                Text("Send Data to Firebase")
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.orange)
                    .cornerRadius(40.0)
            }
            
            Button(action: {
                    // Undo last action
                    undoAction()
                }) {
                    Text("Undo Last Play")
                    .padding(10)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(40.0)
                }
        }
        .padding(10)
        .environmentObject(sm)
        
    }
    
    func undoAction() {
        guard let lastAction = actionHistory.last else {
                // If actionHistory is empty, do nothing
                return
            }

            // Remove the last action from the history
            actionHistory.removeLast()

            switch lastAction {
            case "2-Pointer Made":
                sm.twoPointersMade -= 1
                sm.teamScoreObject -= 2
            case "3-Pointer Made":
                sm.threePointersMade -= 1
                sm.teamScoreObject -= 3
            case "Assist":
                sm.assistsObject -= 1
            case "Steal":
                sm.stealsObject -= 1
            case "Off. Rebound":
                sm.offensiveReboundsObject -= 1
            case "Def. Rebound":
                sm.defensiveReboundsObject -= 1
            case "Turnover":
                sm.turnoversObject -= 1
            case "Charge":
                sm.chargesObject -= 1
            case "3PA":
                sm.threePointersAttemptedObject -= 1
            case "2PA":
                sm.twoPointersAttemptedObject -= 1
            case "FT":
                sm.freeThrowsMadeObject -= 1
                sm.teamScoreObject -= 1
            case "FTA":
                sm.freeThrowsAttemptedObject -= 1
            case "Per. Foul":
                sm.personalFoulsObject -= 1
            case "Opp. 2PM":
                sm.opponent2pointerMadeObject -= 1
                sm.OpponentScoreObject -= 2
            case "Opp. 2PA":
                sm.opponent2pointerAttemptedObject -= 1
            case "Opp. 3PM":
                sm.opponent3pointerMadeObject -= 1
                sm.OpponentScoreObject -= 3
            case "Opp. 3PA":
                sm.opponent3pointerAttemptedObject -= 1
            case "Opp. Def Reb":
                sm.oppDefensiveReboundsObject -= 1
            case "Opp. Off Reb":
                sm.oppOffensiveReboundsObject -= 1
            default: break
            }
    }


    func sendBasketballStats() {
        
        
           guard let reference = ref else {
               print("Firebase reference is not available")
               return
           }

           // Define the data to be sent
           let data = [
                "2_pointers_made": sm.twoPointersMade,
                "3_pointers_made": sm.threePointersMade,
                "Free Throws Made": sm.freeThrowsMadeObject,
                "Free Throws Attempted": sm.freeThrowsAttemptedObject,
                "assists": sm.assistsObject,
                "steals": sm.stealsObject,
                "Defensive Rebounds": sm.defensiveReboundsObject,
                "Offensive Rebounds": sm.offensiveReboundsObject,
                "Turnovers": sm.turnoversObject,
                "Charges": sm.chargesObject,
                "Personal Fouls": sm.personalFoulsObject,
                "2_pointers_attempted": sm.twoPointersAttemptedObject,
                "3_pointers_attempted": sm.threePointersAttemptedObject,
                "Opponent 3 pointers made": sm.opponent3pointerMadeObject,
                "Opponent 3 pointers attempted": sm.opponent3pointerAttemptedObject,
                "Opponent 2 pointers made": sm.opponent2pointerMadeObject,
                "Opponent 2 pointers attempted": sm.opponent2pointerAttemptedObject,
                "Opponent Off Reb": sm.oppOffensiveReboundsObject,
                "Opponent Def Reb": sm.oppOffensiveReboundsObject,
                "Team Score": sm.teamScoreObject,
                "Opponent Score": sm.OpponentScoreObject,
           ]

           // Push the data to a specific location in the database
        reference.child("basketball_stats").child("Boston Trinity Academy").setValue(data) { (error, reference) in
               if let error = error {
                   print("Data could not be saved: \(error.localizedDescription)")
               } else {
                   print("Basketball stats saved successfully!")
               }
           }
       }
}

func recordAction(_ action: String) {
        actionHistory.append(action)
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(sm())
    }
}

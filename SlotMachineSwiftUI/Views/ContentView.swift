//
//  ContentView.swift
//  SlotMachineSwiftUI
//
//  Created by Rustam Keneev on 21/3/24.
//

import SwiftUI

struct ContentView: View {
    //MARK: - PROPERTIES
    @State private var showingInfoView: Bool = false
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    @State private var reels: Array = [0,1,2]
    @State private var highScore: Int = 0
    @State private var coins: Int = 100
    @State private var betAmmount: Int = 10
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    
    //MARK: - FUNCTIONS
    //SPIN REELS
    func spinReels(){
//        reels[0] = Int.random(in: 0...symbols.count - 1)
//        reels[1] = Int.random(in: 0...symbols.count - 1)
//        reels[2] = Int.random(in: 0...symbols.count - 1)
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
    }
    
    //CHECK THE WINNING
    func checkWinning(){
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            //PLAYER WINS
            playerWins()
            
            //NEW HIGHSCORE
            if coins > highScore {
                newHighScore()
            }
        }else{
            //PLAYER LOSER
            playerLosses()
        }
    }
    
    func playerWins(){
        coins += betAmmount * 10
    }
    
    func newHighScore(){
        highScore = coins
    }
    
    func playerLosses(){
        coins -= betAmmount
    }
    
    func activateBet20(){
        betAmmount = 20
        isActiveBet20 = true
        isActiveBet10 = false
    }
 
    func activateBet10(){
        betAmmount = 10
        isActiveBet10 = true
        isActiveBet20 = false
    }
    
    //GAME IS OVER
    

    var body: some View {
        //MARK: - BODY
        ZStack{
            //MARK: - BACKGROUND
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            //MARK: - INTERFACE
            VStack(alignment: .center, spacing: 5){
                //MARK: - HEADER
                LogoView()
                Spacer()
                
                //MARK: - SCORE
                HStack {
                    HStack {
                        Text("You\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }//: HSTACK
                    .modifier(ScoreContainerModifier())
                    Spacer()
                    HStack {
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }//: HSTACK
                    .modifier(ScoreContainerModifier())

                }//: HSTACK
                
                //MARK: - SLOT MACHINE
                VStack(alignment: .center, spacing: 0){
                    //MARK: - REEL #1
                    ZStack{
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                    }// ZSTACK
                    HStack(alignment: .center, spacing: 0){
                        //MARK: - REEL #2
                        ZStack{
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                        }// ZSTACK
                        
                        Spacer()
                        
                        //MARK: - REEL #3
                        ZStack{
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                        }// ZSTACK
                    }
                    .frame(maxWidth: 500)
                    
                    //MARK: - SPIN BUTTON
                    Button(action: {
                        //SPIN REELS
                        self.spinReels()
                        print("Spin Reels")
                        
                        //CHECK WINNING
                        self.checkWinning()
                    }, label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })
                }//: VSTACK SLOT MACHINE
                .layoutPriority(2)
                
                //MARK: - FOOTER
                Spacer()
                HStack{
                    //MARK: - BET 20
                    HStack(alignment:.center, spacing: 10) {
                        Button(action: {
                            self.activateBet20()
                            print("Bet 20 coins")
                        }){
                          Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ? Color("ColorYellow") : Color.white)
                                .modifier(BetnumberModifier())
                        }
                        .modifier(BetCapsuleModifier())

                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }//: HSTACK
                    
                    //MARK: - BET 10
                    HStack(alignment:.center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            self.activateBet10()
                            print("Bet 10 coins")
                        }){
                          Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? Color("ColorYellow") : Color.white)
                                .modifier(BetnumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                    }//: HSTACK
                }//: HSTACK
            }//VSTACK
            
            //MARK: - BUTTONS
            .overlay(
                //RESET
                Button(action: {
                    print("Reset the game")
                }){
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                    .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            
            .overlay(
                //INFO
                Button(action: {
                    print("Info View")
                    self.showingInfoView = true
                }){
                    Image(systemName: "info.circle")
                }
                    .modifier(ButtonModifier()),
                alignment: .topTrailing
            )

            .padding()
//            .frame(minWidth: 720)
            //MARK: - POPUP
        }//: ZSTACK
        .sheet(isPresented: $showingInfoView){
            InfoView()
        }
    }
}

//MARK: - PREVIEW
#Preview {
    ContentView()
}

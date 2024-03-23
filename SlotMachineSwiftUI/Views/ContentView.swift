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
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmmount: Int = 10
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    @State private var showingModal: Bool = false
    
    //MARK: - FUNCTIONS
    //SPIN REELS
    func spinReels(){
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
        UserDefaults.standard.set(highScore, forKey: "HighScore")
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
    func isGameOver(){
        if coins <= 0 {
            //SHOW MODAL WINDOW
            showingModal = true
        }
    }
    
    func resetGame(){
        UserDefaults.standard.setValue(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        activateBet10()
    }
    

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
                        
                        //GAME IS OVER
                        self.isGameOver()
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
                    self.resetGame()
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
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            //MARK: - POPUP
            if $showingModal.wrappedValue {
                ZStack{
                    Color("ColorTransparentBlack")
                        .edgesIgnoringSafeArea(.all)
                    
                    //MODAL
                    VStack(spacing: 0){
                        //TITLE
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color.white)
                        Spacer()
                        
                        //MESSAGE
                        VStack(alignment: .center, spacing: 16){
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck! You lost all of the coins. \nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                self.showingModal = false
                                self.coins = 100
                            }){
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.76 )
                                            .foregroundColor(Color("ColorPink"))
                                    )
                            }
                        }
                        Spacer()
                    }
                    .frame(minWidth: 280,idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                }
            }
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

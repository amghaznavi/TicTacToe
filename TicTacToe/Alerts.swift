//
//  Alerts.swift
//  TicTacToe
//
//  Created by Am GHAZNAVI on 02/10/2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
   static let humanWin = AlertItem(title: Text("You win"),
                             message: Text("You are smart"),
                             buttonTitle: Text("Yeah"))
    
    static let computerWin = AlertItem(title: Text("You lost"),
                             message: Text("You programmed a super AI."),
                             buttonTitle: Text("Rematch"))
    
    static let draw = AlertItem(title: Text("Draw"),
                             message: Text("What a battle of wits we have here ... "),
                             buttonTitle: Text("Try again"))
}

//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Am GHAZNAVI on 02/10/2021.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()) ]
    
    @Published  var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published  var isGameboardDisabled = false
    @Published  var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        //Check to see if circle is occupied
        if isCircleOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        //Check for win condition or draw
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        //Check for draw
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameboardDisabled =  true
        
        //To delay computer move for 0.05 Sec(s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [self] in
            let computerPosition = determinedComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            //Check for draw
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }

    func isCircleOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determinedComputerMovePosition(in moves: [Move?]) -> Int {
        
        //If AI can win, them win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        for pattern in winPatterns {
            let winpositions = pattern.subtracting(computerPositions)
            if winpositions.count == 1 {
                let isAvailable = !isCircleOccupied(in: moves, forIndex: winpositions.first!)
                if isAvailable { return winpositions.first! }
            }
        }
        
        //If AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        for pattern in winPatterns {
            let winpositions = pattern.subtracting(humanPositions)
            
            if winpositions.count == 1 {
                let isAvailable = !isCircleOccupied(in: moves, forIndex: winpositions.first!)
                if isAvailable { return winpositions.first! }
            }
        }
        
        //If AI cant't blobk, then take middle circle
        let centerCircle = 4
        if !isCircleOccupied(in: moves, forIndex: centerCircle) {
            return centerCircle
        }
    
        var movePosition = Int.random(in: 0..<9)
        
        while isCircleOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMove = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPosition = Set(playerMove.map { $0.boardIndex })
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) { return true }
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }

}


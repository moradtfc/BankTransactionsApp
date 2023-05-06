//
//  ViewModel.swift
//  BankTransactionsList
//
//  Created by Jesus Mora on 5/5/23.
//

import Foundation
import SwiftUI

//Model Struct
struct Transaction: Hashable, Codable {
    let id: Int?
    let date: String?
    let amount: Double?
    let fee: Double?
    let description: String?
    
    var totalAmount: String {
        
        let r = abs(amount ?? 0.0) + abs(fee ?? 0.0)
        
        return String(r)
        
    }
}


class ViewModel: ObservableObject {
    
    @Published var transactions: [Transaction] = []
    
    func fetch(){
        guard let url = URL(string: "https://code-challenge-e9f47.web.app/transactions.json") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Convert to JSON
            do{
                let transactions = try JSONDecoder().decode([Transaction].self, from: data)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                
                
                //FilterJSON to obtain ONLY the values with the correct dateFormat
                let filteredJSON = transactions.filter { (transaction) -> Bool in
                    if let dateString = transaction.date {
                                    return dateFormatter.date(from: dateString) != nil
                                }
                                return false
                            }
                
                // Create dictionary with the most recent transaction for each id
                var mostRecentTransactions = [String: Transaction]()
                for transaction in filteredJSON {
                    if let id = transaction.id {
                        if let existingTransaction = mostRecentTransactions[String(id)] {
                            if let existingDate = existingTransaction.date,
                                let currentDate = transaction.date,
                                let existingDateTime = dateFormatter.date(from: existingDate),
                                let currentDateTime = dateFormatter.date(from: currentDate),
                                currentDateTime > existingDateTime {
                                mostRecentTransactions[String(id)] = transaction
                            }
                        } else {
                            mostRecentTransactions[String(id)] = transaction
                        }
                    }
                }
                
                // Convert dictionary back to array
                let result = Array(mostRecentTransactions.values)
    
                DispatchQueue.main.async {
                        self?.transactions = result.sorted(by: { $0.date ?? "n/a" > $1.date ?? "n/a"})
                }
            }
            catch{
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    
}

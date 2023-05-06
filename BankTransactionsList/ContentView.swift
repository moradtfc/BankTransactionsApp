//
//  ContentView.swift
//  BankTransactionsList
//
//  Created by Jesus Mora on 5/5/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(viewModel.transactions, id: \.self) { transaction in
                    VStack{
                       // Text("Transaction Number \(transaction.id)")
                        Text(transaction.date ?? "not found date").bold()
                            .padding(.top, 3)
             
                        Text(transaction.totalAmount + "€")
                            .bold()
                            .padding(3)
                        
                        HStack{
                            if(transaction.amount ?? 0.0 < 0){
                     
                                    Text("Expense:")
                                    Image(systemName: "dollarsign.square.fill")
                                        .font(.system (size: 30.0))
                                        .foregroundColor(.red)
                                
                            }
                            else{
                         
                                    Text("Income:")
                                    Image(systemName: "dollarsign.square.fill")
                                        .font(.system (size: 30.0))
                                        .foregroundColor(.green)
                                
                                
                            }
                        }
                          
                    }
                }
            }
            .navigationTitle("Bank Transactions")
            .onAppear {
                viewModel.fetch()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

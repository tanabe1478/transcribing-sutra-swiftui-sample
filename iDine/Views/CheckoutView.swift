//
//  CheckoutView.swift
//  iDine
//
//  Created by 田辺信之 on 2019/11/04.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var order: Order
    @State private var paymentType = 0
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var tipAmount = 1
    @State private var showingPaymentAlert = false
    
    static let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
    static let tipAmounts = [10, 15, 20, 25, 0]
    
    var totalPrice: Double {
        let total = Double(order.total)
        let tipValue = total / 100 * Double(Self.tipAmounts[tipAmount])
        return total + tipValue
    }
    
    var body: some View {
        Form {
            Section {
                Picker("How do you want to pay?", selection: $paymentType) {
                    ForEach(0..<Self.paymentTypes.count) {
                        Text(Self.paymentTypes[$0])
                    }
                }
                Toggle(isOn: $addLoyaltyDetails.animation()) {
                    Text("Add iDine loyalty card")
                }
                TextField("Enter your iDine ID", text: $loyaltyNumber)
            }
            Section(header: Text("Add a tip?")) {
                Picker("Percentage:", selection: $tipAmount) {
                    ForEach(0..<Self.tipAmounts.count) {
                        Text("\(Self.tipAmounts[$0])%")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("Total: $\(totalPrice, specifier: "%.2f")")
                .font(.largeTitle)
            ) {
                Button("Confirm order") {
                    self.showingPaymentAlert.toggle()
                    // plac the order
                }
            }
        }.navigationBarTitle(Text("Payment"), displayMode: .inline)
            .alert(isPresented: $showingPaymentAlert) {
                // more to come
                Alert(
                    title: Text("Order confirmed"),
                    message: Text("Your total was a $\(totalPrice, specifier: "%.2f") - thank you!"),
                    dismissButton: .default(Text("OK"))
                )
        }
    }

}

struct CheckoutView_Previews: PreviewProvider {
    static let order = Order()
    static var previews: some View {
        CheckoutView().environmentObject(order)
    }
}

//
//  StoreListView.swift
//  MealMate
//
//  Created by Kish Dizon on 2026-01-04.
//

 import SwiftUI

 struct StoreListView: View {
     let postalCode: String
     let stores: [Store]

     var body: some View {
         List(stores) { store in
             NavigationLink(destination: RecipesView(postalCode: postalCode, store: store)) {
                 StoreRow(store: store)
             }
         }
         .listStyle(.insetGrouped)
         .navigationTitle("Stores Near You")
         .navigationBarTitleDisplayMode(.large)
     }
 }

 struct StoreRow: View {
     let store: Store


     var body: some View {
         HStack(spacing: 16) {

             VStack(alignment: .leading, spacing: 4) {
                 Text(store.name)
                     .font(.headline)

                 Text("View deals & recipes")
                     .font(.subheadline)
                     .foregroundColor(.secondary)
             }

             Spacer()

             Image(systemName: "chevron.right")
                 .foregroundColor(.secondary)
         }
         .padding(.vertical, 8)
     }
 }

 #Preview {
     NavigationStack {
         StoreListView(
             postalCode: "M5V2H1",
             stores: [
                 Store(name: "No Frills", flyerId: 1),
                 Store(name: "Loblaws", flyerId: 2),
                 Store(name: "FreshCo", flyerId: 3),
             ]
         )
     }
 }

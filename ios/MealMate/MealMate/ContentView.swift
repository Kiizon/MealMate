//
//  ContentView.swift
//  MealMate
//
//  Created by Kish Dizon on 2025-12-30.
//

import SwiftUI

struct ContentView: View {
    @State private var postalCode = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var stores: [Store] = []
    @State private var navigateToStores = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    // Logo & Title
                    VStack(spacing: 12) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)

                        Text("MealMate")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Find recipes using ingredients\nthat are ON SALE near you")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    // Input Card
                    VStack(spacing: 16) {
                        Text("Enter your postal code")
                            .font(.headline)

                        TextField("M5V 2H1", text: $postalCode)
                            .textFieldStyle(.roundedBorder)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .autocapitalization(.allCharacters)
                            .frame(maxWidth: 200)

                        Button(action: findDeals) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "magnifyingglass")
                                    Text("Find Deals")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(postalCode.isEmpty ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(postalCode.isEmpty || isLoading)

                        if let error = errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(24)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .padding(.horizontal, 32)

                    Spacer()
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToStores) {
                StoreListView(postalCode: postalCode, stores: stores)
            }
        }
    }

    private func findDeals() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await NetworkManager.shared.fetchStores(postalCode: postalCode)
                stores = response.stores

                if stores.isEmpty {
                    errorMessage = "No stores found for this postal code"
                } else {
                    navigateToStores = true
                }
            } catch {
                errorMessage = "Failed to fetch stores. Is the server running?"
            }
            isLoading = false
        }
    }
}

#Preview {
    ContentView()
}


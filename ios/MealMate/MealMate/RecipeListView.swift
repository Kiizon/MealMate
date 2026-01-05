//
//  RecipeListView.swift
//  MealMate
//
//  Created by Kish Dizon on 2026-01-04.
//

import SwiftUI

  struct RecipesView: View {
      let postalCode: String
      let store: Store

      @State private var recipes: [Recipe] = []
      @State private var ingredientsOnSale: [String] = []
      @State private var isLoading = true
      @State private var errorMessage: String?

      let columns = [
          GridItem(.flexible(), spacing: 16),
          GridItem(.flexible(), spacing: 16)
      ]

      var body: some View {
          ScrollView {
              VStack(alignment: .leading, spacing: 16) {
                  // Ingredients on sale badge
                  if !ingredientsOnSale.isEmpty {
                      VStack(alignment: .leading, spacing: 8) {
                          Text("ON SALE")
                              .font(.caption)
                              .fontWeight(.bold)
                              .foregroundColor(.green)

                          Text(ingredientsOnSale.joined(separator: ", "))
                              .font(.subheadline)
                              .foregroundColor(.secondary)
                      }
                      .padding()
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .background(Color.green.opacity(0.1))
                      .cornerRadius(12)
                      .padding(.horizontal)
                  }

                  if isLoading {
                      VStack {
                          Spacer()
                          ProgressView("Finding recipes...")
                          Spacer()
                      }
                      .frame(maxWidth: .infinity, minHeight: 300)
                  } else if let error = errorMessage {
                      VStack {
                          Image(systemName: "exclamationmark.triangle")
                              .font(.largeTitle)
                              .foregroundColor(.orange)
                          Text(error)
                              .foregroundColor(.secondary)
                      }
                      .frame(maxWidth: .infinity, minHeight: 300)
                  } else if recipes.isEmpty {
                      VStack {
                          Image(systemName: "fork.knife")
                              .font(.largeTitle)
                              .foregroundColor(.secondary)
                          Text("No recipes found")
                              .foregroundColor(.secondary)
                      }
                      .frame(maxWidth: .infinity, minHeight: 300)
                  } else {
                      LazyVGrid(columns: columns, spacing: 16) {
                          ForEach(recipes) { recipe in
                              NavigationLink(destination: RecipeDetailView(recipe: recipe, ingredientsOnSale: ingredientsOnSale, storeName: store.name)) {
                                  RecipeCard(recipe: recipe)
                              }
                              .buttonStyle(PlainButtonStyle())
                          }
                      }
                      .padding(.horizontal)
                  }
              }
              .padding(.vertical)
          }
          .navigationTitle("\(store.name) Recipes")
          .navigationBarTitleDisplayMode(.inline)
          .task {
              await loadRecipes()
          }
      }

      private func loadRecipes() async {
          do {
              let response = try await NetworkManager.shared.fetchRecipes(
                  postalCode: postalCode,
                  merchant: store.name
              )
              recipes = response.recipes
              ingredientsOnSale = response.ingredientsOnSale
          } catch {
              errorMessage = "Failed to load recipes"
          }
          isLoading = false
      }
  }

  struct RecipeCard: View {
      let recipe: Recipe

      var body: some View {
          VStack(alignment: .leading, spacing: 8) {
              // Image
              AsyncImage(url: URL(string: recipe.image)) { phase in
                  switch phase {
                  case .empty:
                      Rectangle()
                          .fill(Color.gray.opacity(0.2))
                          .aspectRatio(1.2, contentMode: .fit)
                          .overlay(ProgressView())
                  case .success(let image):
                      image
                          .resizable()
                          .aspectRatio(1.2, contentMode: .fill)
                          .clipped()
                  case .failure:
                      Rectangle()
                          .fill(Color.gray.opacity(0.2))
                          .aspectRatio(1.2, contentMode: .fit)
                          .overlay(
                              Image(systemName: "photo")
                                  .foregroundColor(.gray)
                          )
                  @unknown default:
                      EmptyView()
                  }
              }
              .cornerRadius(12)

              // Title
              Text(recipe.title)
                  .font(.subheadline)
                  .fontWeight(.semibold)
                  .lineLimit(2)
                  .multilineTextAlignment(.leading)

              // Ingredient match
              HStack(spacing: 4) {
                  Image(systemName: "checkmark.circle.fill")
                      .foregroundColor(.green)
                      .font(.caption)

                  Text("\(recipe.usedIngredientCount) on sale")
                      .font(.caption)
                      .foregroundColor(.green)

                  if recipe.missedIngredientCount > 0 {
                      Text("· \(recipe.missedIngredientCount) needed")
                          .font(.caption)
                          .foregroundColor(.secondary)
                  }
              }
          }
          .padding(12)
          .background(Color(.systemBackground))
          .cornerRadius(16)
          .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
      }
  }

  #Preview {
      NavigationStack {
          RecipesView(
              postalCode: "M5V2H1",
              store: Store(name: "No Frills", flyerId: 1)
          )
      }
  }

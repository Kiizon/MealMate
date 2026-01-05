//
//  RecipeDetailView.swift
//  MealMate
//
//  Created by Kish Dizon on 2026-01-04.
//

import SwiftUI

  struct RecipeDetailView: View {
      let recipe: Recipe
      let ingredientsOnSale: [String]
      let storeName: String

      var body: some View {
          ScrollView {
              VStack(alignment: .leading, spacing: 20) {
                  // Hero Image
                  AsyncImage(url: URL(string: recipe.image)) { phase in
                      switch phase {
                      case .empty:
                          Rectangle()
                              .fill(Color.gray.opacity(0.2))
                              .aspectRatio(16/9, contentMode: .fit)
                              .overlay(ProgressView())
                      case .success(let image):
                          image
                              .resizable()
                              .aspectRatio(16/9, contentMode: .fill)
                              .clipped()
                      case .failure:
                          Rectangle()
                              .fill(Color.gray.opacity(0.2))
                              .aspectRatio(16/9, contentMode: .fit)
                      @unknown default:
                          EmptyView()
                      }
                  }

                  VStack(alignment: .leading, spacing: 20) {
                      // Title
                      Text(recipe.title)
                          .font(.title)
                          .fontWeight(.bold)

                      // Stats
                      HStack(spacing: 20) {
                          StatBadge(icon: "checkmark.circle.fill", value: "\(recipe.usedIngredientCount)", label: "On Sale", color: .green)
                          StatBadge(icon: "cart.badge.plus", value: "\(recipe.missedIngredientCount)", label: "To Buy", color: .orange)
                      }

                      Divider()

                      // Ingredients on Sale
                      if !recipe.usedIngredients.isEmpty {
                          VStack(alignment: .leading, spacing: 12) {
                              Label("Ingredients On Sale", systemImage: "tag.fill")
                                  .font(.headline)
                                  .foregroundColor(.green)

                              ForEach(recipe.usedIngredients) { ingredient in
                                  IngredientRow(ingredient: ingredient, isOnSale: true, storeName: storeName)
                              }
                          }
                      }

                      // Ingredients to Buy
                      if !recipe.missedIngredients.isEmpty {
                          VStack(alignment: .leading, spacing: 12) {
                              Label("Ingredients to Buy", systemImage: "cart")
                                  .font(.headline)
                                  .foregroundColor(.secondary)

                              ForEach(recipe.missedIngredients) { ingredient in
                                  IngredientRow(ingredient: ingredient, isOnSale: false, storeName: storeName)
                              }
                          }
                      }

                      Divider()

                      // Placeholder for instructions
                      VStack(alignment: .leading, spacing: 12) {
                          Label("Instructions", systemImage: "list.number")
                              .font(.headline)

                          Text("Visit the full recipe for detailed cooking instructions.")
                              .foregroundColor(.secondary)

                          // In a real app, you'd fetch full recipe details from Spoonacular
                          // using the recipe ID and display actual instructions
                      }
                  }
                  .padding()
              }
          }
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
              ToolbarItem(placement: .navigationBarTrailing) {
                  Button(action: {}) {
                      Image(systemName: "heart")
                  }
              }
          }
      }
  }

  struct StatBadge: View {
      let icon: String
      let value: String
      let label: String
      let color: Color

      var body: some View {
          HStack(spacing: 8) {
              Image(systemName: icon)
                  .foregroundColor(color)

              VStack(alignment: .leading) {
                  Text(value)
                      .font(.headline)
                  Text(label)
                      .font(.caption)
                      .foregroundColor(.secondary)
              }
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 10)
          .background(color.opacity(0.1))
          .cornerRadius(10)
      }
  }

  struct IngredientRow: View {
      let ingredient: RecipeIngredient
      let isOnSale: Bool
      let storeName: String

      var body: some View {
          HStack {
              Image(systemName: isOnSale ? "checkmark.circle.fill" : "circle")
                  .foregroundColor(isOnSale ? .green : .secondary)

              Text(ingredient.original)
                  .font(.subheadline)

              Spacer()

              if isOnSale {
                  Text("@ \(storeName)")
                      .font(.caption)
                      .foregroundColor(.green)
                      .padding(.horizontal, 8)
                      .padding(.vertical, 4)
                      .background(Color.green.opacity(0.1))
                      .cornerRadius(8)
              }
          }
          .padding(.vertical, 4)
      }
  }

  #Preview {
      NavigationStack {
          RecipeDetailView(
              recipe: Recipe(
                  id: 1,
                  title: "Chicken Stir Fry with Rice and Vegetables",
                  image: "https://spoonacular.com/recipeImages/716429-312x231.jpg",
                  usedIngredientCount: 4,
                  missedIngredientCount: 2,
                  usedIngredients: [
                      RecipeIngredient(name: "chicken", amount: 2, unit: "lbs", original: "2 lbs chicken breast"),
                      RecipeIngredient(name: "rice", amount: 1, unit: "cup", original: "1 cup white rice"),
                  ],
                  missedIngredients: [
                      RecipeIngredient(name: "soy sauce", amount: 2, unit: "tbsp", original: "2 tbsp soy sauce"),
                  ]
              ),
              ingredientsOnSale: ["chicken", "rice", "broccoli"],
              storeName: "No Frills"
          )
      }
  }

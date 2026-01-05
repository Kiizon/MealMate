//
//  NetworkManager.swift
//  MealMate
//
//  Created by Kish Dizon on 2026-01-04.
//

import Foundation

  class NetworkManager {
      static let shared = NetworkManager()
      
      private let baseURL = "http://localhost:8000"
      private let session: URLSession

      private init() {
          let config = URLSessionConfiguration.default
          config.timeoutIntervalForRequest = 30
          self.session = URLSession(configuration: config)
      }

      // MARK: - Stores

      func fetchStores(postalCode: String) async throws -> StoresResponse {
          let cleanedCode = postalCode.replacingOccurrences(of: " ", with: "").uppercased()

          guard let url = URL(string: "\(baseURL)/api/stores/\(cleanedCode)") else {
              throw URLError(.badURL)
          }

          let (data, response) = try await session.data(from: url)

          guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
              throw URLError(.badServerResponse)
          }

          return try JSONDecoder().decode(StoresResponse.self, from: data)
      }

      // MARK: - Recipes

      func fetchRecipes(postalCode: String, merchant: String) async throws -> RecipesResponse {
          let cleanedCode = postalCode.replacingOccurrences(of: " ", with: "").uppercased()
          let encodedMerchant = merchant.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? merchant

          guard let url = URL(string: "\(baseURL)/api/recipes/\(cleanedCode)/\(encodedMerchant)") else {
              throw URLError(.badURL)
          }

          let (data, response) = try await session.data(from: url)

          guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
              throw URLError(.badServerResponse)
          }

          return try JSONDecoder().decode(RecipesResponse.self, from: data)
      }

      // MARK: - Deals (existing)

      func fetchDeals(postalCode: String) async throws -> DealsResponse {
          let cleanedCode = postalCode.replacingOccurrences(of: " ", with: "").uppercased()

          guard let url = URL(string: "\(baseURL)/api/deals/\(cleanedCode)") else {
              throw URLError(.badURL)
          }

          let (data, response) = try await session.data(from: url)

          guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
              throw URLError(.badServerResponse)
          }

          return try JSONDecoder().decode(DealsResponse.self, from: data)
      }
  }

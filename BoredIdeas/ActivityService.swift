//
//  ActivityService.swift
//  BoredIdeas
//
//  Created by David Owen on 3/6/23.
//

import Foundation

class ActivityService: ObservableObject {
    let baseURL = "https://www.boredapi.com/api"
    @Published var activity: Activity?
    @Published var nextActivity: Activity?
    
    @MainActor
    func getRandomActivity() async {
        guard let urlString = "\(baseURL)/activity/"
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: urlString) else {
//            errorString = "Invalid code entered"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            activity = try JSONDecoder().decode(Activity.self, from: data)
        } catch {
            print("Error")
        }
    }
    
    
    @MainActor
    func getSpecificActivity(key: String) async {
        guard let urlString = "\(baseURL)/activity?key=\(key)"
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: urlString) else {
//            errorString = "Invalid code entered"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            activity = try JSONDecoder().decode(Activity.self, from: data)
        } catch {
            print("Error")
        }
    }
}

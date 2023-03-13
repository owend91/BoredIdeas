//
//  BoredIdeasApp.swift
//  BoredIdeas
//
//  Created by David Owen on 3/6/23.
//

import SwiftUI

@main
struct BoredIdeasApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                
                ChooseActivityView()
                    .tabItem {
                        Image(systemName: "circle.hexagongrid")
                        Text("New Ideas")
                    }
                    .environment(\.managedObjectContext, SeenActivityProvidor.shared.viewContext)
                
                SeenActivitiesView()
                    .tabItem {
                        Image(systemName: "list.dash")
                        Text("Seen Ideas")
                    }
                    .environment(\.managedObjectContext, SeenActivityProvidor.shared.viewContext)
                
                
            }
        }
    }
}

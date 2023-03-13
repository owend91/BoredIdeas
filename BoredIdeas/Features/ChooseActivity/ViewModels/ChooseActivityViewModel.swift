//
//  ChooseActivityViewModel.swift
//  BoredIdeas
//
//  Created by David Owen on 3/6/23.
//

import Foundation

final class ChooseViewModel: ObservableObject {
    @Published var likedActivities: [Activity] = []
    @Published var dislikedActivities: [Activity] = []
    
    func printLikedActivites() {
        var str = ""
        for activity in likedActivities {
            str += activity.activity + ", "
        }
        print(str)
    }
    
    func printDislikedActivities() {
        var str = ""
        for activity in dislikedActivities {
            str += activity.activity + ", "
        }
        print(str)
    }
}

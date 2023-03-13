//
//  Activity.swift
//  BoredIdeas
//
//  Created by David Owen on 3/6/23.
//

import Foundation
/*
 {
     "activity": "Learn to write with your nondominant hand",
     "type": "recreational",
     "participants": 1,
     "price": 0,
     "link": "",
     "key": "1645485",
     "accessibility": 0.02
 }
 */

struct Activity: Codable {
    let activity: String
    let type: String
    let participants: Int
    let price: Double
    let link: String
    let key: String
    let accessibility: Double
    
    static let defaultActivity = Activity(activity: "Learn to write with your nondominant hand", type: "recreational", participants: 1, price: 0, link: "", key: "xxxx", accessibility: 0.02)
}

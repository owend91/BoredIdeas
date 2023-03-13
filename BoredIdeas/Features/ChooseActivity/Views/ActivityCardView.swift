//
//  ActivityCardView.swift
//  BoredIdeas
//
//  Created by David Owen on 3/6/23.
//

import SwiftUI

struct ActivityCardView: View {
    let activity: String
    let isLoading: Bool
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    Text(activity)
                        .foregroundColor(Theme.text)
                        .font(
                            .system(.body, design: .rounded)
                        )
                        .padding()
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: 250, height: 250)
            .background(Theme.cardBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Theme.text.opacity(0.1), radius: 2, x:0 , y: 1)
    }
}

struct EmptyActivityCardView: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                ProgressView()
            }
            .frame(width: 250, height: 250)
            .background(Theme.cardBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Theme.text.opacity(0.1), radius: 2, x:0 , y: 1)
    }
}

struct ActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ActivityCardView(activity: "Learn a new programming language", isLoading: false)
                
        }
            
    }
}

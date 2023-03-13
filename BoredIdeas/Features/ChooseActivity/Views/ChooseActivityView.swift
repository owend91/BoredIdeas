//
//  ContentView.swift
//  BoredIdeas
//
//  Created by David Owen on 3/6/23.
//

import SwiftUI

struct ChooseActivityView: View {
    @AppStorage("lastSeen") var lastSeenKey: String = Activity.defaultActivity.key
    @StateObject var activityService = ActivityService()
//    @StateObject var vm = ChooseViewModel()
    @State var isLoading = false
    @State var offset = CGSize.zero
    @State var screenBackgroundColor = Theme.background
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(fetchRequest: SeenActivity.all()) private var seenActivities
    @State var isCardVisible = true
    @State var isSwiping = false

    var body: some View {
        ZStack {
            screenBackgroundColor
                .ignoresSafeArea()
            VStack {
                if let activity = activityService.activity {
                    Spacer()
                    ActivityCardView(activity: activity.activity, isLoading: isLoading)
                        .offset(x: offset.width, y: offset.height * 0.4)
                        .rotationEffect(.degrees(Double(offset.width / 40)))
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ value in
                                offset = value.translation
                                withAnimation {
                                    isSwiping = true
                                    changeColor(width: offset.width)
                                }
                            })
                            .onEnded({ value in
                                withAnimation {
                                    isSwiping = true
                                    offset = CGSize.zero
                                    changeColor(width: offset.width)
                                }
                                if value.translation.width <= -150 {
                                    print("Task Disliked!")
                                    Task {
                                        await addSeenActivity(isLiked: false)
                                    }
                                }
                                
                                if value.translation.width >= 150 {
                                    print("Task Liked!")

                                    Task {
                                        await addSeenActivity(isLiked: true)
                                    }
                                }
                            }))
                        .opacity(isCardVisible ? 100 : 0)
                } else {
                    Spacer()
                    EmptyActivityCardView()
                }
                
                Spacer()
                
                HStack {
                    Button {
                        withAnimation(.linear(duration: 0.3)){
                            offset = CGSize(width: -500, height: 0)
                            screenBackgroundColor = Theme.negativeColor
                            isCardVisible = false
                        }
                        Task {
                            try await Task.sleep(nanoseconds:300000000)
                            await addSeenActivity(isLiked: false)
                            offset = CGSize.zero
                            screenBackgroundColor = Theme.background
                            withAnimation {
                                isCardVisible = true
                            }

                        }
                    } label: {
                        Image(systemName: "hand.thumbsdown.circle.fill")
                            .foregroundColor(Theme.negativeColor)
                            .font(
                                .system(size: 70, weight: .bold, design: .rounded)
                            )
                    }
                    .padding(.leading, 40)
                    
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.linear(duration: 0.3)){
                            offset = CGSize(width: 500, height: 0)
                            screenBackgroundColor = Theme.positiveColor
                            isCardVisible = false
                        }
                        

                        Task {
                            try await Task.sleep(nanoseconds:300000000)
                            await addSeenActivity(isLiked: true)
                            offset = CGSize.zero
                            screenBackgroundColor = Theme.cardBackground
                            withAnimation {
                                isCardVisible = true
                            }
                        }
                    } label: {
                        Image(systemName: "hand.thumbsup.circle.fill")
                            .foregroundColor(Theme.positiveColor)
                            .font(
                                .system(size: 70, weight: .bold, design: .rounded)
                            )
                        
                    }
                    .padding(.trailing, 40)
            
                }
                .background(
                    Capsule()
                        .foregroundColor(Theme.cardBackground.opacity(isSwiping ? 0.8 : 1))
                        .padding(.horizontal)
                        .shadow(color: Theme.text.opacity(0.1), radius: 2, x:0 , y: 1)
                    
                )
                
                Spacer()
            }
        }
        .task {
            if lastSeenKey == Activity.defaultActivity.key {
                await getNewActivity()
            } else {
                await activityService.getSpecificActivity(key: lastSeenKey)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseActivityView()
    }
}

extension ChooseActivityView {
    func getNewActivity() async {
        var isNewActivity = false
        var attemptCount = 0
        while !isNewActivity {
            if attemptCount != 0 {
                isLoading = true
            }
            await activityService.getRandomActivity()
            if let activity = activityService.activity {
                if seenActivities.filter({$0.key == activity.key}).isEmpty {
                    isNewActivity = true
                    isLoading = false
                    lastSeenKey = activity.key
                } else {
                    attemptCount += 1
                    print("repeat activity: \(activity.activity)")
                }
            }
        }
    }
    
    func addSeenActivity(isLiked: Bool) async {
        if let activity = activityService.activity {
            let seenActivity = SeenActivity(context: moc)
            seenActivity.key = activity.key
            seenActivity.name = activity.activity
            seenActivity.isLiked = isLiked
            do {
                try moc.save()
            } catch {
                print(error)
            }
        }
        await getNewActivity()
    }
    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            offset = CGSize(width: -500, height: 0)
        case 150...500:
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
    
    func changeColor(width: CGFloat) {
        switch width {
        case -500...(-130):
            screenBackgroundColor = Theme.negativeColor
        case 130...500:
            screenBackgroundColor = Theme.positiveColor
        default:
            screenBackgroundColor = Theme.background
        }
    }

}


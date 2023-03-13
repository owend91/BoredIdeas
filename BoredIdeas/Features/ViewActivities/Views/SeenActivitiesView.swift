//
//  SeenActivitiesView.swift
//  BoredIdeas
//
//  Created by David Owen on 3/7/23.
//

import SwiftUI

struct SearchConfig: Equatable {
    enum Filter {
        case all, liked, disliked
    }
    var query: String = ""
    var filter: Filter = .all
}

struct SeenActivitiesView: View {
    @State private var searchConfig: SearchConfig = .init()
    @FetchRequest(fetchRequest: SeenActivity.all()) private var seenActivities
    @Environment(\.managedObjectContext) private var moc
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            VStack {
                Picker(selection: $searchConfig.filter) {
                    Text("All").tag(SearchConfig.Filter.all)
                    Text("Liked").tag(SearchConfig.Filter.liked)
                    Text("Disliked").tag(SearchConfig.Filter.disliked)

                } label: {
                    Text("Filter Favorites")
                }
                .padding(.top, 10)
                .pickerStyle(.segmented)
                List {
                    ForEach(seenActivities, id: \.key) { activity in
                        
                        HStack {
                            Text(activity.name)
                                .padding(.trailing, 10)
                            Spacer()
                            Image(systemName: activity.isLiked ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                                .foregroundColor(activity.isLiked ? .green : .red)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                activity.isLiked = true
                                activity.updatedDate = Date.now
                                do {
                                    try moc.save()
                                } catch {
                                    print(error)
                                }
                            } label: {
                                Label("Like", systemImage: "hand.thumbsup.fill")
                            }
                            .tint(.green)
                            .disabled(activity.isLiked)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                activity.isLiked = false
                                activity.updatedDate = Date.now

                                do {
                                    try moc.save()
                                } catch {
                                    print(error)
                                }
                            } label: {
                                Label("Dislike", systemImage: "hand.thumbsdown.fill")
                            }
                            .tint(.red)
                            .disabled(!activity.isLiked)
                        }
                        
                    }
                    
                }
            }
            .padding()
        }
        .onChange(of: searchConfig) { newConfig in
            seenActivities.nsPredicate = SeenActivity.filter(with: newConfig)
        }
    }
}

struct SeenActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        SeenActivitiesView()
    }
}

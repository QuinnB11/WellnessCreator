//
//  LibraryView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/2/24.
//

import SwiftUI

struct LibraryView: View {
    let currentDate = Date()
    @Environment(WellnessManager.self) var wellnessManager
    @State private var searchText = ""
        
    var body: some View {
            NavigationStack {
                ZStack {
                    Color(.black).ignoresSafeArea()
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: -20) {
                                Text(wellnessManager.dateFormatter.string(from: currentDate))
                                    .font(.custom("Snell Roundhand", size: 35))
                                    .foregroundColor(Color.white)
                                Text("Library")
                                    .font(.custom("Snell Roundhand", size: 50))
                                    .foregroundColor(Color.white)
                            }.padding()
                            Spacer()
                        }
                        
                        SearchBar(searchText: $searchText)
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(filteredCreations) { creation in
                                    NavigationLink(
                                        destination: WellnessRun(creation: creation)
                                    ) {
                                        WellnessCreationView(creation: creation)
                                    }
                                }
                            }
                            .padding()
                        }
                        
                    }.padding(.top, 50)
                }
            }
        }
        
        private var filteredCreations: [WellnessCreation] {
            if searchText.isEmpty {
                return wellnessManager.wellnessCreations
            } else {
                return wellnessManager.wellnessCreations.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }
        }
    }

    struct WellnessCreationView: View {
        var creation: WellnessCreation
        @Environment(WellnessManager.self) var wellnessManager
        
        var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {wellnessManager.deleteWellnessCreation(named: creation.name)}) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(0)
                    }.padding(0)
                }
                Image("CirclesFlower")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                
                Text(creation.name)
                    .font(.headline)
                    .lineLimit(1)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }

    struct SearchBar: View {
        @Binding var searchText: String
        
        var body: some View {
            TextField("Search", text: $searchText)
                .padding(10)
                .background(Color.white.opacity(0.6))
                .cornerRadius(10)
                .padding(.horizontal)
                .foregroundColor(Color.black)
        }
    }


#Preview {
    LibraryView()
        .environment(WellnessManager())
}

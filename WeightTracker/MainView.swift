//
//  ContentView.swift
//  WeightTracker
//
//  Created by David Roy on 12/6/23.
//

import SwiftUI

struct MainView: View {
    @State var showDataEntrySheet = false
    
    var body: some View {
        VStack {
            Button {
                showDataEntrySheet = true
            } label: {
                Text("Record Weight")
            }
            .sheet(isPresented: $showDataEntrySheet) {
                DataEntryView()
            }
        }
        .padding()
    }
}

#Preview {
    MainView()
}

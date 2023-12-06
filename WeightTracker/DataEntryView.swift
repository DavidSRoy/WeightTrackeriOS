//
//  DataEntryView.swift
//  WeightTracker
//
//  Created by David Roy on 12/6/23.
//

import SwiftUI

struct DataEntryView: View {
    @StateObject private var viewModel = DataEntryViewModel()
    
    var body: some View {
        VStack {
            Button {
                viewModel.logWeight()
            } label: {
                Text("Log Weight")
            }
        }
        .padding()
    }
}

#Preview {
    DataEntryView()
}

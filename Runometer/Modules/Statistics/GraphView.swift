//
//  GraphView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/24/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import SwiftUI

struct ChartView: View {

    let runs = [3, 5, 4, 10, 6, 6, 7, 8, 10, 9]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(alignment: .bottom, spacing: 5) {
                ForEach(runs, id: \.self) { run in
                    Rectangle()
                        .frame(width: 30, height: CGFloat(run * 10), alignment: .bottom)
                        .cornerRadius(2)
                }
            }.foregroundColor(.red)
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}

//
//  ChartView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/24/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import SwiftUI

struct ChartData: Hashable {
    let value: Double
    let title: String
}

struct ChartDataSection: Hashable {
    let title: String?
    let data: [ChartData]
}

struct ChartView: View {

    let dataSections: [ChartDataSection]

    init(dataSections: [ChartDataSection]) {
        self.dataSections = dataSections
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .bottom, spacing: 10) {
                    ForEach(self.dataSections, id: \.self) { section in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(alignment: .bottom) {
                                ForEach(section.data, id: \.self) { data in
                                    VStack(alignment: .center, spacing: 10) {
                                        Rectangle()
                                            .frame(width: 25,
                                                   height: self.height(of: data, geometry: geometry),
                                                   alignment: .bottom)
                                            .cornerRadius(2)
                                            .foregroundColor(Color(Colors.orange))
                                        Text(data.title)
                                    }
                                }
                            }
                            if section.title != nil {
                                Text(section.title!)
                            }
                        }
                    }
                }
            }
        }
    }

    private func height(of data: ChartData, geometry: GeometryProxy) -> CGFloat {
        let allData = dataSections.flatMap { $0.data }
        guard let maxDataValue = allData.map({ $0.value }).max() else { return 0 }
        let maxHeight = CGFloat(geometry.size.height / 2)
        let heightPerUnit = maxHeight / CGFloat(maxDataValue)
        return CGFloat(data.value) * heightPerUnit
    }

}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(
            dataSections: [
                ChartDataSection(
                    title: "2019",
                    data: [
                        ChartData(value: 19, title: "Jun"),
                        ChartData(value: 22, title: "Jul"),
                        ChartData(value: 21, title: "Aug"),
                        ChartData(value: 15, title: "Sep"),
                        ChartData(value: 18, title: "Oct"),
                        ChartData(value: 14, title: "Nov"),
                        ChartData(value: 13, title: "Dec")
                    ]
                ),
                ChartDataSection(
                    title: "2020",
                    data: [
                        ChartData(value: 10, title: "Jan"),
                        ChartData(value: 13, title: "Feb"),
                        ChartData(value: 12, title: "Mar"),
                        ChartData(value: 13, title: "Apr")
                    ]
                )
            ]
        )
    }
}

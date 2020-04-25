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

struct ChartView: View {

    let data: [ChartData]

    init(data: [ChartData]) {
        self.data = data
    }

    var body: some View {
        GeometryReader { geometry in
//            Rectangle()
//                .opacity(0.3)
//                .frame(width: geometry.size.width,
//                       height: geometry.size.height / 2,
//                       alignment: .center)
//            Path(CGRect(x: 0, y: 0, width: geometry.size.width, height: 1))
//            Path(CGRect(x: 0, y: geometry.size.height / 7.5, width: geometry.size.width, height: 1))
//            Path(CGRect(x: 0, y: geometry.size.height / 4, width: geometry.size.width, height: 1))
//            Path(CGRect(x: 0, y: geometry.size.height / 2.5, width: geometry.size.width, height: 1))
//            Path(CGRect(x: 0, y: geometry.size.height / 2, width: geometry.size.width, height: 1))
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .bottom, spacing: 10) {
                    ForEach(self.data, id: \.self) { data in
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
            }
        }
    }

    private func height(of data: ChartData, geometry: GeometryProxy) -> CGFloat {
        guard let maxDataValue = self.data.map({ $0.value }).max() else { return 0 }
        let maxHeight = CGFloat(geometry.size.height / 2)
        let heightPerUnit = maxHeight / CGFloat(maxDataValue)
        return CGFloat(data.value) * heightPerUnit
    }

}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        let runs = [
            RunMock(distance: 5000, duration: 1500, startDate: Date(), endDate: Date(timeIntervalSince1970: 86400 * 1)),
            RunMock(distance: 5000, duration: 1500, startDate: Date(), endDate: Date(timeIntervalSince1970: 86400 * 60)),
            RunMock(distance: 5000, duration: 1500, startDate: Date(), endDate: Date(timeIntervalSince1970: 86400 * 60)),
            RunMock(distance: 5000, duration: 1500, startDate: Date(), endDate: Date(timeIntervalSince1970: 86400 * 60)),
            RunMock(distance: 5000, duration: 1500, startDate: Date(), endDate: Date(timeIntervalSince1970: 86400 * 60)),
            RunMock(distance: 5000, duration: 1500, startDate: Date(), endDate: Date(timeIntervalSince1970: 86400 * 120)),
            RunMock(distance: 5000, duration: 1500, startDate: Date(), endDate: Date(timeIntervalSince1970: 86400 * 120))
        ]

        return ChartView.create(from: runs, statisticType: .numberOfRuns, filter: .month)
    }
}

extension ChartView {

    static func create(from runs: [Run], statisticType: RunStatisticType, filter: StatisticsBreakdownFilter) -> ChartView {
        let statistics = StatisticsBreakdown(runs: runs).chartStatistics(of: statisticType, with: filter)
        let data = statistics.map {
            return ChartData(value: $0.value, title: $0.title)
        }
        return ChartView(data: data.reversed())
    }

}

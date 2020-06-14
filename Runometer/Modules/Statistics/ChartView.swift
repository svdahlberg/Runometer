//
//  ChartView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/24/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import SwiftUI

struct ChartModel {
    let dataSections: [ChartDataSection]
    let valueFormatter: (Double) -> String
}

struct ChartDataSection: Hashable {
    let title: String?
    let data: [ChartData]
}

struct ChartData: Hashable {
    let value: Double
    let title: String
}


struct ChartView: View {

    let chartModel: ChartModel

    init(chartModel: ChartModel) {
        self.chartModel = chartModel
    }

    var body: some View {

        let allData = chartModel.dataSections.flatMap { $0.data }
        let maxDataValue = allData.map { $0.value }.max() ?? 0
        let maxGridLineValue = maxDataValue.roundedUp()

        func maxBarHeight(chartHeight: CGFloat) -> CGFloat {
            CGFloat(maxDataValue / maxGridLineValue) * chartHeight
        }

        return GeometryReader { geometry in

            ZStack(alignment: .top) {
                
                GridLines(maxDataValue: maxGridLineValue,
                          valueFormatter: self.chartModel.valueFormatter)
                    .frame(height: geometry.size.height)

                HStack {
                    ScrollView(.horizontal, showsIndicators: true) {

                        BarChart(dataSections: self.chartModel.dataSections,
                                 maxHeight: maxBarHeight(chartHeight: geometry.size.height),
                                 maxDataValue: maxDataValue)
                            .padding([.leading, .trailing], 16)
                    }
                    .frame(width: geometry.size.width - 50)
                    .offset(y: geometry.size.height - maxBarHeight(chartHeight: geometry.size.height))

                    Spacer()
                }
            }
        }
    }

}


private extension Double {

    func roundedUp() -> Self {

        var value: Double = 1
        while Int(self) % Int(value) != Int(self) {
            value *= 10
        }
        value /= 10
        return (self / value).rounded(.up) * value
    }

}


private struct GridLines: View {

    let maxDataValue: Double
    let valueFormatter: (Double) -> String

    private let numberOfLines = 5

    var body: some View {

        let linesRange = 0..<numberOfLines
        let lineTitles = self.lineTitles(for: linesRange)

        return GeometryReader { geometry in
            Group {
                ForEach(linesRange) { lineIndex in
                    Group {

                        Path { path in
                            let y = self.yValue(for: lineIndex, maxY: geometry.size.height)
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }.stroke(lineIndex == self.numberOfLines - 1 ? Color.primary : Color.secondary)

                        HStack {
                            Spacer()
                            Text(lineTitles[lineIndex])
                                .frame(width: 50)
                        }.offset(y: self.yValue(for: lineIndex, maxY: geometry.size.height))

                    }
                }

                Path { path in
                    let x = geometry.size.width - 50
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }.stroke(Color.primary)
            }
        }
    }

    private func lineTitles(for linesRange: Range<Int>) -> [String] {
        linesRange.reversed().map { lineIndex in
            let value = yValue(for: lineIndex, maxY: CGFloat(maxDataValue))
            return "\(valueFormatter(Double(value)))"
        }
    }

    private func yValue(for lineIndex: Int, maxY: CGFloat) -> CGFloat {
        maxY * CGFloat(lineIndex) / CGFloat(numberOfLines - 1)
    }

}


private struct BarChart: View {

    let dataSections: [ChartDataSection]
    let maxHeight: CGFloat
    let maxDataValue: Double

    var body: some View {
        HStack(alignment: .bottom) { // sections
            ForEach(self.dataSections, id: \.self) { section in
                VStack(alignment: .leading, spacing: 5) { // bars + section title
                    HStack(alignment: .bottom) { // bars
                        ForEach(section.data, id: \.self) { data in
                            Bar(
                                data: data,
                                maxDataValue: self.maxDataValue,
                                maxHeight: self.maxHeight
                            )
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

private struct Bar: View {

    let data: ChartData
    let maxDataValue: Double
    let maxHeight: CGFloat

    private var height: CGFloat {
        let heightPerUnit = maxHeight / CGFloat(maxDataValue)
        return CGFloat(data.value) * heightPerUnit
    }

    var body: some View {
        VStack(alignment: .center) {
            Rectangle()
                .frame(width: 25,
                       height: height,
                       alignment: .bottom)
                .cornerRadius(6)
                .foregroundColor(Color(Colors.orange))
            Text(data.title)
        }
    }

}


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(
            chartModel: ChartModel(
                dataSections: [
                    ChartDataSection(
                        title: "2019",
                        data: [
                            ChartData(value: 19000, title: "Jun"),
                            ChartData(value: 22500, title: "Jul"),
                            ChartData(value: 3000, title: "Aug"),
                            ChartData(value: 15000, title: "Sep"),
                            ChartData(value: 10000, title: "Oct"),
                            ChartData(value: 14000, title: "Nov"),
                            ChartData(value: 13000, title: "Dec")
                        ]
                    ),
                    ChartDataSection(
                        title: "2020",
                        data: [
                            ChartData(value: 10000, title: "Jan"),
                            ChartData(value: 13000, title: "Feb"),
                            ChartData(value: 12000, title: "Mar"),
                            ChartData(value: 13000, title: "Apr"),
                            ChartData(value: 10000, title: "May"),
                            ChartData(value: 15000, title: "Jun")
                        ]
                    )
                ],
                valueFormatter: { value in
                    DistanceFormatter.format(distance: value)!
                }
            )
        ).frame(height: 300)
    }
}

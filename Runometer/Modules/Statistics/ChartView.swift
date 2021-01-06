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

struct ChartDataSection: Hashable, Identifiable {
    let id = UUID()
    let title: String?
    let data: [ChartData]
}

struct ChartData: Hashable, Identifiable {
    let id = UUID()
    let value: Double
    let title: String
}


struct ChartView: View {

    let chartModel: ChartModel

    @State private var selectedData: ChartData?
    @State private var selectedBarPosition: (x: CGFloat, y: CGFloat)?

    var body: some View {

        let allData = chartModel.dataSections.flatMap { $0.data }
        let maxDataValue = allData.map { $0.value }.max() ?? 0

        return GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: true) {
                ScrollViewReader { value in
                    BarChart(
                        dataSections: self.chartModel.dataSections,
                        maxHeight: geometry.size.height,
                        maxDataValue: maxDataValue,
                        selectedData: $selectedData,
                        selectedBarPosition: $selectedBarPosition
                    )
                    .padding(16)
                    .onAppear {
                        value.scrollTo(self.chartModel.dataSections.last?.data.last?.id)
                    }
                }
            }
            .frame(height: geometry.size.height + 54 + 32)
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .gesture(
                DragGesture()
                    .onChanged{ _ in
                        resetSelection()
                    }
            )
            .onTapGesture {
                resetSelection()
            }

            if let selectedData = selectedData, let selectedBarPosition = selectedBarPosition {
                ValueLabel(
                    valueFormatter: chartModel.valueFormatter,
                    selectedData: selectedData,
                    selectedBarPosition: selectedBarPosition
                )
            }
        }
    }

    private func resetSelection() {
        selectedData = nil
        selectedBarPosition = nil
    }

}

private struct ValueLabel: View {

    let valueFormatter: (Double) -> String
    let selectedData: ChartData
    let selectedBarPosition: (x: CGFloat, y: CGFloat)

    var body: some View {
        Text(valueFormatter(selectedData.value))
            .padding(.all, 10)
            .transition(
                AnyTransition.opacity
                    .animation(.easeInOut(duration: 0.2))
            )
            .background(
                Color.white
                    .opacity(0.2)
                    .cornerRadius(7)
            )
            .position(x: selectedBarPosition.x, y: selectedBarPosition.y - 20)
    }

}

private struct BarChart: View {

    let dataSections: [ChartDataSection]
    let maxHeight: CGFloat
    let maxDataValue: Double
    @Binding var selectedData: ChartData?
    @Binding var selectedBarPosition: (x: CGFloat, y: CGFloat)?

    var body: some View {
        HStack(alignment: .bottom) { // TODO: make LazyHStack?
            ForEach(self.dataSections) { section in
                Section(
                    section: section,
                    maxHeight: self.maxHeight,
                    maxDataValue: self.maxDataValue,
                    selectedData: $selectedData,
                    selectedBarPosition: $selectedBarPosition
                )
            }
        }
    }

}

private struct Section: View {

    let section: ChartDataSection
    let maxHeight: CGFloat
    let maxDataValue: Double
    @Binding var selectedData: ChartData?
    @Binding var selectedBarPosition: (x: CGFloat, y: CGFloat)?

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .bottom) {
                ForEach(section.data) { data in
                    Bar(
                        data: data,
                        maxDataValue: self.maxDataValue,
                        maxHeight: self.maxHeight,
                        selectedData: $selectedData,
                        selectedBarPosition: $selectedBarPosition
                    )
                    .id(data.id)
                }
            }
            if let title = section.title {
                Text(title)
                    .font(.title2)
            }
        }
    }
}

private struct Bar: View {

    let data: ChartData
    let maxDataValue: Double
    let maxHeight: CGFloat
    @Binding var selectedData: ChartData?
    @Binding var selectedBarPosition: (x: CGFloat, y: CGFloat)?

    private let width: CGFloat = 25
    private var isHighlighted: Bool { selectedData == data }
    private var scale: CGFloat { isHighlighted ? 1.02 : 1 }
    private var color: Color { isHighlighted ? .red : Color(Colors.orange) }

    private var height: CGFloat {
        let heightPerUnit = maxHeight / CGFloat(maxDataValue)
        return CGFloat(data.value) * heightPerUnit
    }

    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { geometry in
                Capsule(style: .continuous)
                    .foregroundColor(color)
                    .scaleEffect(scale, anchor: .bottom)
                    .animation(.easeInOut)
                    .onTapGesture {
                        guard selectedData != data else {
                            selectedData = nil
                            selectedBarPosition = nil
                            return
                        }

                        selectedData = data
                        selectedBarPosition = isHighlighted ? (
                            x: geometry.frame(in: .global).midX - (width / 2),
                            y: maxHeight - height
                        ) : nil
                    }
            }
            .frame(
                width: width,
                height: height,
                alignment: .bottom
            )

            Text(data.title)
                .font(.subheadline)
        }
    }

}


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChartView(
                chartModel: ChartModel(
                    dataSections: [
                        ChartDataSection(
                            title: "2019",
                            data: [
                                ChartData(value: 10000, title: "Jan"),
                                ChartData(value: 13000, title: "Feb"),
                                ChartData(value: 12000, title: "Mar"),
                                ChartData(value: 13000, title: "Apr"),
                                ChartData(value: 10000, title: "May"),
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
                                ChartData(value: 15000, title: "Jun"),
                                ChartData(value: 22500, title: "Jul"),
                                ChartData(value: 3000, title: "Aug"),
                                ChartData(value: 15000, title: "Sep"),
                                ChartData(value: 10000, title: "Oct"),
                                ChartData(value: 14000, title: "Nov"),
                                ChartData(value: 13000, title: "Dec")
                            ]
                        )
                    ],
                    valueFormatter: { value in
                        DistanceFormatter.format(distance: value)! + " km"
                    }
                )
            ).preferredColorScheme(.dark).padding(.horizontal).frame(height: 300)
        }
    }
}

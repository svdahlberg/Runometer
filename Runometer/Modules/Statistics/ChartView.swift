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
    let pagingEnabled: Bool = true
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

private class ChartViewModel: ObservableObject {

    @Published var selectedData: ChartData?
    @Published var selectedBarPosition: (x: CGFloat, y: CGFloat)?

    func reset() {
        selectedData = nil
        selectedBarPosition = nil
    }

}

struct ChartView: View {

    let chartModel: ChartModel

    @ObservedObject private var viewModel = ChartViewModel()

    var body: some View {
        GeometryReader { geometry in
            BarChart(
                dataSections: chartModel.dataSections,
                pageWidth: geometry.size.width - 16,
                maxHeight: geometry.size.height,
                paged: chartModel.pagingEnabled,
                viewModel: viewModel,
                selectedSection: chartModel.dataSections.last?.title
            )
            .frame(height: geometry.size.height + 54 + 32)
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        viewModel.reset()
                    }
            )

            if let selectedData = viewModel.selectedData, let selectedBarPosition = viewModel.selectedBarPosition {
                ValueLabel(
                    valueFormatter: chartModel.valueFormatter,
                    selectedData: selectedData,
                    selectedBarPosition: selectedBarPosition
                )
            }
        }
    }

}

private struct ValueLabel: View {

    let valueFormatter: (Double) -> String
    let selectedData: ChartData
    let selectedBarPosition: (x: CGFloat, y: CGFloat)

    var body: some View {
        VStack {
            Text(selectedData.title)
            Text(valueFormatter(selectedData.value))
        }
        .padding(10)
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
    let pageWidth: CGFloat
    let maxHeight: CGFloat
    let paged: Bool
    @ObservedObject var viewModel: ChartViewModel
    @State var selectedSection: String?

    private func maxDataValue() -> Double {
        let allData = dataSections.flatMap { $0.data }
        return allData.map { $0.value }.max() ?? 0
    }

    private func maxDataValue(for section: ChartDataSection) -> Double {
        section.data.map { $0.value }.max() ?? 0
    }

    var body: some View {
        if paged {
            TabView(selection: $selectedSection) {
                ForEach(dataSections) { section in
                    Section(
                        section: section,
                        width: pageWidth,
                        maxHeight: maxHeight,
                        maxDataValue: maxDataValue(for: section),
                        viewModel: viewModel
                    )
                    .tag(section.title)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

        } else {
            ScrollView(.horizontal, showsIndicators: true) {
                ScrollViewReader { value in
                    HStack(alignment: .bottom) { // TODO: make LazyHStack?
                        ForEach(dataSections) { section in
                            Section(
                                section: section,
                                width: pageWidth,
                                maxHeight: maxHeight,
                                maxDataValue: maxDataValue(),
                                viewModel: viewModel
                            )
                        }
                    }
                    .padding(16)
                    .onAppear {
                        value.scrollTo(self.dataSections.last?.data.last?.id)
                    }
                }
            }
        }
    }

}

private struct Section: View {

    let section: ChartDataSection
    let width: CGFloat
    let maxHeight: CGFloat
    let maxDataValue: Double
    @ObservedObject var viewModel: ChartViewModel

    private var barSpacing: CGFloat { 10 }

    private var barWidth: CGFloat {
        let numberOfBars = CGFloat(section.data.count)
        let totalSpacing = barSpacing * numberOfBars - 1
        return (width - totalSpacing) / numberOfBars
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .bottom, spacing: barSpacing) {
                ForEach(section.data) { data in
                    Bar(
                        data: data,
                        maxDataValue: self.maxDataValue,
                        width: barWidth,
                        maxHeight: self.maxHeight,
                        viewModel: viewModel
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
    let width: CGFloat
    let maxHeight: CGFloat
    @ObservedObject var viewModel: ChartViewModel

    private var isHighlighted: Bool { data == viewModel.selectedData }
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
                        guard !isHighlighted else {
                            viewModel.reset()
                            return
                        }

                        viewModel.selectedData = data
                        viewModel.selectedBarPosition = (
                            x: geometry.frame(in: .global).midX - (width / 2),
                            y: maxHeight - height
                        )
                    }
            }

            Text(String(data.title.first!))
                .font(.subheadline)
                .lineLimit(1)
        }
        .frame(
            width: width,
            height: height,
            alignment: .bottom
        )
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
                                ChartData(value: 30000, title: "Jan"),
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
                                ChartData(value: 25500, title: "Jul"),
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

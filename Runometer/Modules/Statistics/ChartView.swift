//
//  ChartView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/24/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct ChartModel {
    let dataSections: [ChartDataSection]
    let valueFormatter: (Double) -> String
    let pagingEnabled: Bool
}

@available(iOS 14.0, *)
struct ChartDataSection: Hashable, Identifiable {
    let id = UUID()
    let title: String?
    let data: [ChartData]
}

@available(iOS 14.0, *)
struct ChartData: Hashable, Identifiable {
    let id = UUID()
    let value: Double
    let title: String
    let shortTitle: String

    init(value: Double, title: String, shortTitle: String = "") {
        self.value = value
        self.title = title
        self.shortTitle = shortTitle.isEmpty ? title : shortTitle
    }
}

@available(iOS 14.0, *)
private class ChartViewModel: ObservableObject {

    @Published var selectedData: ChartData?
    @Published var selectedBarPosition: (x: CGFloat, y: CGFloat)?
    @Published var maxDataValue: Double?
    var canChangeMaxDataValue = true

    func reset() {
        selectedData = nil
        selectedBarPosition = nil
    }

}

@available(iOS 14.0, *)
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
            .frame(height: geometry.size.height + 54)
            .background(Color(Colors.secondaryBackground))
            .cornerRadius(10)
            .gesture(DragGesture().onChanged { _ in
                viewModel.reset()
            })

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

@available(iOS 14.0, *)
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
            Color(.lightGray)
                .opacity(0.2)
                .cornerRadius(7)
        )
        .position(x: selectedBarPosition.x, y: selectedBarPosition.y)
    }

}

@available(iOS 14.0, *)
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

    private let barSpacing: CGFloat = 5
    private let maxBarWidth: CGFloat = 50

    private func barWidth(for section: ChartDataSection) -> CGFloat {
        let numberOfBars = CGFloat(section.data.count)
        guard numberOfBars != 0 else {
            return maxBarWidth
        }
        let totalSpacing = barSpacing * numberOfBars - 1
        return min((pageWidth - totalSpacing) / numberOfBars, maxBarWidth)
    }

    var body: some View {
        if paged {
            TabView(selection: $selectedSection) {
                ForEach(dataSections) { section in
                    Section(
                        section: section,
                        barWidth: barWidth(for: section),
                        barSpacing: barSpacing,
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
                    HStack(alignment: .bottom) {
                        ForEach(dataSections) { section in
                            Section(
                                section: section,
                                barWidth: 35,
                                barSpacing: barSpacing,
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

@available(iOS 14.0, *)
private struct Section: View {

    let section: ChartDataSection
    let barWidth: CGFloat
    let barSpacing: CGFloat
    let maxHeight: CGFloat
    let maxDataValue: Double
    @ObservedObject var viewModel: ChartViewModel

    private let padding = EdgeInsets(top: 16, leading: 10, bottom: 16, trailing: 10)

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .bottom, spacing: barSpacing) {
                ForEach(section.data) { data in
                    Bar(
                        title: data.shortTitle,
                        data: data,
                        maxDataValue: maxDataValue,
                        width: barWidth,
                        maxHeight: maxHeight - (padding.top + padding.bottom + 20),
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
        .padding(padding)
        .onAppear {
            if viewModel.maxDataValue != maxDataValue, viewModel.canChangeMaxDataValue {
                viewModel.canChangeMaxDataValue = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    viewModel.maxDataValue = maxDataValue
                    viewModel.canChangeMaxDataValue = true
                }
            }
        }
    }

}

@available(iOS 14.0, *)
private struct Bar: View {

    let title: String
    let data: ChartData
    let maxDataValue: Double
    let width: CGFloat
    let maxHeight: CGFloat
    @ObservedObject var viewModel: ChartViewModel

    private var isHighlighted: Bool { data == viewModel.selectedData }
    private var scale: CGFloat { isHighlighted ? 1.02 : 1 }
    private var color: Color { isHighlighted ? .red : Color(Colors.orange) }

    private var height: CGFloat {
        guard let maxDataValue = viewModel.maxDataValue, data.value > 0 else {
            return 0
        }

        let heightPerUnit = maxHeight / max(CGFloat(maxDataValue), 1)
        return min(CGFloat(max(data.value, 1)) * heightPerUnit, maxHeight)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
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
                    .frame(
                        width: width,
                        height: height
                    )

                Text(title)
                    .font(.subheadline)
                    .lineLimit(1)
            }
        }
        .frame(
            width: width
        )
    }

}

@available(iOS 14.0, *)
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
                                ChartData(value: 50000, title: "Aug"),
                                ChartData(value: 15000, title: "Sep"),
                                ChartData(value: 10000, title: "Oct"),
                                ChartData(value: 14000, title: "Nov"),
                                ChartData(value: 13000, title: "Dec")
                            ]
                        ),
//                        ChartDataSection(
//                            title: "2021",
//                            data: [
//                                ChartData(value: 10000, title: "1"),
//                                ChartData(value: 13000, title: "2"),
//                                ChartData(value: 12000, title: "3"),
//                                ChartData(value: 13000, title: "4"),
//                                ChartData(value: 10000, title: "5"),
//                                ChartData(value: 15000, title: "6"),
//                                ChartData(value: 25500, title: "7"),
//                                ChartData(value: 3000, title: "8"),
//                                ChartData(value: 15000, title: "9"),
//                                ChartData(value: 10000, title: "10"),
//                                ChartData(value: 14000, title: "11"),
//                                ChartData(value: 13000, title: "12"),
//                                ChartData(value: 10000, title: "13"),
//                                ChartData(value: 13000, title: "14"),
//                                ChartData(value: 12000, title: "15"),
//                                ChartData(value: 13000, title: "16"),
//                                ChartData(value: 10000, title: "17"),
//                                ChartData(value: 15000, title: "18"),
//                                ChartData(value: 25500, title: "18"),
//                                ChartData(value: 3000, title: "19"),
//                                ChartData(value: 15000, title: "20"),
//                                ChartData(value: 10000, title: "21"),
//                                ChartData(value: 13000, title: "22"),
//                                ChartData(value: 12000, title: "23"),
//                                ChartData(value: 13000, title: "24"),
//                                ChartData(value: 10000, title: "25"),
//                                ChartData(value: 15000, title: "26"),
//                                ChartData(value: 25500, title: "27"),
//                                ChartData(value: 20000, title: "28"),
//                                ChartData(value: 15000, title: "29"),
//                                ChartData(value: 10000, title: "30"),
//                                ChartData(value: 10000, title: "31"),
//                                ChartData(value: 13000, title: "32"),
//                                ChartData(value: 12000, title: "33"),
//                                ChartData(value: 13000, title: "34"),
//                                ChartData(value: 10000, title: "35"),
//                                ChartData(value: 15000, title: "36"),
//                                ChartData(value: 25500, title: "37"),
//                                ChartData(value: 20000, title: "38"),
//                                ChartData(value: 15000, title: "39"),
//                                ChartData(value: 10000, title: "40"),
//                                ChartData(value: 10000, title: "41"),
//                                ChartData(value: 13000, title: "42"),
//                                ChartData(value: 12000, title: "43"),
//                                ChartData(value: 13000, title: "44"),
//                                ChartData(value: 10000, title: "45"),
//                                ChartData(value: 15000, title: "46"),
//                                ChartData(value: 25500, title: "47"),
//                                ChartData(value: 20000, title: "48"),
//                                ChartData(value: 15000, title: "49"),
//                                ChartData(value: 25500, title: "50"),
//                                ChartData(value: 20000, title: "51"),
//                                ChartData(value: 15000, title: "52")
//                            ]
//                        )
                    ],
                    valueFormatter: { value in
                        DistanceFormatter.format(distance: value)! + " km"
                    },
                    pagingEnabled: true
                )
            ).preferredColorScheme(.dark).padding(.horizontal).frame(height: 300)
        }
    }
}

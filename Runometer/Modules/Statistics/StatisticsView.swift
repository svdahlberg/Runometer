//
//  StatisticsView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 1/29/22.
//  Copyright © 2022 Svante Dahlberg. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {

    @Namespace var namespace

    @ObservedObject private var viewModel = StatisticsViewModel()

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    @State private var isShowingFiltersSheet = false
    @State private var isShowingStatisticDetail = false

    var body: some View {

        ZStack {
            Color(Colors.background)
                .ignoresSafeArea()

            if isShowingStatisticDetail, let selectedStatistic = viewModel.selectedStatistic {

                StatisticDetailView(
                    viewModel: StatisticDetailViewModel(
                        runStatistic: selectedStatistic,
                        runs: viewModel.selectedRunStatisticFilter?.runs ?? []
                    ),
                    isShowing: $isShowingStatisticDetail,
                    namespace: namespace
                )
                .zIndex(100)


            } else {
                ScrollView {

                    if let filter = viewModel.selectedRunStatisticFilter {
                        Button {
                            isShowingFiltersSheet.toggle()
                        } label: {
                            HStack(spacing: 4) {
                                Text("Show statistics for")
                                Text("\(filter.name)")
                                    .fontWeight(.bold)
                                Image(systemName: "chevron.down.circle")
                            }
                            .foregroundColor(Color(Colors.orange))
                        }.sheet(isPresented: $isShowingFiltersSheet) {
                            StatisticsFiltersView(viewModel: viewModel)
                        }
                    }

                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.runStatistics) { runStatistic in
                            Button(action: {
                                viewModel.selectedStatistic = runStatistic
                                withAnimation() {
                                    isShowingStatisticDetail = true
                                }
                            }) {
                                StatisticView(runStatistic: runStatistic, namespace: namespace)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 80)
                                    .padding()
                                    .background(
                                        Color(Colors.secondaryBackground)
                                            .matchedGeometryEffect(id: "\(runStatistic.id)-background", in: namespace)
                                    )
                                    .mask {
                                        RoundedRectangle(cornerRadius: 13)
                                            .matchedGeometryEffect(id: "\(runStatistic.id)-mask", in: namespace)
                                    }
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Statistics")
    }
}

struct StatisticsFiltersView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: StatisticsViewModel

    var body: some View {
        VStack {
            Text("Show statistics for ...")
                .fontWeight(.bold)
                .padding()
            List {
                ForEach(viewModel.runStatisticFilters) { filter in
                    Button(filter.name.firstLetterCapitalized()) {
                        viewModel.selectedRunStatisticFilter = filter
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct StatisticView: View {

    let runStatistic: RunStatistic
    let namespace: Namespace.ID

    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(runStatistic.formattedValue ?? "")
                    .font(.title)
                    .fontWeight(.heavy)
                    .matchedGeometryEffect(id: "\(runStatistic.id)-\(runStatistic.value)", in: namespace)
                Text(runStatistic.unitSymbol)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .matchedGeometryEffect(id: "\(runStatistic.id)-\(runStatistic.unitSymbol)", in: namespace)
            }
            Text(runStatistic.title)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(Color(Colors.orange))
                .matchedGeometryEffect(id: runStatistic.title, in: namespace)
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {

    let amount: CGFloat

    init(amount: CGFloat = 0.95) {
        self.amount = amount
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? amount : 1)
    }

}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticsView()
//                .colorScheme(.dark)

        }
    }
}

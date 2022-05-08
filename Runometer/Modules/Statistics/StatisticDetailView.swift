//
//  StatisticDetailView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 1/23/22.
//  Copyright © 2022 Svante Dahlberg. All rights reserved.
//

import SwiftUI
import CoreLocation
import DependencyContainer

struct StatisticDetailView: View {

    @ObservedObject var viewModel: StatisticDetailViewModel
    @Binding var isShowing: Bool
    let namespace: Namespace.ID
    @State private var isShowingDetailContent = false

    private var runStatistic: RunStatistic {
        viewModel.runStatistic
    }

    var body: some View {

        ZStack {

            Color(Colors.secondaryBackground)
                .matchedGeometryEffect(id: "\(runStatistic.id)-background", in: namespace)
                .mask {
                    RoundedRectangle(cornerRadius: 30)
                        .matchedGeometryEffect(id: "\(runStatistic.id)-mask", in: namespace)
                }
                .ignoresSafeArea()

            ScrollView {

                VStack {
                    StatisticView(runStatistic: runStatistic, namespace: namespace)
                        .frame(minWidth: 0, maxWidth: .infinity)
                    Spacer()
                }
                .padding()

                if isShowingDetailContent {

                    VStack(spacing: 40) {
                        Picker("Filter", selection: $viewModel.selectedFilter) {
                            ForEach([StatisticsBreakdownFilter.week, StatisticsBreakdownFilter.month, StatisticsBreakdownFilter.year, StatisticsBreakdownFilter.allTime]) { filter in
                                Text(filter.title)
                            }
                        }
                        .pickerStyle(.segmented)

                        ChartView(chartModel: viewModel.chartModel)
                            .frame(height: 300)
                            .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 50, trailing: 0))

                        NavigationLink {
                            RunsView(runs: viewModel.runs)
                                .navigationTitle("Runs")
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            HStack {
                                Text("\(viewModel.runs.count) runs")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color(Colors.tertiaryBackground))
                            .cornerRadius(13)
                        }
                        .foregroundColor(Color(Colors.text))
                    }
                    .padding()
                    .transition(.opacity.combined(with: .offset(x: 0, y: 50)))
                    
                }
            }

            Button {
                withAnimation {
                    isShowing = false
                    isShowingDetailContent = false
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.body.bold())
                    .foregroundColor(Color(Colors.text))
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
        .navigationTitle(runStatistic.title) // For the run list view back button


        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation() {
                    isShowingDetailContent = true
                }
            }
        }
    }
}

struct RunModel: Identifiable, Run {
    let id = UUID()
    let distance: Meters
    let duration: Seconds
    let startDate: Date
    let endDate: Date
    let run: Run

    func locationSegments(completion: @escaping ([[CLLocation]]) -> Void) {
        run.locationSegments(completion: completion)
    }

    static func runModels(from runs: [Run]) -> [RunModel] {
        runs.map { run in
            RunModel(
                distance: run.distance,
                duration: run.duration,
                startDate: run.startDate,
                endDate: run.endDate,
                run: run
            )
        }
    }
}

struct RunListView: View {

    let runs: [RunModel]

    var body: some View {
        List {
            ForEach(runs) { run in
                NavigationLink {
                    RunDetailsView(run: run)
                } label: {
                    Text("\(run.distance)")
                }
            }
        }
        .navigationTitle("Runs")
    }
}

struct RunsView: UIViewControllerRepresentable {

    let runs: [Run]

    struct RunProvider: RunProviding {
        let runs: [Run]
        func runs(filter: RunFilter?, completion: @escaping ([Run]) -> Void) {
            completion(runs)
        }
    }

    func makeUIViewController(context: Context) -> PastRunsViewControlller {
        guard let viewController = UIStoryboard(name: "PastRuns", bundle: Bundle.main).instantiateViewController(withIdentifier: "PastRunsViewController") as? PastRunsViewControlller else {
            fatalError()
        }

        let container = DependencyContainer()
        container.register(RunProviding.self, resolver: { RunProvider(runs: runs) })
        viewController.runRepository = RunRepository(container: container)
        return viewController
    }

    func updateUIViewController(_ uiViewController: PastRunsViewControlller, context: Context) {}
}

struct RunDetailsView: UIViewControllerRepresentable {

    let run: Run

    func makeUIViewController(context: Context) -> RunDetailsViewController {
        guard let viewController = UIStoryboard(name: "RunDetails", bundle: Bundle.main).instantiateViewController(withIdentifier: "RunDetailsViewController") as? RunDetailsViewController else {
            fatalError()
        }

        viewController.run = run
        viewController.navigationItem.title = "Run Details"
        return viewController
    }

    func updateUIViewController(_ uiViewController: RunDetailsViewController, context: Context) {}
}

struct StatisticDetailView_Previews: PreviewProvider {

    @Namespace static var namespace

    static var previews: some View {
        StatisticDetailView(
            viewModel: StatisticDetailViewModel(
                runStatistic: RunStatistic(value: 4, title: "Number of Runs", date: Date(), unitType: .count, type: .numberOfRuns),
                runs: MockRunProvider().runs
            ),
            isShowing: .constant(true),
            namespace: namespace
        )
            .preferredColorScheme(.dark)
    }
}

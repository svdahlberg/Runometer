//
//  RunStatisticWidget.swift
//  RunStatisticWidget
//
//  Created by Svante Dahlberg on 11/26/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    func placeholder(in context: Context) -> RunStatisticEntry {
        let runStatistic = RunStatistic(value: 0, title: "", unitType: .distance, type: .totalDistance)
        return RunStatisticEntry(date: Date(), runStatistic: runStatistic, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (RunStatisticEntry) -> ()) {

        let runStatisticType = configuration.runStatisticType.toRunStatisticType()
        let filter = configuration.filter.toRunFilter()

        RunRepository().runs(filter: filter) { runs in
            if let runStatistic = Statistics(runs: runs).statistic(of: runStatisticType) {
                completion(
                    RunStatisticEntry(
                        date: Date(),
                        runStatistic: runStatistic,
                        configuration: configuration
                    )
                )
            }
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        getSnapshot(for: configuration, in: context) { entry in
            completion(Timeline(entries: [entry], policy: .never))
        }
    }

}

struct RunStatisticEntry: TimelineEntry {
    let date: Date
    let runStatistic: RunStatistic
    let configuration: ConfigurationIntent
}

extension Filter {

    var displayName: String {
        switch self {
        case .week:
            return "week"
        case .month:
            return "month"
        case .year:
            return "year"
        case .unknown:
            return "unknown"
        }
    }

    func toRunFilter() -> RunFilter {
        switch self {
        case .week:
            return RunFilter(startDate: Date().startOfWeek, endDate: Date())
        case .month:
            return RunFilter(startDate: Date().startOfMonth, endDate: Date())
        case .year:
            return RunFilter(startDate: Date().startOfYear, endDate: Date())
        case .unknown:
            return RunFilter(startDate: nil, endDate: nil)
        }
    }
}

extension RunStatisticIntentType {

    func toRunStatisticType() -> RunStatisticType {
        switch self {
        case .numberOfRuns:
            return .numberOfRuns
        case .totalDistance:
            return .totalDistance
        case .averageDistance:
            return .averageDistance
        case .totalDuration:
            return .totalDuration
        case .longestDistance:
            return .longestDistance
        case .fastestPace:
            return .fastestPace
        case .averagePace:
            return .averagePace
        case .unknown:
            return .totalDistance
        }
    }
}

struct RunStatisticWidgetEntryView : View {

    var entry: RunStatisticEntry

    var body: some View {
        VStack {
            Text("This \(entry.configuration.filter.displayName)")
                .font(.subheadline)
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(entry.runStatistic.formattedValue ?? "")
                    .font(.system(size: 47))
                    .fontWeight(.heavy)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(entry.runStatistic.unitSymbol)

            }
            Text(entry.runStatistic.title)
                .foregroundColor(.orange)
        }
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
    }
}

@main
struct RunStatisticWidget: Widget {
    let kind: String = "RunStatisticWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            RunStatisticWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Runometer Widget")
        .description("Track your runs from the home screen!")
    }
}

struct RunStatisticWidget_Previews: PreviewProvider {
    static var previews: some View {
        RunStatisticWidgetEntryView(entry: RunStatisticEntry(date: Date(), runStatistic: Statistics(runs: RunMock.runsMock).totalDistance(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

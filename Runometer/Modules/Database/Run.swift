//
//  Run.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-06.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import CoreLocation

protocol Run {
    var distance: Meters { get }
    var duration: Seconds { get }
    var startDate: Date { get }
    var endDate: Date { get }
    func locationSegments() -> [[CLLocation]]?
}

extension Run {
    
    
    
    func coordinateSegments() -> [[CLLocationCoordinate2D]]? {
        return locationSegments()?.map {
            $0.map { CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) }
        }
    }
    
    func flattenedCoordinateSegments() -> [CLLocationCoordinate2D]? {
        guard let segments = coordinateSegments() else { return nil }
        return segments.flatMap { $0 }
    }
    
    func reachedCheckpoints(distanceUnit: DistanceUnit = Settings().distanceUnit) -> [Checkpoint]? {
        guard let locationSegments = locationSegments(),
            let startTime = locationSegments.first?.first?.timestamp
            else { return nil }
        
        var checkpoints = [Checkpoint]()
        var distance: Meters = 0
        var nextCheckpoint = distanceUnit.meters
        var timeAtLastCheckpoint = startTime
        
        for locations in locationSegments {
            for (firstLocation, secondLocation) in zip(locations, locations.dropFirst()) {
                distance += secondLocation.distance(from: firstLocation)
                if distance >= nextCheckpoint {
                    let time = Seconds(secondLocation.timestamp.timeIntervalSince(startTime))
                    let timeSinceLastCheckpoint = Seconds(secondLocation.timestamp.timeIntervalSince(timeAtLastCheckpoint))
                    let checkpoint = Checkpoint(distance: distance, time: time, location: secondLocation, timeSinceLastCheckpoint: timeSinceLastCheckpoint, distanceBetweenCheckpoints: distanceUnit.meters)
                    nextCheckpoint += distanceUnit.meters
                    timeAtLastCheckpoint = secondLocation.timestamp
                    checkpoints.append(checkpoint)
                }
            }
        }
        
        return checkpoints
    }
    
    func startAnnotation() -> StartAnnotation? {
        guard let firstLocation = locationSegments()?.first?.first else { return nil }
        return StartAnnotation(coordinate: firstLocation.coordinate)
    }
    
    func endAnnotation() -> EndAnnotation? {
        guard let lastLocation = locationSegments()?.last?.last else { return nil }
        return EndAnnotation(coordinate: lastLocation.coordinate)
    }
    
    func splitTimes(distanceUnit: DistanceUnit = Settings().distanceUnit, speedUnit: SpeedUnit = Settings().speedUnit) -> [String]? {
        return reachedCheckpoints(distanceUnit: distanceUnit)?.compactMap {
            PaceFormatter.pace(fromDistance: $0.distanceBetweenCheckpoints, time: $0.timeSinceLastCheckpoint, outputUnit: speedUnit)
        }
    }
    
    func averagePace(speedUnit: SpeedUnit = Settings().speedUnit) -> Seconds {
        return PaceCalculator.pace(fromDistance: distance, time: Seconds(duration), outputUnit: speedUnit)
    }
    
    func similarRunsRange(distanceUnit: DistanceUnit = Settings().distanceUnit) -> ClosedRange<Meters> {
        let roundedDistance = Meters(distance.number(of: distanceUnit)) * distanceUnit.meters
        let lowerBound = max(roundedDistance - distanceUnit.meters, 0)
        var upperBound = roundedDistance + distanceUnit.meters
        if lowerBound == 0 {
            upperBound += distanceUnit.meters - roundedDistance
        }
        
        return  lowerBound...upperBound
    }
    
}

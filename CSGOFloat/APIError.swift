//
//  APIError.swift
//  CSGOFloat
//
//  Created by Tomás Feitoza Martins  on 31/08/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation

public enum APIError {
    case parameterStructure
    case invalidInspectLink
    case maxPendingRequests
    case serverTimeout
    case serverUnavailable
    case unknownError
    
    static func errorWithCode(code: Int) -> APIError {
        switch code {
        case 1:
            return .parameterStructure
        case 2:
            return .invalidInspectLink
        case 3:
            return .maxPendingRequests
        case 4:
            return .serverTimeout
        case 5:
            return .serverUnavailable
        default:
            return .unknownError
        }
    }
    
    public var message: String {
        switch self {
        case .parameterStructure:
            return "Improper Parameter Structure"
        case .invalidInspectLink:
            return "Invalid Inspect Link Structure"
        case .maxPendingRequests:
            return "You may only have X pending request(s) at a time"
        case .serverTimeout:
            return "Valve's servers didn't reply in time"
        case .serverUnavailable:
            return "Valve's servers appear to be offline, please try again later!"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}

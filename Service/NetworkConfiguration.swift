//
//  NetworkConfiguration.swift
//  Tapptic
//
//  Created by Lilian on 23/01/2019.
//  Copyright © 2019 Lilian. All rights reserved.
//

import Foundation

class NetworkConfiguration {
    static let listUrl = URL(string: "http://dev.tapptic.com/test/json.php")!
    static let detailsUrl = "http://dev.tapptic.com/test/json.php?name="
}


// MARK : We will handle somes cases such as no internet connection (as pointed out in the directives), there are a lot of differents status code that we should look at in order to have an appropriate message for each cases that could be added here :

enum HttpErrorCode: Int {
    case badRequest = 400 // Request not well formated
    case notFound = 404 // Resource could not be found
    case internalServerError = 500 // Error with the server
    case serviceUnavailable = 503 // Server currently offline
    //URLConnection error Code
    case unknown                    =   -1      // Error is unknown.
    case cancelled                  =   -999    // The connection was cancelled.
    case timedOut                   =   -1001   // The connection timed out.
    case connectionLost             =   -1005   // The connection failed because the network connection was lost.
    case internetUnavailable        =   -1009   // The connection failed because the device is not connected to the internet.
}

enum ErrorState: CustomStringConvertible, Error {
    case internalServerError
    case serviceUnavailable
    case timedOut
    case connectionLost
    case internetUnavailable
    case defaultError
    case unknownError
    
    var description: String {
        switch self {
        case .internalServerError:
            return "Erreur du serveur"
        case .serviceUnavailable:
            return "Le serveur est indisponible"
        case .timedOut:
            return "Le serveur met trop de temps à répondre"
        case .connectionLost :
            return "Vous avec perdu votre connexion internet"
        case .internetUnavailable :
            return "Pas de connexion internet"
        case .defaultError, .unknownError:
            return "Une erreur est survenue"
        }
    }
    
    static func from(statusCode: Int) -> ErrorState {
        if let httpErrorCode = HttpErrorCode(rawValue:statusCode) {
            switch httpErrorCode {
            case .internalServerError :
                return ErrorState.internalServerError
            case .serviceUnavailable :
                return ErrorState.serviceUnavailable
            case .timedOut :
                return ErrorState.timedOut
            case .connectionLost :
                return ErrorState.connectionLost
            case .internetUnavailable :
                return ErrorState.internetUnavailable
            default:
                return ErrorState.defaultError
            }
        } else {
            return ErrorState.defaultError
        }
    }
}

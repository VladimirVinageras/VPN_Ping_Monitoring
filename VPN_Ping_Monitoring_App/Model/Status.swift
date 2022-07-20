//
//  Status.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 20.07.2022.
//

import SwiftUI
import Foundation


enum Status: String {
    case reachable
    case unreachable
        
    func Status() -> String{
        switch self{
        case .reachable:
                return NSLocalizedString("👍", comment: "Host connection status: Reachable")
        case .unreachable:
                return NSLocalizedString("👎", comment: "Host conntection status: Unreachable")
        }
    }
}



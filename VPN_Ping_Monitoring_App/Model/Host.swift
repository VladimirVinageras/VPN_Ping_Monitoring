//
//  Host.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import Foundation
import SwiftUI


struct Host: Identifiable, Codable {
    let id: UUID
    var hostname: String
    var ipAddress: String
    var status: Status = .unreachable
    var checkFrequency: Int = 5
    
    init(id: UUID = UUID(), hostname: String, ipAddress: String, checkFrequency: Int, status: Status){
        self.id = id
        self.hostname = hostname
        self.ipAddress = ipAddress
        self.checkFrequency = checkFrequency
        self.status = status
    }
}



extension Host{
    struct Data{
        var hostname: String = ""
        var ipAddress: String = ""
        var checkFrequency: Int = 5
        var status: Status = .unreachable
    }
    
    
    var data: Data{
        Data(hostname: hostname, ipAddress: ipAddress, checkFrequency: checkFrequency, status: status)
    }
    
    mutating func update(from data: Data){
        hostname = data.hostname
        ipAddress = data.ipAddress
        checkFrequency = data.checkFrequency
        status = data.status
    }
    
    init(data : Data){
        id = UUID()
        hostname = data.hostname
        ipAddress = data.ipAddress
        checkFrequency = data.checkFrequency
        status = data.status
    }
}




extension Host{
    static let sampleData: [Host] =
    [ Host(hostname: "Apple Site", ipAddress: "www.apple.com", checkFrequency: 30, status: .reachable),
      Host(hostname: "Google Site", ipAddress: "www.google.com", checkFrequency: 45, status: .unreachable),
      Host(hostname: "VPN Dayron's Server", ipAddress: "172.16.250.40", checkFrequency: 15, status: .reachable)
    ]
}

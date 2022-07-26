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
    var name: String
    var hostname: String
    var ipAddress: String
    var checkFrequency: Int = 5
    var status: Status
    
    init(id: UUID = UUID(), name: String, hostname: String, ipAddress: String, checkFrequency: Int, status: Status){
        self.id = id
        self.name = name
        self.hostname = hostname
        self.ipAddress = ipAddress
        self.checkFrequency = checkFrequency
        self.status = status
        
    }
}



extension Host{
    struct Data{
        var name: String = ""
        var hostname: String = ""
        var ipAddress: String = ""
        var checkFrequency: Int = 5
        var status : Status = .unknown
    }
    
    
    var data: Data{
        Data(name:name, hostname: hostname, ipAddress: ipAddress, checkFrequency: checkFrequency, status: status)
    }
    
    mutating func update(from data: Data){
        name = data.name
        hostname = data.hostname
        ipAddress = data.ipAddress
        checkFrequency = data.checkFrequency
        status = data.status
    }
    
    init(data : Data){
        id = UUID()
        name = data.name
        hostname = data.hostname
        ipAddress = data.ipAddress
        checkFrequency = data.checkFrequency
        status = data.status
    }
}




extension Host{
    static let sampleData: [Host] =
    [ Host(name: "Apple Site",hostname: "apple.com",  ipAddress: "17.253.144.10", checkFrequency: 30 , status: .unknown),
      Host(name: "Google Site", hostname: "google.com", ipAddress: "74.125.131.101", checkFrequency: 45, status: .unknown),
      Host(name: "VPN Dayron's Server", hostname: "remote.myusc.net" , ipAddress: "172.16.250.40", checkFrequency: 15, status: .unknown)
    ]
}

//
//  Host.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import Foundation
import SwiftUI


struct Host: Identifiable, Codable {
    var id: UUID
    var name: String
    var hostname: String
    var ipAddress: String

    
    init(id: UUID = UUID(), name: String, hostname: String, ipAddress: String){
        self.id = id
        self.name = name
        self.hostname = hostname
        self.ipAddress = ipAddress
        
        
    }
}



extension Host{
    struct Data{
        var name: String = ""
        var hostname: String = ""
        var ipAddress: String = ""
        var checkFrequency: Int = 5
        
    }
    
    
    var data: Data{
        Data(name:name, hostname: hostname, ipAddress: ipAddress)
    }
    
    mutating func update(from data: Data){
        name = data.name
        hostname = data.hostname
        ipAddress = data.ipAddress
    }
    
    init(data : Data){
        id = UUID()
        name = data.name
        hostname = data.hostname
        ipAddress = data.ipAddress
    }
}




extension Host{
    static let sampleData: [Host] =
    [ Host(name: "Apple Site", hostname: "apple.com" ,  ipAddress: "17.253.144.10"),
      Host(name: "Google Site", hostname: "google.com" , ipAddress: "74.125.131.101"),
      Host(name: "VPN Dayron's Server", hostname: "remote.myusc.net" , ipAddress: "172.16.250.40")
    ]
}

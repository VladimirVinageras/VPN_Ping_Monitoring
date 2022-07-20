//
//  VPN_Ping_Monitoring_AppApp.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import SwiftUI

@main
struct VPN_Ping_Monitoring_AppApp: App {
    @StateObject var hostsStore = HostStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HostsView(hosts: $hostsStore.hosts){
                    Task{
                        do{
                            try await HostStore.save(hosts: hostsStore.hosts)
                        }
                    }
                }
        }
      }
    }
}

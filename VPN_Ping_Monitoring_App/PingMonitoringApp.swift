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
    @State private var errorWrapper: ErrorWrapper?
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HostsView(hosts: $hostsStore.hosts){
                    Task{
                        do{
                            try await HostStore.save(hosts: hostsStore.hosts)
                        }catch{
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later")
                        }
                    }
                }
            }
            .task{
                do{
                    hostsStore.hosts = try await HostStore.load()
                }catch{
                    errorWrapper = ErrorWrapper(error: error, guidance: "This app will load sample data and continue")
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {hostsStore.hosts = Host.sampleData}){wrapper in
                ErrorView(errorWrapper: wrapper)
            }
      }
    }
}

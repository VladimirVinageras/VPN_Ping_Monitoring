//
//  VPN_Ping_Monitoring_AppApp.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import SwiftUI

@main
struct VPN_Ping_Monitoring_AppApp: App {
    @StateObject private var monitorManagerStore = MonitorManagerStore()
    @State private var errorWrapper: ErrorWrapper?
    @Environment (\.scenePhase) var scenePhase
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView<HostsView>{
                HostsView(monitorManagers: $monitorManagerStore.monitorManagers){
                    Task{
                        do{
                            try await MonitorManagerStore.save(monitorManagers: monitorManagerStore.monitorManagers)
                        }catch{
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later")
                        }
                    }
                }
            }
            .task{
                do{
                monitorManagerStore.monitorManagers = try await MonitorManagerStore.load()
    
                }catch{
                    errorWrapper = ErrorWrapper(error: error, guidance: "This app will load sample data and continue")
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {monitorManagerStore.monitorManagers[0] = MonitorManager.sampleMonitorManager}){wrapper in
                ErrorView(errorWrapper: wrapper)
            }
      }
 
        .onChange(of: scenePhase){ (phase) in
            if phase == .inactive || phase == .background{
                Task{
                    do{
                        try await monitorManagerStore.stillWorkingInBackground()
                    }catch{
                        errorWrapper = ErrorWrapper(error: error, guidance: "Try again later")
                    }
                }
            }
        }
    }
}



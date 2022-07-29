//
//  ContentView.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import SwiftUI

struct HostsView: View {
    @ObservedObject private var monitorManagers: [MonitorManager]
    @Environment (\.scenePhase) private var scenePhase
    @State private var isPresentingNewHostView = false
    @State private var newMonitorManagerData = MonitorManager.ManagerData()
    let saveAction: ()-> Void

    
    var body: some View {
        List{
            ForEach($monitorManagers){ $monitorManager in
                NavigationLink(destination: DetailView(monitorManager: $monitorManager)){
                    CardView(monitorManager: $monitorManager)
            }
        }
            .onChange(of: scenePhase){ phase in
                if phase == .inactive {saveAction()}
            }
        }
    
        .navigationTitle("Hosts")
        .toolbar{
            Button(action: {
                isPresentingNewHostView = true
            }){
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isPresentingNewHostView){
            NavigationView{
                DetailEditView(data: $newMonitorManagerData)
                    .toolbar{
                        ToolbarItem(placement: .cancellationAction){
                            Button("Dismiss"){
                                isPresentingNewHostView = false
                                newMonitorManagerData = MonitorManager.ManagerData()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction){
                            Button("Add"){
                                let newMonitorManager = MonitorManager(data: newMonitorManagerData)
                                monitorManagers.append(newMonitorManager)
                                isPresentingNewHostView = false
                                newMonitorManagerData = MonitorManager.ManagerData()
                            }
                        }
                    }
            }
        }
        .onChange(of: scenePhase){ phase in
            if phase == .inactive {saveAction()}
        }
    }
  }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HostsView(monitorManagers: [MonitorManager.sampleMonitorManager],saveAction: {})
        }
    }
  }




//
//  ContentView.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import SwiftUI

struct HostsView: View {
   
    @Binding var monitorManagers: [MonitorManager]
    @Environment (\.scenePhase) private var scenePhase
    @State private var isPresentingNewHostView = false
    @State private var newMonitorManagerData = MonitorManager.ManagerData()
    let saveAction: ()-> Void
    var body: some View {
        List{
            ForEach($monitorManagers){ $monitorManager in
                NavigationLink(destination: DetailView(monitorManager: $monitorManager)){
                    CardView(monitorManager: monitorManager)
                       
            }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                            removeMonitorManager(with: monitorManager.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                
        }
            .onChange(of: scenePhase){ phase in
                if phase == .inactive {saveAction()}
            }
        }
        .navigationTitle("Hosts")
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button(action: {
                    isPresentingNewHostView = true
                }){
                    Image(systemName: "plus")
                    }
            }
            ToolbarItem(placement: .cancellationAction){
                Button(action:refreshAction){
                    Image(systemName: "arrow.clockwise")
                }
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
            if phase == .inactive {
                saveAction()
            }
        }
     }
  }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HostsView(monitorManagers: .constant([MonitorManager.sampleMonitorManager]),saveAction: {})
        }
     }
  }


private extension HostsView{
    var refreshAction: () -> Void {
            return {
                monitorManagers.forEach { monitorManager in
                    monitorManager.refresh()
            }
        }
    }
    
    func removeMonitorManager(with monitorManagerID: UUID) {
           guard let index = monitorManagers.firstIndex(where: { $0.id == monitorManagerID }) else { return }
           monitorManagers.remove(at: index)
    }
}

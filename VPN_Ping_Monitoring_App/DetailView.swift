//
//  DetailView.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 20.07.2022.
//

import SwiftUI

struct DetailView: View {
    @Binding var monitorManager: MonitorManager
    @State private var data = MonitorManager.ManagerData()
    @State private var isPresentingEditView = false
    
    
    var body: some View {
        List{
            Section(header: Text("Host Name")){
                Label("\(monitorManager.host.hostname)", systemImage: "network")
                    .font(.headline)
            }
            Section(header: Text("IP Address/ Domain")){
                Label("\(monitorManager.host.ipAddress)", systemImage: "network")
                    .font(.headline)
            }
            Section(header: Text("Monitoring Frequency")){
                Label("\(monitorManager.checkFrequency)", systemImage: "clock.arrow.2.circlepath")
                    .font(.headline)
            }
            Section(header: Text("Status")){
                Label("\(monitorManager.hostStatusMessage)", systemImage: "app.connected.to.app.below.fill")
                    .font(.headline)
            }

        }
        .navigationTitle(monitorManager.host.hostname)
        .toolbar{
            Button("Edit"){
                isPresentingEditView = true
                data = monitorManager.data
            }
        }
        .sheet(isPresented: $isPresentingEditView){
            NavigationView{
                DetailEditView(data: $data)
                    .navigationTitle(monitorManager.host.hostname)
                    .toolbar{
                        ToolbarItem(placement: .cancellationAction){
                            Button("Cancel"){
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction){
                            Button("Done"){
                                isPresentingEditView = false
                                monitorManager.update(from: data)
                            }
                        }
                    }
            }
            
        }
    }
}
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(monitorManager: .constant(MonitorManager.sampleMonitorManager))
    }
}

//
//  ContentView.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import SwiftUI

struct HostsView: View {
    @Binding var hosts: [Host]
    @Environment (\.scenePhase) private var scenePhase
    @State private var isPresentingNewHostView = false
    @State private var newHostData = Host.Data()
    let saveAction: ()-> Void
    
    var body: some View {
        List{
            ForEach($hosts){ $host in
                NavigationLink(destination: DetailView(host: $host)){
            CardView(host: host)
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
                DetailEditView(data: $newHostData)
                    .toolbar{
                        ToolbarItem(placement: .cancellationAction){
                            Button("Dismiss"){
                                isPresentingNewHostView = false
                                newHostData = Host.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction){
                            Button("Add"){
                                let newHost = Host(data: newHostData)
                                hosts.append(newHost)
                                isPresentingNewHostView = false
                                newHostData = Host.Data()
                                newHost.monitor.monitoringServer()
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
            HostsView(hosts: .constant(Host.sampleData), saveAction: {})
        }
    }
}

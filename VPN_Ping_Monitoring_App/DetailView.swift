//
//  DetailView.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 20.07.2022.
//

import SwiftUI

struct DetailView: View {
    @Binding var host: Host
    @State private var data = Host.Data()
    @State private var isPresentingEditView = false
    
    
    var body: some View {
        List{
            Section(header: Text("Host Name")){
                Label("\(host.hostname)", systemImage: "network")
                    .font(.headline)
            }
            Section(header: Text("IP Address/ Domain")){
                Label("\(host.ipAddress)", systemImage: "network")
                    .font(.headline)
            }
            Section(header: Text("Monitoring Frequency")){
                Label("\(host.checkFrequency)", systemImage: "clock.arrow.2.circlepath")
                    .font(.headline)
            }
            Section(header: Text("Status")){
                Label("\(host.status.Status())", systemImage: "app.connected.to.app.below.fill")
                    .font(.headline)
            }

        }
        .navigationTitle(host.hostname)
        .toolbar{
            Button("Edit"){
                isPresentingEditView = true
                data = host.data
            }
        }
        .sheet(isPresented: $isPresentingEditView){
            NavigationView{
                DetailEditView(data: $data)
                    .navigationTitle(host.hostname)
                    .toolbar{
                        ToolbarItem(placement: .cancellationAction){
                            Button("Cancel"){
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction){
                            Button("Done"){
                                isPresentingEditView = false
                                host.update(from: data)
                            }
                        }
                    }
            }
            
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(host: .constant(Host.sampleData[0]))
    }
}

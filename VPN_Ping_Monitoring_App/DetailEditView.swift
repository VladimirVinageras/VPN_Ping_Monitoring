//
//  DetailViewEdit.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 20.07.2022.
//

import SwiftUI

struct DetailEditView: View {
    @Binding var data: MonitorManager.ManagerData
    
    
    var body: some View {
        Form{
            Section(header: Text("Name")){
                
                TextField("\(data.host.name)", text: $data.host.name)
                    .autocapitalization(.none)
            }
            Section(header: Text("Host Name")){
                
                TextField("\(data.host.hostname)", text: $data.host.hostname)
                    .autocapitalization(.none)
            }
            Section(header: Text("IP Address")){
                TextField("\(data.host.ipAddress)", text: $data.host.ipAddress)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                
            }
            Section(header: Text("Monitoring Frequency")){
                TextField("\(data.checkFrequency)", value: $data.checkFrequency, formatter: NumberFormatter())
            }
        }
    }
}

struct DetailViewEdit_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(MonitorManager.sampleMonitorManager.data))
    }
}



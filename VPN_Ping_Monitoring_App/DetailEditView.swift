//
//  DetailViewEdit.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 20.07.2022.
//

import SwiftUI

struct DetailEditView: View {
    @Binding var data: Host.Data
    
    var body: some View {
        Form{
            Section(header: Text("Host Name")){
                
                TextField("\(data.hostname)", text: $data.hostname)
                
            }
            Section(header: Text("IP Address/ Domain")){
                TextField("\(data.ipAddress)", text: $data.ipAddress)
            }
            Section(header: Text("Monitoring Frequency")){
                TextField("\(data.checkFrequency)", value: $data.checkFrequency, formatter: NumberFormatter())
            }
        }
    }
}

struct DetailViewEdit_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(Host.sampleData[0].data))
    }
}


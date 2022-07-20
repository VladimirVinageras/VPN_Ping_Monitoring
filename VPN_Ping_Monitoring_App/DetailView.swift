//
//  DetailView.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 20.07.2022.
//

import SwiftUI

struct DetailView: View {
    @Binding var host: Host
    //@state private var data = Host.Data()
    //@state private var isPresentingEditView = false
    
    
    var body: some View {
        List{
            Section(header: Text("\(host.hostname)")){
                Label("\(host.ipAddress)", systemImage: "network")
                    .font(.headline)
            }
            
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(host: .constant(Host.sampleData[0]))
    }
}

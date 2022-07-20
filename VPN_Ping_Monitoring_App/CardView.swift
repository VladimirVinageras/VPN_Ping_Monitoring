//
//  CardView.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import SwiftUI

struct CardView: View {
    let host: Host

    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text(host.hostname)
                    .font(.headline)
            }
            Spacer()
            VStack(alignment: .leading){
                HStack{
                    Label("\(host.ipAddress)", systemImage: "network")
                }
                Spacer()
                HStack{
                    Label(" \(host.checkFrequency) seconds.", systemImage: "clock.arrow.2.circlepath")
                        .font(.caption)
                
                Spacer()
            
                Label("The server is \(host.status.Status()).",systemImage: "app.connected.to.app.below.fill")
                        .font(.caption)
                }
            }
        }
    }
}



struct CardView_Previews: PreviewProvider {
    static var host = Host.sampleData[0]
    static var previews: some View {
        CardView(host: host)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

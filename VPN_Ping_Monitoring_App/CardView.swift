//
//  CardView.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import SwiftUI

struct CardView: View {
    
    @Binding var host: Host
    @StateObject var monitor: Monitor

    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text(host.name)
                    .font(.headline)
            }
            Spacer()
            VStack(alignment: .leading){
                VStack(alignment: .center){
                    Label("\(host.hostname)", systemImage: "network")
                }
                Spacer()
                HStack{
                    Label("\(host.ipAddress)", systemImage: "server.rack")
                }
                Spacer()
                HStack{
                    Label(" \(host.checkFrequency) seconds.", systemImage: "clock.arrow.2.circlepath")
                        .font(.caption)
                Spacer()
                
                    HostStatusView(monitor: monitor)
                }
            }
        }
        .onAppear(){
            if !host.monitor.isMonitoring{
                host.monitor.monitoringHost()
                monitor.updateServerStatus()
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {

    static var previews: some View {
        CardView(host: .constant(Host.sampleData[0]), monitor: Monitor.sampleMonitor)
            .previewLayout(.sizeThatFits)
    }
}

        









                        



                 





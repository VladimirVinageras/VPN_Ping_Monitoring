//
//  CardView.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var monitorManager: MonitorManager
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text(monitorManager.host.name)
                    .font(.headline)
            }
            Spacer()
            VStack(alignment: .leading){
                VStack(alignment: .center){
                    Label("\(monitorManager.host.hostname)", systemImage: "network")
                }
                Spacer()
                HStack{
                    Label("\(monitorManager.host.ipAddress)", systemImage: "server.rack")
                }
                Spacer()
                HStack{
                    Label(" \(monitorManager.checkFrequency) seconds.", systemImage: "clock.arrow.2.circlepath")
                        .font(.caption)
                Spacer()
                
                    Label("The server is  \(monitorManager.hostStatusMessage)",systemImage: "app.connected.to.app.below.fill")
                                .font(.caption)
                }
            }
        }
        .onAppear(){
            monitorManager.monitoringHost()
                
            }
        }
    }


struct CardView_Previews: PreviewProvider {

    static var previews: some View {
        CardView(monitorManager: MonitorManager.sampleMonitorManager)
            .previewLayout(.sizeThatFits)
    }
}

        









                        



                 





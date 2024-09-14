//
//  ContentView.swift
//  Fernbedienung
//
//  Created by Jannik Scheider on 15.05.24.
//

import SwiftUI

struct ContentView: View {
    @State private var volume: Double = 0.5
    @State private var devices: [Device] = []
    @State private var selectedDeviceID: String?

    let smartThingsAPI = SmartThingsAPI()

    var body: some View {
        VStack {
            Text("Smart TV Volume Control")
                .font(.largeTitle)
                .padding()

            Slider(value: $volume, in: 0...1, step: 0.1) {
                Text("Volume")
            }
            .padding()

            Button(action: {
                if let deviceID = selectedDeviceID {
                    smartThingsAPI.setVolume(deviceID: deviceID, volume: Int(volume * 100)) { success in
                        if success {
                            print("Volume set successfully")
                        } else {
                            print("Failed to set volume")
                        }
                    }
                }
            }) {
                Text("Set Volume")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            List(devices) { device in
                Text(device.label)
                    .onTapGesture {
                        selectedDeviceID = device.id
                    }
            }

            Button(action: {
                smartThingsAPI.getDevices { devices in
                    self.devices = devices
                }
            }) {
                Text("Discover Devices")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}

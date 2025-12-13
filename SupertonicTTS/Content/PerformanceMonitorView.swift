//
//  PerformanceMonitorView.swift
//  SupertonicTTS
    

import SwiftUI

struct PerformanceMonitorView: View {
    private var monitor = PerformanceMonitor()
    
    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 17) {
                Image(systemName: "cpu").foregroundStyle(.gray.gradient)
                Text("\(Int(monitor.cpuUsage))%").bold()
            }
            
            Spacer()
            Divider().frame(height: 25)
            Spacer()
            
            HStack(spacing: 17) {
                Image(systemName: "memorychip").foregroundStyle(.gray.gradient)
                Text("\(Int(monitor.memoryUsage)) MB").bold()
            }
            Spacer()
        }
        .font(.system(size: 15.5, design: .rounded))
        .padding(20)
        .frame(maxHeight: 40)
        .background(
            Capsule()
                .fill(Color.secondary.opacity(0.1))
        )
        .onAppear(perform: monitor.startMonitoring)
        .onDisappear(perform: monitor.stopMonitoring)
    }
    
    private var cpuColor: Color {
        switch monitor.cpuUsage {
        case 0..<50: return .green
        case 50..<80: return .orange
        default: return .red
        }
    }
    
    private var memoryColor: Color {
        let percentage = (monitor.memoryUsage / monitor.totalMemory) * 100
        switch percentage {
        case 0..<60: return .green
        case 60..<85: return .orange
        default: return .red
        }
    }
}

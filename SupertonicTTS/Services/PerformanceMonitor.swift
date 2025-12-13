//
//  PerformanceMonitor.swift
//  SupertonicTTS
    

import Foundation
import Observation


@Observable
class PerformanceMonitor {
    var cpuUsage: Double = 0
    var memoryUsage: Double = 0
    var totalMemory: Double = 1000
    
    @ObservationIgnored private let updateRate: TimeInterval = 1.0
    @ObservationIgnored private var timer: Timer?
    
    func startMonitoring() {
        totalMemory = Double(ProcessInfo.processInfo.physicalMemory) / 1024 / 1024
        timer = Timer.scheduledTimer(withTimeInterval: updateRate, repeats: true) { [weak self] _ in
            self?.scheduleUpdate()
        }
    }
    
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    
    private func scheduleUpdate() {
        Task.detached(priority: .utility) { [weak self] in
            guard let self else { return }
            
            let cpu = self.currentCPUUsage()
            let mem = self.currentMemoryUsage()
            
            await MainActor.run {
                self.cpuUsage = cpu
                self.memoryUsage = mem
            }
        }
    }
    
    
    private func currentCPUUsage() -> Double {
        var threadList: thread_act_array_t? = nil
        var threadCount = mach_msg_type_number_t(0)

        guard task_threads(mach_task_self_, &threadList, &threadCount) == KERN_SUCCESS,
              let threadListPtr = threadList
        else {
            return 0
        }

        var total: Double = 0

        for i in 0 ..< Int(threadCount) {
            var info = thread_basic_info()
            var infoCount = mach_msg_type_number_t(THREAD_INFO_MAX)

            let result = withUnsafeMutablePointer(to: &info) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(infoCount)) {
                    thread_info(threadListPtr[i],
                                thread_flavor_t(THREAD_BASIC_INFO),
                                $0,
                                &infoCount)
                }
            }

            if result == KERN_SUCCESS, info.flags & TH_FLAGS_IDLE == 0 {
                total += Double(info.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0
            }
        }

        // Free memory allocated by task_threads
        vm_deallocate(mach_task_self_,
                      vm_address_t(bitPattern: threadListPtr),
                      vm_size_t(Int(threadCount) * MemoryLayout<thread_t>.stride))

        return total
    }
    
    
    private func currentMemoryUsage() -> Double {
        var info = task_vm_info()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4

        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }

        return result == KERN_SUCCESS ? Double(info.phys_footprint) / 1024 / 1024 : 0
    }
}

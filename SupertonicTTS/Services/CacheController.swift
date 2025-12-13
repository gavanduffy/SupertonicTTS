//
//  CacheController.swift
//  SupertonicTTS
    

import Foundation


class CacheController {
    static let shared = CacheController()
    
    var cacheSizeString: String {
        return formattedSize(calculateCacheSize())
    }
    
    var isCacheEmpty: Bool {
        return calculateCacheSize() == 0
    }
    
    func clearCache() {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        do {
            try FileManager.default.removeItem(at: cacheURL)
        } catch {
            print("Error clearing cache: \(error)")
        }
    }
    
    private func calculateCacheSize() -> UInt64 {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fileManager = FileManager.default

        guard let enumerator = fileManager.enumerator(at: cacheURL, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }

        var totalSize: Int64 = 0

        for case let fileURL as URL in enumerator {
            do {
                let resourceValues = try fileURL.resourceValues(forKeys: [.fileSizeKey])
                if let fileSize = resourceValues.fileSize {
                    totalSize += Int64(fileSize)
                }
            } catch {
                continue
            }
        }

        return UInt64(totalSize)
    }
    
    private func formattedSize(_ size: UInt64) -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        byteCountFormatter.countStyle = .file
        return byteCountFormatter.string(fromByteCount: Int64(size))
    }
}

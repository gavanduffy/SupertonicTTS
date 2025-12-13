//
//  GeneratedItemView.swift
//  SupertonicTTS
    

import SwiftUI

struct GeneratedAudioView: View {
    @Environment(\.colorScheme) private var scheme
    @Environment(ApplicationVM.self) var vm
    let results: SynthesisResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(.waveformSparkle)
                    .foregroundStyle(.turquoise.gradient, .secondary)
                    .fontWeight(.medium)
                
                Text("Generated Audio")
                    .font(.subheadline.weight(.medium))
            }
            .padding(.leading, 10)
            
            
            VStack(alignment: .leading) {
                audioRow
                
                if results.audioSeconds > 0 {
                    Divider()
                        .padding(.horizontal, -14)
                        .padding(.bottom, 8)
                    
                    metricsRow
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Color.secondary.opacity(scheme == .light ? 0.08 : 0.25),
                in: .rect(cornerRadius: 17.5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 17.5)
                    .stroke(Color.secondary.opacity(0.15))
            )
        }
    }
    
    
    private var audioRow: some View {
        HStack {
            Text(results.url.lastPathComponent)
                .font(.subheadline)
                .lineLimit(1)
            
            Spacer()
            
            HStack(spacing: 12) {
                ShareLink(item: results.url) {
                    Image(systemName: "square.and.arrow.up.fill")
                        .symbolRenderingMode(.hierarchical)
                }
                
                
                Divider().padding(.vertical, 3)

                
                Button(action: vm.togglePlay) {
                    Image(systemName: vm.isPlaying ? "stop.fill" : "play.fill")
                        .contentTransition(.symbolEffect(.replace.downUp))
                        .animation(.spring(response: 0.3), value: vm.isPlaying)
                        .frame(width: 12)
                }
            }
            .font(.callout)
        }
    }
    
    private var metricsRow: some View {
        HStack(spacing: 6) {
            Image(systemName: "tachometer")
                .fontWeight(.medium)
                .foregroundStyle(.primary, .orange.gradient)
            
            Text(rtfText)
                .font(.footnote.monospacedDigit())
                .foregroundColor(.secondary)
        }
    }
    
    var rtfText: String {
        let rtf = results.elapsedSeconds / results.audioSeconds
        return String(format: "RTF %.2fx · %.2fs / %.2fs", rtf, results.elapsedSeconds, results.audioSeconds)
    }
}

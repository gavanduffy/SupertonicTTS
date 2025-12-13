//
//  TextInputView.swift
//  SupertonicTTS
    

import SwiftUI

struct TextInputView: View {
    @Environment(ApplicationVM.self) var vm
    @Environment(\.colorScheme) private var scheme
    
    @State private var showPromptList = false
    @State private var showSampelsPopover: Bool = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                if vm.userTextIsEmpty {
                    Text("Enter the text you want to synthesize into speech...")
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 16)
                }
                
                
                TextEditor(text: textInputBinding)
                    .frame(minHeight: 175, maxHeight: 370)
                    .padding(12)
                    .scrollIndicators(.hidden)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
            }
            
            
            HStack {
                Text("\(vm.totalWords) words")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 18)

                Spacer()

                buttonContainer
            }
            .padding(.trailing, 30)
            .padding(.bottom, 20)
            .padding(.top, 12)
            .fontWeight(.bold)
        }
        .background(
            scheme == .dark ? Color.secondary.opacity(0.2) : UIColor.secondarySystemBackground.color.opacity(0.28),
            in: RoundedRectangle(cornerRadius: 17.5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 17.5)
                .strokeBorder(.gray.quinary.opacity(0.8), lineWidth: 1.2)
        )
        .fullScreenCover(isPresented: $showPromptList) {
            PromptListView(selectedPrompt: textInputBinding)
        }
    }
    
    
    
    private var buttonContainer: some View {
        HStack(spacing: 30) {
            Button {
                Haptics.impact(style: .rigid)
                showSampelsPopover = true
            } label: {
                Image(.pencilAndSparkles)
            }
            .foregroundStyle(Color.primary, Color.purple.gradient)
            .popover(isPresented: $showSampelsPopover) { sampleTextPopover }
            
            
            Button {
                Haptics.impact(style: .rigid)
                showPromptList = true
            } label: {
                Image(systemName: "clock.fill")
            }
            .foregroundStyle(.primary, .background)
            
            
            if vm.userTextIsEmpty == false {
                Button(action: vm.clearPrompt) {
                    Image(systemName: "xmark.circle.fill")
                }
                .transition(.scale.combined(with: .opacity))
                .foregroundStyle(.background, .primary)
            }
        }
    }
    
    private var textInputBinding: Binding<String> {
        .init {
            return vm.userText
        } set: {
            vm.userText = $0
        }
    }
    
    private var sampleTextPopover: some View {
        List {
            ForEach(SampleText.allCases, id: \.self) { sample in
                Text(sample.rawValue)
                    .font(.callout.weight(.regular))
                    .onTapGesture {
                        vm.userText = sample.text
                        showSampelsPopover = false
                    }
            }
        }
        .listStyle(.inset)
        .frame(width: 300, height: 180)
        .presentationCompactAdaptation(.popover)
    }
}

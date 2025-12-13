//
//  PromptStorage.swift
//  SupertonicTTS
    

import SwiftUI
import Observation


@Observable
class PromptStorage {
    static let shared = PromptStorage()

    
    private(set) var prompts: [Prompt] = []
    private let filename: String = "prompts.json"
    
    var isEmpty: Bool { self.prompts.isEmpty }
    
    private init() {
        self.prompts = self.loadPrompts()
    }
    
    
    
    func storePrompt(_ newPrompt: Prompt) {
        // make sure to only store unique prompts
        for prompt in prompts {
            if prompt.text == newPrompt.text {
                return
            }
        }
        
        self.prompts.append(newPrompt)
        syncPrompts()
    }
    
    
    func deletePrompt(_ prompt: Prompt) {
        self.prompts.removeAll { $0.text == prompt.text }
        syncPrompts()
    }
    
    
    func deletePrompt(_ indexSet: IndexSet) {
        for index in indexSet {
            self.prompts.remove(at: index)
        }
        
        syncPrompts()
    }
    
    
    func clearPrompts() {
        self.prompts.removeAll()
        syncPrompts()
    }
    
    
    private func syncPrompts() {
        do {
            let data = try JSONEncoder().encode(self.prompts)
            try data.write(to: promptsFile)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    private func loadPrompts() -> [Prompt] {
        do {
            let data = try Data(contentsOf: promptsFile)
            let loadedPrompts = try JSONDecoder().decode([Prompt].self, from: data)
            return loadedPrompts
        } catch {
            return []
        }
    }
    
    
    private var promptsFile: URL {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentDirectory.appendingPathComponent(filename)
        return fileURL
    }
}

struct Prompt: Codable, Identifiable {
    var id = UUID()
    let text: String
    let date: Date
}

//
//  ChatbotView.swift
//  Study-Space
//
//  Created by Mingchung Xia on 2024-09-14.
//

import SwiftUI

struct ChatbotView: View {
    @State private var query: String = ""
    @State private var loading = false
    
    @StateObject private var vm = ChatbotViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(vm.messages.indices, id: \.self) { index in
                    HStack {
                        if index % 2 == 0 {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("You")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                Text(vm.messages[index])
                                    .padding()
                                    .background(.ultraThickMaterial)
                                    .cornerRadius(10)
                                    .frame(maxWidth: 300, alignment: .trailing)
                            }
                        } else {
                            VStack(alignment: .leading) {
                                Text("Tutor")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                Text(vm.messages[index])
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                                    .frame(maxWidth: 300, alignment: .leading)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                }
                
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
            
            HStack {
                HStack {
                    TextField("Ask a question...", text: $query)
                    
                    Button {
                        /// Activate cohere
                        Task {
                            await respond()
                        }
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray5))
                )
                
                Button {
                    /// Activate voiceflow
                } label: {
                    Image(systemName: "mic")
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
    
    func respond() async {
        loading = true
        do {
            try await vm.respond(query: query, textbook: "phys", page: 10)
            query = ""
        } catch {
            print("Error: \(error)")
        }
        loading = false
    }
}

#Preview {
    ChatbotView()
}

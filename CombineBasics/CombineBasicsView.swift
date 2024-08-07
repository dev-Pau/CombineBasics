//
//  CombineBasicsView.swift
//  CombineBasics
//
//  Created by PdePau on 7/8/24.
//

import SwiftUI

struct CombineBasicsView: View {
    
    @ObservedObject private var viewModel = CombineBasicsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Username", text: $viewModel.username)
                        .textInputAutocapitalization(.never)
                } footer: {
                    Text(viewModel.usernameError?.localizedDescription ?? "")
                        .foregroundStyle(.red)
                }
                
                Section {
                    SecureField("Password", text: $viewModel.password)
                    SecureField("Repeat password", text: $viewModel.repeatPassword)
                } footer: {
                    Text(viewModel.passwordError?.localizedDescription ?? "")
                        .foregroundStyle(.red)
                }
                Section {
                    Button(action: {}) {
                        Text("Sign up")
                    }.disabled(!viewModel.isValid)
                }
            }
        }
        .navigationTitle("Combine")
    }
}

#Preview {
    NavigationStack {
        CombineBasicsView()
    }
}

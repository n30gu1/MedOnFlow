//
//  SignInView.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import SwiftUI
import AuthenticationServices
import CryptoKit

struct SignInView: View {
    let viewModel: AuthenticationViewModel
    
    var body: some View {
        SignInWithAppleButton { request in
            viewModel.handleRequest(request: request)
        } onCompletion: { (result) in
            switch result {
            case .success(let user):
                print("success")
                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                    print("error with firebase")
                    return
                }
                viewModel.authenticate(credential: credential)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    SignInView(viewModel: AuthenticationViewModel())
}

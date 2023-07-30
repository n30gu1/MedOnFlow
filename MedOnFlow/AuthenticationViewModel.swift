//
//  GlobalViewModel.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import Foundation
import Observation
import Firebase
import CryptoKit
import AuthenticationServices

@Observable
class AuthenticationViewModel {
    var nonce = ""
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var currentUser: User?
    var signInState: SignInState = .loading
    
    init() {
        FirebaseApp.configure()
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                let uid = user.uid
                let email = user.email
                let photoURL = user.photoURL
                var multiFactorString = "MultiFactor: "
                for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                }
                
                self.currentUser = User(uid: uid, email: email, photoURL: photoURL)
                self.signInState = .signedIn
            } else {
                self.signInState = .notSignedIn
            }
        }
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func handleRequest(request: ASAuthorizationAppleIDRequest) {
        self.nonce = randomNonceString()
        request.requestedScopes = [.email, .fullName]
        request.nonce = sha256(self.nonce)
    }
    
    func authenticate(credential: ASAuthorizationAppleIDCredential) {
        //getting token
        guard let token = credential.identityToken else {
            print("error with firebase")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        Auth.auth().signIn(with: firebaseCredential) { result, err in
            if let err = err {
                print(err.localizedDescription)
            }
        }
    }
}


// Helper for Apple Login with Firebase
fileprivate func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

fileprivate func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

enum SignInState {
    case notSignedIn
    case signedIn
    case loading
}

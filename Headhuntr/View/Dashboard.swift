//
//  Dashboard.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 10/31/20.
//

import SwiftUI
import Amplify
import AmplifyPlugins

struct Dashboard: View {
    
    let cognito = Amplify.Auth
    
    @State var accessToken = ""
    
    var body: some View {
        TextField("Access Token", text: $accessToken)
        
        Button("Fetch Token") {
            cognito.fetchAuthSession { (result) in
                switch result {
                case .success(let authResult):
                    print(authResult)
                    
                    do {
                        let session: AWSAuthCognitoSession = try result.get() as! AWSAuthCognitoSession
                        
                        // Get cognito user pool token
                        switch session.getCognitoTokens() {
                        case .success(let tokens):
                            accessToken = tokens.idToken
                        case .failure(let sessionError):
                            print(sessionError.localizedDescription)
                        }
                        
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                case .failure(let authError):
                    print(authError.localizedDescription)
                }
            }
        }
    }
    
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}

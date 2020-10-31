//
//  Login.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 10/31/20.
//

import SwiftUI
import Amplify

struct Login: View {
    
    @State var username = ""
    @State var password = ""
    
    @State var errorMessage: String?
    
    var body: some View {
        Form {
            
            if let error = errorMessage {
                Text(error)
            }
            
            TextField("Username", text: $username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $password)
            
            Button("Login") {
                Amplify.Auth.signIn(username: username, password: password) { (result) in
                    print(result)
                    
                    switch result {
                    case .success(let auth):
                        print(auth)
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

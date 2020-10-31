//
//  SignUp.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 10/31/20.
//

import SwiftUI
import Amplify

struct SignUp: View {
    
    let cognito = Amplify.Auth
    
    @State var username = ""
    @State var password = ""
    @State var firstName = "Lyndon"
    @State var middleName = "Michael"
    @State var lastName = "Bibera"
    @State var gender = "Male"
    @State var birthDay = Date()
    
    @State var errorMessage: String?
    
    var body: some View {
        Form {
            
            if let error = errorMessage {
                Text(error)
            }
            
            Section(header: Text("Login Details")) {
                TextField("Email", text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
            }
            
            Section(header: Text("Personal Info")) {
                
                TextField("First Name", text: $firstName)
                TextField("Middle Name", text: $middleName)
                TextField("Last Name", text: $lastName)
                TextField("Gender", text: $gender)
                DatePicker("Birthday", selection: $birthDay, displayedComponents: .date)
                
            }
            
            Button("Sign Up") {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let userAttributes = [
                    AuthUserAttribute(.email, value: username),
                    AuthUserAttribute(.gender, value: gender),
                    AuthUserAttribute(.givenName, value: firstName),
                    AuthUserAttribute(.middleName, value: middleName),
                    AuthUserAttribute(.familyName, value: lastName),
                    AuthUserAttribute(.birthDate, value: dateFormatter.string(from: birthDay))
                ]
                
                let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
                
                cognito.signUp(username: username, password: password, options: options) { (result) in
                    
                    switch result {
                    case .success(let signUpResult):
                        print(signUpResult)
                    case .failure(let signUpError):
                        print(signUpError.errorDescription)
                    }
                }
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}

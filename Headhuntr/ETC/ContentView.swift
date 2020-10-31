//
//  ContentView.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 10/22/20.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        //SignUp()
        //Login()
        Dashboard()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

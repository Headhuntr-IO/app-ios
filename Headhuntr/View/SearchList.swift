//
//  SearchListView.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 10/31/20.
//

import SwiftUI
import CoreData

struct SearchList: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Candidate.fullName, ascending: true)],
        animation: .default)
    private var candidates: FetchedResults<Candidate>
    
    private let api = BackendAPI.instance

    var body: some View {
        
        VStack {
            Button("Load Things Up!") {
                loadCandidatesFromBackend()
            }
            
            Button("Delete All") {
                deleteAll()
            }
            
            List {
                ForEach(candidates) { candidate in
                    VStack {
                        Text(candidate.fullName!).font(.title)
                        Text("Experience: \(candidate.monthsExperience)")
                    }
                }
            }
        }
    }
    
    private func loadCandidatesFromBackend() {
        api.search(page: PageRequest()) { (result: Result<PageResults<Backend.Candidate>,Error>) in
            switch result {
            case .success(let searchResult):
                print("Success")
                
                self.updateCandidates(searchResult.results)
            case .failure:
                print("Failes")
            }
        }
    }

    private func updateCandidates(_ newCandidates: [Backend.Candidate]) {
        withAnimation {
            
            newCandidates.forEach { c in
                let candidate = Candidate(context: viewContext)
                
                candidate.id = c.id
                candidate.fullName = c.fullName
            }

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteAll() {
        withAnimation {
            
            let deleteFetch: NSFetchRequest<Candidate> = Candidate.fetchRequest()
            
            let allCandidates: [Candidate] = try! viewContext.fetch(deleteFetch)
            
            for c in allCandidates {
                viewContext.delete(c)
            }
            
            try! viewContext.save()
        }
    }

}

struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchList()
    }
}

//
//  SearchListView.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 10/31/20.
//

import SwiftUI

struct SearchList: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    private let api = BackendAPI.instance
    
    @State var companies = [Backend.Company]()

    var body: some View {
        
        VStack {
            Button("Load Things Up!") {
                //Label("Add Item", systemImage: "plus")
                api.search(page: PageRequest()) { (result: Result<PageResults<Backend.Company>,Error>) in
                    switch result {
                    case .success(let searchResult):
                        print("Success")
                        
                        self.companies = searchResult.results
                    case .failure:
                        print("Failes")
                    }
                }
            }
            
            List {
                ForEach(companies) { company in
                    VStack {
                        Text(company.name).font(.title)
                        Text("Candidates: \(company.candidateCount)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchList()
    }
}

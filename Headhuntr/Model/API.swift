//
//  API.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 11/1/20.
//

import Foundation
import Amplify
import AmplifyPlugins
import Alamofire
import SwiftyJSON

//typealias Resource = Identifiable & Codable
typealias CompletionHandler<T:Resource> = (Result<T,Error>) -> Void
typealias PageCompletionHandler<T:Resource> = (Result<PageResults<T>, Error>) -> Void

protocol API {
    
    // create or update a resource
    func save<T:Resource>(resource: T, completionHandler: @escaping CompletionHandler<T>)
    
    //get a single entity
    func getById<T:Resource>(id: String, completionHandler: @escaping CompletionHandler<T>)
    
    // execute a search query
    func search<T>(page: PageRequest, completionHandler: @escaping PageCompletionHandler<T>)
}

// MARK: - Resource

protocol Resource: Identifiable, Codable {
    static var resourcePath: String { get }
}

struct Backend {

    struct Candidate: Resource {
        
        static let resourcePath = "candidates"
        
        let id: String
        let firstName: String
        let lastName: String
        let fullName: String
        let monthsExperience: Int
        let jobHistory: [JobDetail]
        
        struct JobDetail: Codable {
            let sequence: Int
            let companyId: String
            let companyName: String
            let title: String
            let description: String
            let location: String
            let monthsExperience: Int
            //TODO: start, end
        }
    }
    
    struct Company: Resource {
        
        static let resourcePath = "companies"
        
        let id: String
        let name: String
        let candidateCount: Int
    }
}

// MARK: - Pagination

struct PageRequest {
    
    enum SortDirection {
        case asc, desc
    }
    
    struct Sort {
        let field: String
        let direction: SortDirection
    }
    
    let page: Int
    let size: Int
    let sort: [SortDirection]
    
    init() {
        page = 0
        size = 20
        sort = []
    }
}

struct PageResults<T:Resource> {
    
    struct Page: Codable {
        let size: Int
        let totalElements: Int
        let totalPages: Int
        let number: Int
    }
    
    let results: [T]
    let page: Page
}

// MARK: - API Implementation

class AccessTokenProvider {
    
    public static let instance = AccessTokenProvider()
    
    let cognito = Amplify.Auth
    
    func provide(accessTokenReceiver: @escaping (String) -> Void) {
        cognito.fetchAuthSession { (result) in
            switch result {
            case .success:
                
                let session: AWSAuthCognitoSession = try! result.get() as! AWSAuthCognitoSession
                
                // Get cognito user pool token
                switch session.getCognitoTokens() {
                case .success(let tokens):
                    accessTokenReceiver(tokens.idToken)
                case .failure(let sessionError):
                    self.printAndDie(sessionError)
                }
                
            case .failure(let authError):
                self.printAndDie(authError)
            }
        }
    }
    
    func printAndDie(_ error: Error) {
        print(error.localizedDescription)
        fatalError()
    }
}

class BackendAPI: API {
    
    static let instance: API = BackendAPI()
    
    private let url = "https://293jgimfk3.execute-api.us-east-1.amazonaws.com"
    private let accessTokenProvider = AccessTokenProvider.instance
    private let decoder = JSONDecoder()
    
    //if you are ever in a tricky situation to bypass the trust check (for local dev) use "session" instead of "AF"
//    private let session: Session = {
//
//        let manager = ServerTrustManager(evaluators: ["localhost": DisabledTrustEvaluator()])
//        let configuration = URLSessionConfiguration.af.default
//
//        return Session(configuration: configuration, serverTrustManager: manager)
//    }()
    
    private init() {}
    
    func save<T: Resource>(resource: T, completionHandler: @escaping (Result<T,Error>) -> Void){
        
        accessTokenProvider.provide { accessToken in
            
            let resourceUrl = "\(self.url)/\(T.resourcePath)"
            
            let headers: HTTPHeaders = [
                .authorization(bearerToken: accessToken),
                .accept("application/json")
            ]
            
            AF.request(resourceUrl, method: .post, parameters: resource, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let entity: T = try? self.decoder.decode(T.self, from: json.rawData()) {
                        completionHandler(Result.success(entity))
                    }
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
    
    func getById<T: Resource>(id: String, completionHandler: @escaping (Result<T,Error>) -> Void){
        
        accessTokenProvider.provide { accessToken in
            
            let resourceUrl = "\(self.url)/\(T.resourcePath)/\(id)"
            
            let headers: HTTPHeaders = [
                .authorization(bearerToken: accessToken),
                .accept("application/json")
            ]
            
            AF.request(resourceUrl, method: .get, headers: headers).responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    do {
                        let entity: T = try self.decoder.decode(T.self, from: json.rawData())
                        completionHandler(.success(entity))
                    } catch {
                        completionHandler(.failure(error))
                    }
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
        
    
    func search<T>(page: PageRequest = PageRequest(), completionHandler: @escaping (Result<PageResults<T>,Error>) -> Void) where T : Resource {
        
        accessTokenProvider.provide { accessToken in
            
            let resourceUrl = "\(self.url)/\(T.resourcePath)"
            
            let headers: HTTPHeaders = [
                .authorization(bearerToken: accessToken),
                .accept("application/json")
            ]
            
            AF.request(resourceUrl, method: .get, headers: headers).responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    do {
                        let entityList: [T] = try self.decoder.decode([T].self, from: json["_embedded"][T.resourcePath].rawData())
                        let pageData: PageResults.Page = try self.decoder.decode(PageResults<T>.Page.self, from: json["page"].rawData())
                        
                        completionHandler(.success(PageResults(results: entityList, page: pageData)))
                    } catch {
                        print(error.localizedDescription)
                        completionHandler(.failure(error))
                    }
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
}

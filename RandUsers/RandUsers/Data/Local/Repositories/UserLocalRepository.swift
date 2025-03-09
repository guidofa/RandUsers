//
//  UserLocalRepository.swift
//  RandUsers
//
//  Created by Guido Fabio on 9/3/25.
//

import Foundation
import RealmSwift

protocol UserLocalRepository {
    func getUserModel(page: Int, seed: String?) async -> ResultModel?
    func saveUserModel(_ userModel: ResultModel) async
    func searchUsers(searchTerm: String) async -> [UserModel]
}

struct UserLocalRepositoryImpl: UserLocalRepository {

    private let realm: Realm!

    init() {
        do {
            realm = try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
            realm = nil
        }
    }

    @MainActor
    func getUserModel(page: Int, seed: String?) -> ResultModel? {
        let results = realm.objects(ResultLocalResponse.self)
        var query = results.where { $0.page == page }

        if let seed = seed {
            query = query.where { $0.seed == seed }
        }

        if let first = query.first {
            return first.mapToModel()
        }

        return nil
    }

    @MainActor
    func saveUserModel(_ resultModel: ResultModel) {
        var auxResultModel = resultModel
        if getUserModel(page: resultModel.page ?? 1, seed: resultModel.seed) == nil {
            let uniqueUsersInCurrentResult = uniqueElements(from: resultModel.users)
            let usersNotAlreadySaved = uniqueUsersInCurrentResult.filter { user in
                if realm.object(ofType: UserLocalResponse.self, forPrimaryKey: user.id) == nil {
                    return true
                }
                return false
            }

            auxResultModel.users = usersNotAlreadySaved
            try? realm.write {
                let resultLocal = auxResultModel.mapToLocal()
                realm.add(resultLocal)
            }
        }
    }

    @MainActor
    func searchUsers(searchTerm: String) async -> [UserModel] {
        let predicate = NSPredicate(format: "((name CONTAINS[c] %@) OR (surname CONTAINS[c] %@) OR (email CONTAINS[c] %@))", searchTerm, searchTerm, searchTerm)
        let results = realm.objects(UserLocalResponse.self).filter(predicate)
        return results.map { $0.mapToModel() }
    }

    private func uniqueElements<T: Hashable>(from array: [T]) -> [T] {
        var seen: Set<T> = []
        return array.filter { seen.insert($0).inserted }
    }
}

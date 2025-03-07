//
//  UserListView.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel

    var body: some View {
        Text("Hola")
            .task { [weak viewModel] in
                await viewModel?.getUsersList()
            }
    }
}

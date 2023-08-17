//
//  SelectCategoryView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/01.
//

import SwiftUI

struct SelectCategoryView: View {
    @ObservedObject var vm: PostViewModel
    @Binding var path: [String]
    
    var body: some View {
        NavigationView {
            List(Categories.allCases, id: \.self) { category in
                NavigationLink(category.rawValue) {
                    switch category {
                    case .tops: subcategoriesList(sub: .tops)
                    case .outwear: subcategoriesList(sub: .outwear)
                    case .bottoms: subcategoriesList(sub: .bottoms)
                    case .allin: subcategoriesList(sub: .allin)
                    case .shoes: subcategoriesList(sub: .shoes)
                    case .accessories: subcategoriesList(sub: .accessories)
                    case .something: subcategoriesList(sub: .something)
                    case .others: subcategoriesList(sub: .others)
                    }
                }
            }
            .navigationTitle("カテゴリー")
            .navigationBarTitleDisplayMode(.inline)
            .customBackButton()
            .listStyle(.inset)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func subcategoriesList(sub: Categories) -> some View {
        let lists = sub.selectSubcategories()
        return List {
            ForEach(lists, id: \.self) { list in
                Button(action: {
                    path.removeAll()
                    vm.binding.category = "\(sub.rawValue)/\(list)"
                }) {
                    Text(list)
                }
            }
        }
        .listStyle(.inset)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(sub.rawValue)
        .customBackButton()
    }
}

struct SelectCategoryView_Previews: PreviewProvider {
    @State static var path = [String]()
    static var previews: some View {
        SelectCategoryView(vm: PostViewModel(), path: $path)
    }
}

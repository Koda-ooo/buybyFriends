//
//  ContentView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI
import Combine

struct ContentView: View {
   @Namespace var namespace
    @State var show = false

   var body: some View {
       ZStack {
           if !show {
               VStack(alignment: .leading, spacing: 12) {
                   Text("SwiftUI")
                       .font(.largeTitle.weight(.bold))
                       .matchedGeometryEffect(id: "title", in: namespace)
                       .frame(maxWidth: .infinity, alignment: .leading)
                   Text("20 sections - 3 hours".uppercased())
                       .matchedGeometryEffect(id: "subtitle", in: namespace)
               }
               .foregroundStyle(.white)
               .background(
                Color.red.matchedGeometryEffect(id: "background", in: namespace)
               )
               .padding()
               .onTapGesture {
                   withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                       show.toggle()
                   }
               }
           } else {
               VStack(alignment: .leading, spacing: 12) {
                   Spacer()
                   Text("20 sections - 3 hours".uppercased())
                       .matchedGeometryEffect(id: "subtitle", in: namespace)
                   Text("SwiftUI")
                       .font(.largeTitle.weight(.bold))
                       .matchedGeometryEffect(id: "title", in: namespace)
                       .frame(maxWidth: .infinity, alignment: .trailing)
               }
               .foregroundStyle(.black)
               .background(
                Color.blue.matchedGeometryEffect(id: "background", in: namespace)
               )
               .onTapGesture {
                   withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                       show.toggle()
                   }
               }
           }
       }
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

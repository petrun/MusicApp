//
//  Library.swift
//  MusicApp
//
//  Created by andy on 06.03.2021.
//

import SwiftUI

struct Library: View {
    var body: some View {
        NavigationView {
            VStack{
                GeometryReader{ geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            print("Click Play button")
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: abs(geometry.size.width / 2 - 10), height: 50)
                                .accentColor(.red)
                                .background(Color(.lightGray))
                                .cornerRadius(10)
                                
                        })
                        Button(action: {
                            print("Click Repeat button")
                        }, label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(.red)
                                .background(Color(.lightGray))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 50)

                Divider().padding()
                List{
                    LibraryCell()
                    LibraryCell()
                    LibraryCell()
                }.listStyle(PlainListStyle())
            }
            
            .navigationTitle("Library")
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

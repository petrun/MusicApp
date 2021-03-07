//
//  LibraryCell.swift
//  MusicApp
//
//  Created by andy on 07.03.2021.
//

import SwiftUI

struct LibraryCell: View {
    var body: some View {
        HStack{
            Image("track1")
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(5)
            VStack {
                Text("Track Name")
                Text("Artist Name")
            }
        }
    }
}

struct LibraryCell_Previews: PreviewProvider {
    static var previews: some View {
        LibraryCell()
    }
}

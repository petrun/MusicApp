//
//  LibraryCell.swift
//  MusicApp
//
//  Created by andy on 07.03.2021.
//

import SwiftUI
import URLImage

struct LibraryCell: View {
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack{
            if let trackUrl = URL(string: cell.iconUrlString ?? "") {
                URLImage(url: trackUrl) { image in
                    image
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(5)
                }
            }
            VStack(alignment: .leading) {
                Text(cell.trackName)
                Text(cell.artistName)
            }
        }
    }
}

struct LibraryCell_Previews: PreviewProvider {
    static let previewCell = SearchViewModel.Cell(
        trackId: 1057860639,
        iconUrlString: "https://is5-ssl.mzstatic.com/image/thumb/Video113/v4/35/07/b2/3507b295-81d9-0df3-ad1e-09e42c9f50c1/pr_source.lsr/100x100bb.jpg",
        trackName: "The Good Dinosaur",
        collectionName: "Collection name",
        artistName: "Peter Sohn",
        previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview71/v4/14/8d/36/148d36b1-927e-f496-5b75-a4c1b3d490d7/mzaf_6015340690291060006.plus.aac.p.m4a"
    )
    static var previews: some View {
        LibraryCell(cell: previewCell)
    }
}

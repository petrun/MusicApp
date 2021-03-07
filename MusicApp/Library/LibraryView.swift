//
//  Library.swift
//  MusicApp
//
//  Created by andy on 06.03.2021.
//

import SwiftUI

struct LibraryView: View {
    var tracks: [SearchViewModel.Cell] = Array(TracksCache.shared.getAll())
    
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
                List(tracks){ track in
                    LibraryCell(cell: track)
                }.listStyle(PlainListStyle())
            }
            
            .navigationTitle("Library")
        }
    }
}

struct Library_Previews: PreviewProvider {
    static let tracks: [SearchViewModel.Cell] = [
        .init(
            trackId: 1057860639,
            iconUrlString: "https://is5-ssl.mzstatic.com/image/thumb/Video113/v4/35/07/b2/3507b295-81d9-0df3-ad1e-09e42c9f50c1/pr_source.lsr/100x100bb.jpg",
            trackName: "The Good Dinosaur",
            collectionName: "Collection name",
            artistName: "Peter Sohn",
            previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview71/v4/14/8d/36/148d36b1-927e-f496-5b75-a4c1b3d490d7/mzaf_6015340690291060006.plus.aac.p.m4a"
        ),
        .init(
            trackId: 1057860640,
            iconUrlString: "https://is5-ssl.mzstatic.com/image/thumb/Video113/v4/35/07/b2/3507b295-81d9-0df3-ad1e-09e42c9f50c1/pr_source.lsr/100x100bb.jpg",
            trackName: "The Good Dinosaur",
            collectionName: "Collection name",
            artistName: "Peter Sohn",
            previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview71/v4/14/8d/36/148d36b1-927e-f496-5b75-a4c1b3d490d7/mzaf_6015340690291060006.plus.aac.p.m4a"
        )
    ]
    static var previews: some View {
        LibraryView(tracks: tracks)
    }
}
//
//  Library.swift
//  MusicApp
//
//  Created by andy on 06.03.2021.
//

import SwiftUI

struct LibraryView: View {
    @State var tracks: [SearchViewModel.Cell] = TracksCache.shared.getAll()

    @State private var isAlertShowing = false
    @State private var selectedTrack: SearchViewModel.Cell?
    @State private var currentTrack: SearchViewModel.Cell?

    var player: Player?

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            playTrack(track: tracks.first)
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: abs(geometry.size.width / 2 - 10), height: 50)
                                .accentColor(.red)
                                .background(Color(.lightGray))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            print("Click Reload button")
                            self.tracks = TracksCache.shared.getAll()
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
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track)
                            .gesture(
                                LongPressGesture().onEnded { _ in
                                    self.selectedTrack = track
                                    self.isAlertShowing = true
                                }
                                .simultaneously(with: TapGesture().onEnded { _ in
                                    playTrack(track: track)
                                })
                            )
                    }.onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
                .actionSheet(isPresented: $isAlertShowing, content: {
                    ActionSheet(
                        title: Text("Delete track from library?"),
                        buttons: [
                            .destructive(Text("Delete"), action: { // [weak self] in
                                guard let track = self.selectedTrack else {
                                    return
                                }
                                self.delete(track: track)
                            }),
                            .cancel()
                        ]
                    )
                })
            }

            .navigationTitle("Library")
        }
    }

    func delete(at offsets: IndexSet) {
        let idsToDelete = offsets.map {
            self.tracks[$0].id
        }
        tracks.remove(atOffsets: offsets)
        for trackId in idsToDelete {
            TracksCache.shared.deleteBy(id: trackId)
        }
    }

    func delete(track: SearchViewModel.Cell) {
        guard let trackIndex = tracks.firstIndex(where: { $0 == track }) else {
            return
        }
        let trackId = track.id

        tracks.remove(at: trackIndex)
        TracksCache.shared.deleteBy(id: trackId)
    }

    private func playTrack(track: SearchViewModel.Cell?) {
        guard let track = track else {
            return
        }
        self.currentTrack = track
        player?.play(viewModel: track, playListDelegate: self)
    }
}

extension LibraryView: PlayListDelegate {
    private func getTrack(isNextTrack: Bool) -> SearchViewModel.Cell? {
        guard
            let currentTrack = currentTrack,
            let currentIndex = tracks.firstIndex(where: { $0.id == currentTrack.id })
        else {
            return nil
        }
        
        let newIndex = isNextTrack ? currentIndex + 1 : currentIndex - 1
        guard newIndex >= 0 && newIndex < tracks.count else { return nil }
        self.currentTrack = tracks[newIndex]
        
        return self.currentTrack
    }

    func getNextTrack() -> SearchViewModel.Cell? {
        getTrack(isNextTrack: true)
    }

    func getPreviousTrack() -> SearchViewModel.Cell? {
        getTrack(isNextTrack: false)
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

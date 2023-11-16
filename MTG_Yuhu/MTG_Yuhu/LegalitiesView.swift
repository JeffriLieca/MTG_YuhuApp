////
////  LegalitiesView.swift
////  MTG_Yuhu
////
////  Created by MacBook Pro on 17/11/23.
////
//
//import SwiftUI
//
//struct LegalitiesView: View {
//    let legalities: Legalities
//
//    var body: some View {
//        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading) {
//            ForEach(legalities.allLegalities(), id: \.format) { legality in
//                Text(legality.format)
//                Text(legality.status)
//            }
//        }
//    }
//}
//extension Legalities {
//    // Mengonversi Legalities menjadi array dari tuple untuk mudah diiterasi
//    func allLegalities() -> [(format: String, status: String)] {
//        return [
//            ("Standard", standard.rawValue),
//            ("Future", future.rawValue),
//            // Tambahkan semua properti lainnya sesuai dengan model
//            ("Vintage", vintage.rawValue),
//            // Lanjutkan untuk semua format
//        ]
//    }
//}
//

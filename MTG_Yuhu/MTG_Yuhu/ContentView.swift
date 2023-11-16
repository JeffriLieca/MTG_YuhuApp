//
//  ContentView.swift
//  MTG_Yuhu
//
//  Created by MacBook Pro on 16/11/23.
//

import SwiftUI

enum SortOption {
    case name, price, number, mana
}

enum SortDirection {
    case ascending, descending
}

struct ContentView: View {
    @State var cardlist: Cardlist // Anggap ini adalah model data Anda
    @State private var searchText = ""
    @State private var isFilterPresented = false
    @State private var sortOption: SortOption = .number
        @State private var sortDirection: SortDirection = .ascending


//        var filteredCards: [Datum] {
//            if searchText.isEmpty {
//                return cardlist.data
//            } else {
//                return cardlist.data.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//            }
//        }
    init() {
        self.cardlist = loadCardlistData() ?? Cardlist(object: "", totalCards: 0, hasMore: false, data: [])
    }

    var sortedCards: [Datum] {
        let sorted = cardlist.data.sorted { (first: Datum, second: Datum) -> Bool in
            switch sortOption {
            case .name:
                return sortDirection == .ascending ? first.name < second.name : first.name > second.name
            case .price:
                let firstPrice = Double(first.prices.usd ?? "0") ?? 0
                let secondPrice = Double(second.prices.usd ?? "0") ?? 0
                return sortDirection == .ascending ? firstPrice < secondPrice : firstPrice > secondPrice
            case .number:
                let firstNum = Int(first.collectorNumber ) ?? 0
                let secondNum = Int(second.collectorNumber ) ?? 0
                return sortDirection == .ascending ? firstNum < secondNum : firstNum > secondNum
            case .mana:
                let firstCmc = (first.cmc ) 
                let secondCmc = (second.cmc ) 
                return sortDirection == .ascending ? firstCmc < secondCmc : firstCmc > secondCmc
            }
        }
        return searchText.isEmpty ? sorted : sorted.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
//    var sortedCards:[Datum]{return cardlist.data}
 
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if(isFilterPresented==false){
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(sortedCards, id: \.id) { card in
                            NavigationLink(destination: CardDetailView(card: card)) {
                                VStack {
                                    CardView(card: card) // Menggunakan CardView sebagai subview
                                    Text(card.name)
                                        .bold()
                                        .lineLimit(2)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(width: 100, height: 20, alignment: .top)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    .padding()
                }
                else{
                    FilterView(sortOption: $sortOption, sortDirection: $sortDirection, onApply: {
                                        isFilterPresented = false
                                        // Aksi tambahan saat filter diterapkan jika perlu
                                    }, onReset: {
                                        sortOption = .number // Setel ulang ke default
                                        sortDirection = .ascending // Setel ulang ke default
                                        // Aksi tambahan untuk reset jika perlu
                                    })
                   
                }
            }
            .searchable(text: $searchText, prompt: "Search cards")
                       .toolbar {
                           // Tombol filter
                           ToolbarItem(placement: .navigationBarTrailing) {
                               Button(action: {
                                   if(isFilterPresented==false){
                                       isFilterPresented = true
                                   }
                                   else{
                                       isFilterPresented = false
                                   }
                                   }) {
                                   Image(systemName: "line.horizontal.3.decrease.circle")
                               }
                           }
                       }
            
        
        }
    }
}

// Subview untuk Card
struct CardView: View {
    let card: Datum

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: card.imageUris.normal)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 4)
                    )
            } placeholder: {
                ProgressView()
            }
            HStack{
                if let usdPrice = card.prices.usd {
                    Text("$\(usdPrice)")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(4)
                }
                if (card.foil == true){
                    Text("F")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                       
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(50)
                }
            }
        }
        
        .frame(width: 100, height: 140)
    }
}


struct FilterView: View {
    @Binding var sortOption: SortOption
        @Binding var sortDirection: SortDirection
        var onApply: () -> Void
        var onReset: () -> Void

        var body: some View {
            VStack {
            Section(header: Text("Sort By")) {
                Picker("Sort Option", selection: $sortOption) {
                    Text("Col. Num").tag(SortOption.number)
                    Text("Name").tag(SortOption.name)
                    Text("Price").tag(SortOption.price)
                    Text("Mana Cost").tag(SortOption.mana)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.vertical,10)

            Section(header: Text("Sort Direction")) {
                Picker("Sort Direction", selection: $sortDirection) {
                    Text("Ascending").tag(SortDirection.ascending)
                    Text("Descending").tag(SortDirection.descending)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.vertical,10)
        HStack {
                Button(action: onReset) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button(action: onApply) {
                    Label("OK", systemImage: "checkmark")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        .padding(.vertical,30)
        }
            .padding(.vertical,10)
    }
}


// Detail view untuk setiap kartu
struct CardDetailView: View {
    let card: Datum
    @State private var showTitle: Bool = false
    @State private var selectedButton = "Button1" // Default pilihan pertama
    @State private var isPopupPresented = false
    let manaImages = [
            "W": Image("mana_W"), // Pastikan gambar mana_W ada dalam Assets.xcassets
            "B": Image("mana_B"), // Pastikan gambar mana_B ada dalam Assets.xcassets
            // Tambahkan gambar lainnya jika perlu
        ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geometry in
                Color.clear.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
            }
            .frame(height: 0)
            VStack (spacing:0){
                // Menampilkan gambar 'art crop'
                AsyncImage(url: URL(string: card.imageUris.artCrop)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(alignment: .top)
                        .onTapGesture {
                                            isPopupPresented = true
                                        }
                } placeholder: {
                    ProgressView()
                }
                
                .sheet(isPresented: $isPopupPresented) {
                    ZStack{
                        // Tampilan popup dengan gambar kartu
                        PopupView(isPopupPresented: $isPopupPresented,card:card)
                    }
                        }
                
                // Tampilkan detail lebih lanjut tentang kartu di sini
                // ...
                HStack{
                    VStack(alignment: .leading){
                        // Tampilkan detail kartu di sini
                        Text(card.name)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .frame(alignment: .topLeading)
                        
                        Text(card.typeLine)
                            .multilineTextAlignment(.leading)
                            .bold()
                            .frame(alignment: .leadingFirstTextBaseline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    VStack{
                        ManaCostView(manaCost: card.manaCost)
                            .font(.subheadline)
                        Text("")
                    }.frame( alignment: .topTrailing)
                    
                }.padding(10)
                
                HStack(spacing:0){
                    Text(card.oracleText).background(Color(.systemGray6)).padding().cornerRadius(4) .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                    //                                                    OracleTextView(oracleText: card.oracleText)
                    //                           .padding()
                }
                    .background()
                    .cornerRadius(10)
                    .padding(0)
                
                //                HStack(alignment: .firstTextBaseline, spacing: 0) {
                //                           ForEach(parseTextWithManaSymbols(card.oracleText).indices, id: \.self) { index in
                //                               parseTextWithManaSymbols(card.oracleText)[index]
                //                           }
                //                       }
                HStack {
                            Button(action: {
                                selectedButton = "Button1"
                            }) {
                                RadioButtonStyle(label: "Versions", isSelected: selectedButton == "Button1")
                            }
                            Button(action: {
                                selectedButton = "Button2"
                            }) {
                                RadioButtonStyle(label: "Ruling", isSelected: selectedButton == "Button2")
                            }
                }.padding(10)
                if selectedButton == "Button1" {
                    HStack{
                        CardViewKecil(card: card)
                            .onTapGesture {
                                                isPopupPresented = true
                                            }
                        Spacer()
                        HStack{
                            Spacer()
                            if (card.nonfoil==true){
                                VStack{
                                    Text("Normal").bold()
                                    if let usdPrice = card.prices.usd {
                                        Text("$\(usdPrice)").bold()
                                    }
                                }
                            }
                            Spacer()
                            if (card.foil==true){
                                VStack{
                                    Text("Foil").bold()
                                        .foregroundColor(.orange)
                                    if let usdPrice = card.prices.usdFoil {
                                        Text("$\(usdPrice)").bold()
                                    }
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                        Text("...")
                        
                    }
                    .padding(10).cornerRadius(10).overlay(
                        RoundedRectangle(cornerRadius: 10) // Bentuk yang sama dengan latar belakang
                            
                            .stroke(Color.black, lineWidth: 1) // Warna dan ketebalan border
                    )
                        .padding(10)
                                    // Customisasi tampilan lebih lanjut di sini
                            } else if selectedButton == "Button2" {
                                LegalitiesView(legalities: card.legalities)
                                            .padding()
                                    // Customisasi tampilan lebih lanjut di sini
                            }
               
            }
        }
        .onPreferenceChange(ViewOffsetKey.self) { value in
            if value < -0 { // Sesuaikan nilai ini berdasarkan kebutuhan
                withAnimation {
                    showTitle = true
                }
            } else {
                withAnimation {
                    showTitle = false
                }
            }
        }
        .edgesIgnoringSafeArea(.top) // Mengabaikan safe area di bagian atas untuk menempel ke atas layar
        .navigationBarTitle(showTitle ? card.name : "", displayMode: .inline)
        .navigationBarTitleDisplayMode(.inline)// Menambahkan judul navigasi
        
    }
}

struct PopupView: View {
    @Binding var isPopupPresented: Bool
    let card:Datum
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: card.imageUris.large)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 4)
                    )
                    .frame(width: 300, height: 400)
                
            }
            
        placeholder: {
            ProgressView()
        }
            // Tampilan untuk popup
            // Ganti dengan gambar kartu yang sebenarnya
//            Image("card_image")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300, height: 400) // Sesuaikan ukuran sesuai kebutuhan
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .onTapGesture {
            isPopupPresented = false
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

extension Legalities {
    func toKeyValueArray() -> [(String, String)] {
        let mirror = Mirror(reflecting: self)
        var keyValuePairs: [(String, String)] = []

        for child in mirror.children {
            if let value = child.value as? Alchemy {
                keyValuePairs.append((child.label?.camelCaseToWords() ?? "Unknown", value.rawValue))
            } else if let value = child.value as? Vintage {
                keyValuePairs.append((child.label?.camelCaseToWords() ?? "Unknown", value.rawValue))
            }
        }

        return keyValuePairs
    }
}

extension String {
    // Helper function to convert camelCase strings to separate words
    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) && !$0.isEmpty {
                return $0 + " " + String($1)
            } else {
                return $0 + String($1)
            }
        }
    }
}

struct RadioButtonStyle: View {
    var label: String
    var isSelected: Bool

    var body: some View {
        Text(label)
            .foregroundColor(isSelected ? Color.white : Color.gray)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(isSelected ? Color.red : Color.white)
            
            .cornerRadius(25)
            .overlay(
                            RoundedRectangle(cornerRadius: 25) // Bentuk yang sama dengan latar belakang
                                .stroke(Color.black, lineWidth: 1) // Warna dan ketebalan border
                        )
            .bold()
    }
}
struct CardViewKecil: View {
    let card: Datum

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: card.imageUris.small)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 4)
                    )
                
            } placeholder: {
                ProgressView()
            }
            let number = card.collectorNumber
                Text("#\(number)")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(4)
            
            
        }
        
        .frame(width: 80, height: 120)
    }
}


struct LegalitiesView: View {
    var legalities: Legalities

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
            
                ForEach(legalities.toKeyValueArray(), id: \.0) { legality in
                    HStack{
                    Text(legality.1.capitalized)
                            .font(.system(size: 12)).bold()
                        .padding(5)
                        .frame(width: 80, height: 30)
                        .background(backgroundColor(for: legality.1))
                        .foregroundColor(.black)
                        .cornerRadius(5)
                    
                    Text(legality.0.capitalized)
                            .font(.system(size: 12)) .bold()
                }
            }
        }
    }
    

    private func backgroundColor(for legality: String) -> Color {
        switch legality {
        case "legal":
            return Color.green
        case "not_legal":
            return Color(.systemGray5)
        case "banned":
            return Color.red
        case "restricted":
            return Color.orange
        default:
            return Color.gray
        }
    }
}

// Key untuk menyimpan dan mengirimkan nilai offset
struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

func parseManaCost(_ manaCost: String) -> [TextOrImage] {
    var components: [TextOrImage] = []
    
    let regex = try! NSRegularExpression(pattern: "\\{([^}]+)\\}")
    let nsString = manaCost as NSString
    let matches = regex.matches(in: manaCost, range: NSRange(location: 0, length: nsString.length))

    var lastIndex = 0

    for match in matches {
        let rangeBefore = NSRange(location: lastIndex, length: match.range.location - lastIndex)
        let textBefore = nsString.substring(with: rangeBefore)
        if !textBefore.isEmpty {
            components.append(.text(textBefore))
        }

        let symbol = nsString.substring(with: match.range(at: 1))
        components.append(.image(symbol))

        lastIndex = match.range.location + match.range.length
    }

    if lastIndex < nsString.length {
        let textAfter = nsString.substring(with: NSRange(location: lastIndex, length: nsString.length - lastIndex))
        components.append(.text(textAfter))
    }

    return components
}

enum TextOrImage: Hashable {
    case text(String)
    case image(String)
}


struct ManaCostView: View {
    let manaCost: String

    var body: some View {
        HStack(spacing: 0) {
            ForEach(parseManaCost(manaCost), id: \.self) { component in
                switch component {
                case .text(let text):
                    Text(text)
                case .image(let symbol):
                    // Pilih gambar berdasarkan simbol
                    if (symbol=="B" || symbol=="R" || symbol=="U" || symbol=="W" || symbol=="G") {
                        Image(imageName(forSymbol: symbol))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    else{
                        GeometryReader { geometry in
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                
                                Text(symbol)
                                    .font(.system(size: geometry.size.width)) // Menyesuaikan ukuran font dengan setengah dari lebar kontainer
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                            }
                        }
                        .frame(width: 20, height: 20)

                    }
                }
            }
        }
    }

    private func imageName(forSymbol symbol: String) -> String {
        switch symbol {
        case "B":
            return "mana_B" // nama file untuk simbol B
        case "R":
            return "mana_R"   // nama file untuk simbol R
        case "U":
            return "mana_U"  // nama file untuk simbol U
        case "W":
            return "mana_W" // nama file untuk simbol W
        case "G":
            return "mana_G" // nama file untuk simbol G
        default:
            return "" // gambar default jika simbol tidak dikenali
        }
    }
}

//func parseOracleText(_ oracleText: String, withImages images: [String: Image]) -> [AnyView] {
//    var components: [AnyView] = []
//    let pattern = "\\{(.*?)\\}" // Regex untuk mencocokkan teks di dalam kurung kurawal
//    let regex = try! NSRegularExpression(pattern: pattern, options: [])
//    let nsString = oracleText as NSString
//    let matches = regex.matches(in: oracleText, options: [], range: NSRange(location: 0, length: nsString.length))
//
//    var lastRangeEnd = 0
//
//    for match in matches {
//        let range = match.range(at: 1) // Dapatkan range untuk teks dalam kurung kurawal
//        let symbol = nsString.substring(with: range) // Dapatkan simbol
//
//        // Tambahkan teks sebelum simbol mana
//        let textRange = NSRange(location: lastRangeEnd, length: range.location - lastRangeEnd)
//        let textBeforeSymbol = nsString.substring(with: textRange)
//        if !textBeforeSymbol.isEmpty {
//            components.append(AnyView(Text(textBeforeSymbol)))
//        }
//
//        // Tambahkan gambar untuk simbol mana jika ada dalam dictionary images
//        if let image = images[symbol] {
//            components.append(AnyView(image.resizable().aspectRatio(contentMode: .fit)))
//        } else {
//            // Jika tidak ada gambar, tambahkan teks simbolnya
//            components.append(AnyView(Text("{\(symbol)}")))
//        }
//
//        lastRangeEnd = range.location + range.length
//    }
//
//    // Tambahkan teks setelah simbol mana terakhir
//    if lastRangeEnd < nsString.length {
//        let textAfterLastSymbol = nsString.substring(from: lastRangeEnd)
//        components.append(AnyView(Text(textAfterLastSymbol)))
//    }
//
//    return components
//}
//
//// Contoh penggunaan fungsi parseOracleText
//struct OracleTextView: View {
//    var oracleText: String
//    var manaImages: [String: Image] // Dictionary yang memetakan simbol mana ke gambar
//
//    var body: some View {
//        HStack(alignment: .top, spacing: 0) {
//            ForEach(0..<parseOracleText(oracleText, withImages: manaImages).count, id: \.self) { index in
//                parseOracleText(oracleText, withImages: manaImages)[index]
//            }
//        }
//    }
//}



func parseOracleText(_ text: String) -> [TextOrImage] {
    var components: [TextOrImage] = []
    let pattern = "\\{([^}]+)\\}"
    
    let regex = try! NSRegularExpression(pattern: pattern)
    let nsString = text as NSString
    let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
    
    var lastIndex = 0

    for match in matches {
        // Teks sebelum simbol mana
        let rangeBefore = NSRange(location: lastIndex, length: match.range.location - lastIndex)
        let textBefore = nsString.substring(with: rangeBefore)
        if !textBefore.isEmpty {
            components.append(.text(textBefore))
        }

        // Simbol mana
        let manaSymbol = nsString.substring(with: match.range(at: 1))
        components.append(.image(manaSymbol))

        lastIndex = match.range.location + match.range.length
    }

    // Teks setelah simbol mana terakhir
    let remainingTextRange = NSRange(location: lastIndex, length: nsString.length - lastIndex)
    let remainingText = nsString.substring(with: remainingTextRange)
    if !remainingText.isEmpty {
        components.append(.text(remainingText))
    }
    
    return components
}

struct OracleTextView: View {
    let oracleText: String
    // ... definisikan ini sesuai dengan model data Anda
    
    var body: some View {
        HStack{
            
            ForEach(parseOracleText(oracleText), id: \.self) { component in
                switch component {
                case .text(let text):
                    Text(text)
                case .image(let symbol):
                    if symbol == "W" {
                        Image("mana_W") // Pastikan gambar dengan nama "mana_W" ada di Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    } else if symbol == "B" {
                        Image("mana_B") // Pastikan gambar dengan nama "mana_B" ada di Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }else if symbol == "R" {
                        Image("mana_R") // Pastikan gambar dengan nama "mana_B" ada di Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }else if symbol == "U" {
                        Image("mana_U") // Pastikan gambar dengan nama "mana_B" ada di Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }else if symbol == "G" {
                        Image("mana_G") // Pastikan gambar dengan nama "mana_B" ada di Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    } else {
                        GeometryReader { geometry in
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                
                                Text(symbol)
                                    .font(.system(size: geometry.size.width)) // Menyesuaikan ukuran font dengan setengah dari lebar kontainer
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                            }
                        }
                        .frame(width: 20, height: 20)// Jika simbol lain, tampilkan teks
                    }
                }
                
            }
        }
    }
}

//func attributedOracleText(_ oracleText: String) -> AttributedString {
//    var attributedString = AttributedString(oracleText)
//
//    // Temukan semua kejadian simbol mana
//    do {
//        let regex = try NSRegularExpression(pattern: "\\{([WUBRG/]+)\\}")
//        let results = regex.matches(in: oracleText, range: NSRange(oracleText.startIndex..., in: oracleText))
//
//        for result in results.reversed() { // Reverse the results to replace from the end
//            if let range = Range(result.range, in: oracleText) {
//                let manaSymbols = oracleText[range]
//                var inlineContent = AttributedString()
//
//                // Iterate through each character in manaSymbols
//                for char in manaSymbols {
//                    if char == "W" || char == "B" || char == "R" || char == "U" || char == "G" {
//                        let imageAttachment = NSTextAttachment()
//                        let image = UIImage(named: "mana_\(char)")! // Assuming images are named like "mana_W", "mana_B", etc.
//                        imageAttachment.image = image
//                        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20) // Adjust as needed
//                        inlineContent.append(NSAttributedString(attachment: imageAttachment))
//                    } else if char == "/" {
//                        inlineContent.append(" / ")
//                    }
//                }
//
//                // Replace the original text with the image attachment
//                attributedString.replaceSubrange(range, with: inlineContent)
//            }
//        }
//    } catch {
//        print("Failed to create regex: \(error)")
//    }
//
//    return attributedString
//}
//extension String {
//    func replacingOccurrencesOfManaSymbols() -> AttributedString {
//        var attributedString = AttributedString(self)
//
//        // Temukan semua kejadian simbol mana
//        do {
//            let regex = try NSRegularExpression(pattern: "\\{(.*?)\\}")
//            let nsString = self as NSString
//            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
//
//            for result in results.reversed() { // Lakukan penggantian dari belakang agar indeks tidak berubah
//                if let swiftRange = Range(result.range, in: self) {
//                    let symbol = nsString.substring(with: result.range(at: 1))
//                    let imageString = AttributedString(symbol)
//
//                    // Ganti {W} atau {B} dengan simbol mana sesuai
//                    if symbol == "W" || symbol == "B" || symbol == "R" || symbol == "U" || symbol == "G" {
//                        // Membuat attachment sebagai image jika anda membutuhkan custom view
//                        // Untuk sementara, kita akan menggunakan string biasa untuk representasi
//                        attributedString.replaceSubrange(swiftRange, with: imageString)
//                    }
//                }
//            }
//        } catch {
//            print("Failed to create regex: \(error)")
//        }
//
//        return attributedString
//    }
//}


func parseTextWithManaSymbols(_ text: String) -> [Text] {
    let pattern = "\\{([^\\}]+)\\}"
    let regex = try! NSRegularExpression(pattern: pattern)
    let nsString = text as NSString
    let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
    var lastEnd = 0
    var parsed: [Text] = []
    
    results.forEach { result in
        let range = result.range
        if lastEnd < range.location {
            let substring = nsString.substring(with: NSRange(location: lastEnd, length: range.location - lastEnd))
            parsed.append(Text(substring))
        }
        
        let symbol = nsString.substring(with: result.range(at: 1))
        switch symbol {
        case "W", "B", "R", "U", "G":
            parsed.append(Text(verbatim: " ")) // Separator for the image
            parsed.append(Text(Image("mana_B" ))) // Replace with your mana symbol image
            parsed.append(Text(verbatim: " ")) // Separator after the image
        default:
            break
        }
        
        lastEnd = range.location + range.length
    }
    
    if lastEnd < nsString.length {
        let substring = nsString.substring(from: lastEnd)
        parsed.append(Text(substring))
    }
    
    return parsed
}

#Preview {
    ContentView()
}

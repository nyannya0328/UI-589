//
//  Home.swift
//  UI-589
//
//  Created by nyannyan0328 on 2022/06/16.
//

import SwiftUI

struct Home: View {
    @State var albums : [Album] = sampleAlbums
    @State var currentIndex : Int = 0
    @State var curretnAlbum = sampleAlbums.first!
    var body: some View {
        VStack(spacing:0){
            
            
            Text(attString)
                  .frame(maxWidth: .infinity,alignment: .leading)
                  .padding(.bottom,40)
            
            
            VStack{
                albumArtworkScroller()
                    .zIndex(1)
                
                standView
                    .zIndex(0)
            }
            .padding(-15)
            .zIndex(1)
            
            
            TabView{
                
                ForEach($albums){$alubum in
                    
                    AlbumCardView(alubum: alubum)
                        .offsetX { value, width in
                            
                            if currentIndex == getIndex(alubum: alubum){
                                
                                
                                var offset = ((value > 0 ? -value : value) / width) * 80
                                offset = (-offset < 80 ? offset : -80)
                                alubum.diskOffset = offset
                                
                            }
                            
                            
                            if value == 0 && currentIndex != getIndex(alubum: alubum){
                                
                                alubum.diskOffset = 0
                                
                                
                                withAnimation(.easeOut(duration: 0.6)){
                                    
                                    albums[currentIndex].showDisk = false
                                    currentIndex = getIndex(alubum: alubum)
                                    curretnAlbum = albums[currentIndex]
                                }
                                
                                
                                withAnimation(.interactiveSpring(response: 0.5,dampingFraction:1,blendDuration:1).delay(0.4)){
                                    
                                    albums[currentIndex].showDisk = true
                                   
                                }
                                
                                
                                
                                
                                
                            }
                            
                        }
                    
                    
                }
                
                
                
            }
            .padding(.horizontal,-15)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .zIndex(0)
            
            
            
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .background{
         
            Color("BG").ignoresSafeArea(.all)
            
        }
        .onAppear{
            
            withAnimation(.interactiveSpring(response: 0.5,dampingFraction:1,blendDuration:1).delay(0.4)){
                
                albums[currentIndex].showDisk = true
            }
            
        
        }
    }
    
    func getIndex(alubum : Album) -> Int{
        
        return albums.firstIndex { albume in
           return  alubum.id == albume.id
        } ?? 0
        
    }
    
    @ViewBuilder
    func AlbumCardView(alubum : Album)->some View{
        
        
        VStack(alignment:.leading,spacing: 6){
            
            
            HStack{
                
                
                  Text("Alubum")
                    .font(.title3)
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                
                HStack(spacing:5){
                    
                    ForEach(1...5,id:\.self){index in
                        
                        
                         Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.gray.opacity(index > alubum.rating ? 0.2 : 1))
                        
                        
                    }
                    
                    Text("\(alubum.rating).0")
                        .font(.caption.bold())
                }
                
            }
            
            
            
            Text(alubum.albumName)
                .font(.title.bold())
            
            
            Label {
                  Text("Alriana Grande")
            } icon: {
                
                Text("By")
                    .foregroundColor(.gray.opacity(0.2))
            }
            
            
            Text(sampleText)
                .font(.caption.bold())
                .foregroundColor(.gray.opacity(0.6))
                .padding(.top)
            
            
            HStack(spacing:10){
                
                ForEach(["Punk","Clasic Rock","Art Rock"],id:\.self){name in
                    
                    Toggle(name, isOn: .constant(false))
                        .buttonStyle(.bordered)
                        .toggleStyle(.button)
                        .tint(.gray)
                        .font(.caption)
                    
                }
            }
            .padding(.top)

        }
        .padding(.top,30)
        .padding([.horizontal,.bottom])
      
        .background{
         
            
            CustomCorner(cornrer: [.bottomLeft,.topRight], radi: 10)
                .fill(.white.opacity(0.6))
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .padding(.horizontal)
        
    }
    
    @ViewBuilder
    func albumArtworkScroller()->some View{
        
        GeometryReader{proxy in
             let size = proxy.size
            
            LazyHStack(spacing:0){
                
                
                ForEach($albums){$album in
                    
                    
                    HStack(spacing:0){
                        
                        Image(album.albumImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:180,height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                            .zIndex(1)
                        
                        
                        Image("Disk")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:150,height: 150)
                            .overlay {
                                
                                Image(album.albumImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:60,height: 60)
                                    .clipShape(Circle())
                                  
                                    
                            }
                            .rotationEffect(.init(degrees: album.showDisk ? 0 : 40))
                            .rotationEffect(.init(degrees: album.diskOffset / -80) * 40)
                            .offset(x:album.showDisk ? 80 : 0)
                            .offset(x:album.showDisk ? album.diskOffset : 0)
                            .scaleEffect(album.showDisk ? 1 : 0.1)
                            
                            .padding(.leading,-170)
                            .zIndex(0)
                        
                        
                        
                    }
                    .offset(x:-40)
                    
                    .frame(width:size.width,alignment: currentIndex > getIndex(alubum: album) ? .trailing : currentIndex == getIndex(alubum: album) ? .center : .leading)
                    
                    .scaleEffect(curretnAlbum.id == album.id ? 1 : 0.8,anchor: .bottom)
                    .offset(x:currentIndex > getIndex(alubum: album) ? 100 : currentIndex == getIndex(alubum: album) ? 0 : -40)
                    
                    
                }
            }
            .offset(x:CGFloat(currentIndex) * -size.width)
            
            
        }
        .frame(height:180)
    }
    
    var standView : some View{
        
        Rectangle()
            .fill(.white.opacity(0.6))
            .shadow(color: .black.opacity(0.85), radius: 20,x: 0,y:5)
            .frame(height:10)
            .overlay(alignment: .top) {
                
                
                Rectangle()
                    .fill(.white.opacity(0.75).gradient)
                    .frame(height:385)
                    .rotation3DEffect(.init(degrees: -98), axis: (x: 1, y: 0, z: 0),anchor: .top,anchorZ: 0.5,perspective: 1)
                    .shadow(color: .black.opacity(0.08), radius: 20,x: 0,y:5)
                    .shadow(color: .black.opacity(0.08), radius: 5,x: 0,y:15)
                
            }
            .scaleEffect(1.5)
        
    }
    var attString : AttributedString{
        
        var str = AttributedString(stringLiteral: "My Library")
        
        if let range = str.range(of: "Library"){
            str[range].font = .largeTitle.bold()
            
        }
        
        return str
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View{
    
    func offsetX(competion : @escaping(CGFloat,CGFloat)->())->some View{
        
        self
            .overlay {
                
                GeometryReader{proxy in
                    
                    Color.clear
                        .preference(key: OffsetKey.self ,value: proxy.frame(in: .global).minX)
                        .onPreferenceChange(OffsetKey.self) { value in
                            competion(value,proxy.size.width)
                        }
                }
            }
    }
}

struct OffsetKey : PreferenceKey{
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

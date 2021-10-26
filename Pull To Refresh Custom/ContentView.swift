//
//  ContentView.swift
//  Pull To Refresh Custom
//
//  Created by Mikhail Smirnov on 07.10.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


var mainColor:Color = Color(red: 0.6, green: 0.9, blue: 0.7)

struct Refresh {
    var offsetAction:CGFloat = 60
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool = false
    var released: Bool = false
    var invalid:Bool = false
}


struct Home : View {
    
    @State var arr = ["item1","item2","item3"] //,"item4","item5","item1","item2","item3","item4","item5"]
    
    @State var refresh:Refresh = Refresh(startOffset: 0, offset: 0, started: false, released: false)
    
    
    var body: some View{
        
        VStack(spacing:0)
        {
            
            
            HStack
            {
                Text("Pull to refresh")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(mainColor)
                
                Spacer()
            }
            .padding()
            .background(Color.white.ignoresSafeArea(.all, edges: .top))
            
            Divider();
            
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                
                GeometryReader{reader -> AnyView in
                    
                    DispatchQueue.main.async
                    {
                        if refresh.startOffset == 0
                        {
                            refresh.startOffset = reader.frame(in: .global).minY
                        }
                        
                        refresh.offset = reader.frame(in: .global).minY
                        
                        if abs(refresh.offset-refresh.startOffset) > refresh.offsetAction && !refresh.started
                        {
                            refresh.started = true
                            print("started")
                        }
                        
                        if refresh.startOffset == refresh.offset && refresh.started && !refresh.released
                        {
                            withAnimation(Animation.linear)
                            {
                                refresh.released = true
                            }
                            
                            print("released")
                            
                            updateDataScrollView();
                        }
                        
                        if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid
                        {
                            print("catch invalid")
                            refresh.invalid = false
                            updateDataScrollView();
                        }
                        
                        
                        
                        
                    }
                    return AnyView(Color.black.frame(width: 0, height: 0))
                }
                .frame(width: 0, height: 0)          
                
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top))
                {
                    
                    if refresh.started && refresh.released
                    {
                        ProgressView()
                            .offset(y:-35)
                            .progressViewStyle(CircularProgressViewStyle(tint: mainColor))
                    }
                    else
                    {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(mainColor)
                            .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                            .offset(x: 0, y: -30)
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    }
                    
                    
                    VStack{
                        
                        ForEach(arr, id:\.self){value in
                            
                            HStack
                            {
                                Text(value)
                                Spacer();
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.black)
                            }
                            .padding()
                            
                        }
                        
                        
                        
                    }
                    .background(Color.white)
                    
                    
                    
                }
                .offset(y: refresh.released ? 40 : -10);
                
            })
            
            
            
        }
        .background(Color.black.opacity(0.02).ignoresSafeArea())
        
    }

    func updateDataScrollView()
    {
        print("updating")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1)
        {
            withAnimation(Animation.linear)
            {
                
                if refresh.startOffset == refresh.offset
                {
                    arr.append("updated")
                    refresh.started = false
                    refresh.released = false
                }
                else
                {
                    refresh.invalid = true
                }
                
                
                
            }
            
        }
        
        
    }

}

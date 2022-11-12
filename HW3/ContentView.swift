//
//  ContentView.swift
//  HW3
//
//  Created by Yu Zhi on 2022/11/11.
//

import SwiftUI

struct ContentView: View {
    @State private var themecolor = Color.blue
    @State private var name = ""
    @State private var showtoggle = false
    @State private var eatBagel = false
    @State private var selectDate = Date()
    @State private var Saucepick = 0
    @State private var Breadpick = 0
    @State private var Extrapick = 0
    @State private var extraCount = 1
    @State private var orders = [order]()
    @State private var showList = false
    @State private var showAlert = false
    @State private var add = true
    @State private var showtoggle1 = false
    @State private var score = [Double]()
    
    var body: some View {
        VStack{
            Text("Bagel Life 🥯")
                .font(.title)
                .fontWeight(.bold)
            GeometryReader{geometry in
                Image("Image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.width / 4 * 3)
                    .clipped()
            }.frame(height: 230)
            
            Form{
                ColorPicker("Set the theme color", selection: $themecolor)
                HStack{
                    TextField("Name", text: $name, prompt: Text("Name"))
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius:20).stroke(themecolor,lineWidth:1))
                    Button(action: {self.showtoggle = true}){
                        Text("Go!")
                            .font(.system(size:15))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(themecolor)
                            .cornerRadius(40)
                    }
                }
                if(showtoggle){
                    Toggle(isOn: $eatBagel){
                        Text(eatBagel ? "\(name) wants some bagels！" : "\(name) wants some bagels！")
                    }.toggleStyle(SwitchToggleStyle(tint: themecolor))
                    
                    if(eatBagel){
                        DatePicker("Date",selection: $selectDate, in: Date()..., displayedComponents: .date)
                            .accentColor(themecolor)
                        breadpicker(breads: self.$Breadpick)
                        saucePicker(sauces: self.$Saucepick)
                        
                        Toggle(isOn: $showtoggle1){
                            Text(showtoggle1 ? "Any extra?" : "Any extra?")
                        }.toggleStyle(SwitchToggleStyle(tint: themecolor))
                        if(showtoggle1){
                            extraPicker(extras: self.$Extrapick)
                            HStack{
                                extraStepper(extraCount: self.$extraCount)
                                Button (action:{
                                    orders.append(order(time: selectDate, bread: bread[Breadpick], sauce: sauce[Saucepick], extra: extra[Extrapick], count: Int(extraCount), score: 0))
                                    score.append(0.0)
                                }){
                                    Text("Add to list")
                                        .font(.system(size: 10))
                                        .fontWeight(.bold)
                                        .padding(7)
                                        .foregroundColor(.white)
                                        .background(themecolor)
                                        .cornerRadius(50)
                                }
                            }
                        }else{
                            HStack{
                                Spacer()
                                Button (action:{
                                    orders.append(order(time: selectDate, bread: bread[Breadpick], sauce:   sauce[Saucepick], extra: "None", count: Int(extraCount), score: 0))
                                    score.append(0.0)
                                    
                                }){
                                    Text("Add to list")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .padding(7)
                                        .foregroundColor(themecolor)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }.contextMenu{
                Button{
                    formView(themecolor: $themecolor, name: $name, showtoggle: $showtoggle, eatBagel: $eatBagel, selectDate: $selectDate, Saucepick: $Saucepick, Breadpick: $Breadpick, Extrapick: $Extrapick, extraCount: $extraCount, orders: $orders, showtoggle1: $showtoggle1, score: $score)
                }label: {
                    Label {
                        Text("Reset")
                    } icon: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            }
            Random(orders: $orders, themecolor: $themecolor, selectDate: $selectDate, score: $score,name: $name)
            Button(action:{
                if name == ""{
                    showList = false
                    showAlert = true
                }else{
                    showList = true
                }
                
            }){
                Text("Check List")
                    .font(.headline)
                    .padding()
                    .background(themecolor)
                    .cornerRadius(30)
                    .foregroundColor(.white)
                    .padding(9)
            }.alert(isPresented: $showAlert){
                return Alert(title: Text("Please fill in the name"),dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showList) {
                ListView(orders: $orders, themecolor: $themecolor, showList: $showList ,selectDate: $selectDate,score: $score, name: $name)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct breadpicker: View{
    @Binding var breads:Int
    var body: some View{
        Picker("Bread Flavor", selection: self.$breads){
            ForEach(bread.indices){(index) in
                Text(bread[index])
                
            }
        }.pickerStyle(.menu)
    }
}

struct saucePicker: View{
    @Binding var sauces:Int
    var body: some View{
        Picker("Choose sauce!", selection: self.$sauces) {
            ForEach(sauce.indices){
                (index) in
                Text(sauce[index])
            }
        }.pickerStyle(.menu)
    }
}

struct extraPicker: View{
    @Binding var extras:Int
    
    var body: some View{
        Picker("Any extras", selection: self.$extras){
            ForEach(extra.indices){
                (index) in Text(extra[index])
            }
        }.pickerStyle(.wheel)
    }
}

struct extraStepper: View{
    @Binding var extraCount:Int

    var body: some View{
            Stepper("add \(extraCount) to bagel", value: $extraCount, in: 1...5)
    }
}

struct ListView: View{
    @Binding var orders: [order]
    @Binding var themecolor: Color
    @Binding var showList: Bool
    @State private var showingSheet = false
    @State private var showAlert = false
    @Binding var selectDate : Date
    @Binding var score : [Double]
    @Binding var name : String
    var body: some View{
        VStack{
            Text("\(name)'s List:")
                .font(.title)
                .fontWeight(.bold)
            ScrollView{
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(orders.indices) { (index) in
                        Text((orders[index].time.formatted(date: .long, time: .omitted)))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(themecolor)
                            .opacity(0.8)
                            .cornerRadius(10)
                        if((orders[index].extra) != "None"){
                            Text(" Bread: \(orders[index].bread)\n Sauce: \(orders[index].sauce) + \(orders[index].extra) * \(orders[index].count) ")
                                .font(.system(size: 13))
                                .foregroundColor(themecolor)
                        }else{
                            Text(" Bread: \(orders[index].bread)\n Sauce: \(orders[index].sauce)")
                                .font(.system(size: 13))
                                .foregroundColor(themecolor)
                        }
                        
                        VStack(alignment:.leading){
                            Text("Score is \(Int(score[index]))")
                                .foregroundColor(themecolor)
                                .fontWeight(.bold)
                            Slider(value: $score[index],in: 1...10,step: 1.0){
                                Text("score")
                            }minimumValueLabel: {
                                Text("☹️")
                            }maximumValueLabel: {
                                Text("🥰")
                            }
                                
                        }
                    }
                    
                }//Vstack
            }.frame(width: 300,height: 600)
            Button {
                showAlert = true
                
            } label: {
                Text("Complete")
                    .foregroundColor(themecolor)
                    .padding(7)
            }.alert(isPresented: $showAlert) {
                return Alert(title: Text("Enjoy ur 🥯"),dismissButton: .default(Text("Sure")))
            }
            
            Button(action:{
                self.showList = false
            }){
                Text("Back to menu")
            }
        }
    }
}

struct Random: View{
    @Binding var orders: [order]
    @Binding var themecolor: Color
    @Binding var selectDate : Date
    @Binding var score : [Double]
    @Binding var name : String
    @State private var showlist = false
    @State private var showalert = false
    let time : String = ""
    var body: some View{
        HStack{
            Text("Have no idea?")
            Button(action:{
                showalert = true
                let rBread = Int.random(in: 0...bread.count - 1)
                let rSauce = Int.random(in: 0...sauce.count-1)
                let rExtra = Int.random(in: 0...extra.count-1)
                let rcount = Int.random(in: 1...5)
                orders.append(order(time: selectDate, bread: bread[rBread], sauce: sauce[rSauce], extra: extra[rExtra], count: Int(rcount), score: 0))
                score.append(0.0)
            }) {
                Text(" click me ")
            }.alert(isPresented: $showalert) {
                return Alert(title: Text("Are you sure the Date is \(selectDate.formatted(date: .long, time: .omitted)) ?"), primaryButton: .default(Text("Yes"),action: {
                    showlist = true
                }), secondaryButton: .default(Text("Modify")))
            }
            .sheet(isPresented: $showlist) {
                ListView(orders: $orders, themecolor: $themecolor, showList: $showlist ,selectDate: $selectDate,score: $score,name: $name)
            }
        }
    }
}

struct formView: View{
    @Binding var themecolor : Color
    @Binding var name : String
    @Binding var showtoggle :Bool
    @Binding var eatBagel :Bool
    @Binding var selectDate : Date
    @Binding var Saucepick : Int
    @Binding var Breadpick :Int
    @Binding var Extrapick : Int
    @Binding var extraCount :Int
    @Binding var orders : [order]
    @Binding var showtoggle1 :Bool
    @Binding var score : [Double]
    var body: some View{
        Form{
            ColorPicker("Set the theme color", selection: $themecolor)
            HStack{
                TextField("Name", text: $name, prompt: Text("Name"))
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius:20).stroke(themecolor,lineWidth:1))
                Button(action: {self.showtoggle = true}){
                    Text("Go!")
                        .font(.system(size:15))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(themecolor)
                        .cornerRadius(40)
                }
            }
            if(showtoggle){
                Toggle(isOn: $eatBagel){
                    Text(eatBagel ? "\(name) wants some bagels！" : "\(name) wants some bagels！")
                }.toggleStyle(SwitchToggleStyle(tint: themecolor))
                
                if(eatBagel){
                    DatePicker("Date",selection: $selectDate, in: Date()..., displayedComponents: .date)
                        .accentColor(themecolor)
                    breadpicker(breads: self.$Breadpick)
                    saucePicker(sauces: self.$Saucepick)
                    
                    Toggle(isOn: $showtoggle1){
                        Text(showtoggle1 ? "Any extra?" : "Any extra?")
                    }.toggleStyle(SwitchToggleStyle(tint: themecolor))
                    if(showtoggle1){
                        extraPicker(extras: self.$Extrapick)
                        HStack{
                            extraStepper(extraCount: self.$extraCount)
                            Button (action:{
                                orders.append(order(time: selectDate, bread: bread[Breadpick], sauce: sauce[Saucepick], extra: extra[Extrapick], count: Int(extraCount), score: 0))
                                score.append(0.0)
                            }){
                                Text("Add to list")
                                    .font(.system(size: 10))
                                    .fontWeight(.bold)
                                    .padding(7)
                                    .foregroundColor(.white)
                                    .background(themecolor)
                                    .cornerRadius(50)
                            }
                        }
                    }else{
                        HStack{
                            Spacer()
                            Button (action:{
                                orders.append(order(time: selectDate, bread: bread[Breadpick], sauce:   sauce[Saucepick], extra: "None", count: Int(extraCount), score: 0))
                                score.append(0.0)
                                
                            }){
                                Text("Add to list")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding(7)
                                    .foregroundColor(themecolor)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

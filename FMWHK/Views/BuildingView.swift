//
//  BuildingView.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

import SwiftUI

struct BuildingView: View {
    @State var buildingVM: BuildingViewModel;
    @EnvironmentObject var menuBarOject: MenuBarOject
    @Environment(\.presentationMode) var presentationMode
    @State private var locationList: [IdentifiableLocation] = []
    
    var body: some View {
        ZStack {
            mainBkColor.ignoresSafeArea()
            ScrollView{
                VStack{
                    Image(buildingVM.buildingImg)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                        .clipped()
                        .cornerRadius(10)
                        .padding(.top, 30)
                        .padding(.horizontal, 20)
                    
                    MapView(center: buildingVM.coordinate, span: 0.002, locations: locationList)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.screenHeight/3)
                        .cornerRadius(10)
                        .padding()
                    
                    Text(buildingVM.buildingName)
                        .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Text(buildingVM.buildingDesc)
                        .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                        .font(.caption)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
            }
            .foregroundColor(.white)
            .scrollIndicators(.hidden)
            .foregroundStyle(Color.white)
            .background(mainBkColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        Button {
                            menuBarOject.isShowMenuBtn = true
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                        }
                        Text(buildingVM.buildingName)
                            .foregroundStyle(.white)
                            .font(.title3)
                            .bold()
                            .padding(.trailing)

                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            menuBarOject.isShowMenuBtn = false
            locationList = [IdentifiableLocation(coordinate: self.buildingVM.coordinate, pinImage: "building.columns", text: buildingVM.buildingName)]
        }
    }
}

struct BuildingRowView: View {
    @State var buildingVM: BuildingViewModel;
    
    var body: some View {
        VStack{
            Image(buildingVM.buildingImg)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                .clipped()
                .cornerRadius(10)
                .padding(.top, 30)
                .padding(.horizontal, 20)
            Text(buildingVM.buildingName)
                .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                .font(.title)
                .bold()
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            Text(buildingVM.buildingDesc)
                .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                .font(.caption)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    BuildingRowView(buildingVM: globalBuildingList[0])
}

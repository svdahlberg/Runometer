//
//  TestTransition.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2/4/22.
//  Copyright © 2022 Svante Dahlberg. All rights reserved.
//

import SwiftUI

struct TestTransition: View {

    @Namespace private var namespace
    @State private var isShowingDetail = false

    @State private var isShowingDetailContent = false

    var body: some View {

        ZStack {

            Color(.gray)
                .ignoresSafeArea()

            if isShowingDetail {
                ZStack {

                    Color.blue
                        .matchedGeometryEffect(id: "background", in: namespace)
                        .mask {
                            RoundedRectangle(cornerRadius: 30)
                                .matchedGeometryEffect(id: "mask", in: namespace)
                        }
                        .ignoresSafeArea()

                    ScrollView {

                        VStack {
                            VStack {
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Text("8")
                                        .font(.title)
                                        .fontWeight(.heavy)
                                        .matchedGeometryEffect(id: "value", in: namespace)
                                    Text("km")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                        .matchedGeometryEffect(id: "unitSymbol", in: namespace)
                                }
                                Text("Average Distance")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(Colors.orange))
                                    .matchedGeometryEffect(id: "title", in: namespace)
                            }
                            Spacer()
                        }
                        .padding()

                        if isShowingDetailContent {
                            // Chart view
                        }
                    }

                    Button {
                        withAnimation {
                            isShowingDetail = false
                            isShowingDetailContent = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.bold())
                            .foregroundColor(Color(Colors.text))
                            .padding(8)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation() {
                            isShowingDetailContent = true
                        }
                    }
                }



            } else {

                Button {
                    withAnimation {
                        isShowingDetail = true
                    }
                } label: {
                    VStack {
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            Text("8")
                                .font(.title)
                                .fontWeight(.heavy)
                                .matchedGeometryEffect(id: "value", in: namespace)
                            Text("km")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .matchedGeometryEffect(id: "unitSymbol", in: namespace)
                        }
                        Text("Average Distance")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(Color(Colors.orange))
                            .matchedGeometryEffect(id: "title", in: namespace)
                    }
                    .padding()

                    .background(
                        Color.blue
                            .matchedGeometryEffect(id: "background", in: namespace)
                    )
                    .mask {
                        RoundedRectangle(cornerRadius: 13)
                            .matchedGeometryEffect(id: "mask", in: namespace)
                    }

                }
                .buttonStyle(ScaleButtonStyle())

            }
        }
    }
}

struct TestTransition_Previews: PreviewProvider {
    static var previews: some View {
        TestTransition()
    }
}

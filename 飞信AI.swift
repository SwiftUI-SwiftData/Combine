//
//  ContentView.swift
//  飞信
//
//  Created by 李杰 on 2024/1/1.
//

import SwiftUI

struct 飞信Contact: View {
    @AppStorage("showModal") var showModal = false
    @AppStorage("选择标签") var 选择标签: 枚举标签 = .简讯
    @StateObject private var 消息管理器 = 消息管理()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
                switch 选择标签 {
                case .简讯:
                    ContactListView()
                case .聊天:  // 新增聊天视图
                    聊天视图(消息管理器: 消息管理器)
                case .护珍:
                    Text("b")
                case .仆之:
                    Text("c")
                }
            
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
            标签栏()
            if showModal {
                注册与登录()
                .zIndex(1)
            }
        }
    }
}


// 新增聊天视图
struct 聊天视图: View {
    @ObservedObject var 消息管理器: 消息管理
    @State private var 新消息 = ""
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(消息管理器.消息数组) { 消息 in
                        消息气泡(消息: 消息)
                    }
                }
            }
            
            HStack {
                TextField("输入消息", text: $新消息)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("发送") {
                    消息管理器.发送消息(内容: 新消息)
                    新消息 = ""
                }
            }
            .padding()
        }
    }
}

// 消息数据模型和管理器
struct 消息: Identifiable {
    let id = UUID()
    let 内容: String
    let 时间戳 = Date()
    let 发送者: 发送方向 = .user
}

enum 发送方向 {
    case user
    case other
}

class 消息管理: ObservableObject {
    @Published var 消息数组 = [消息]()
    
    func 发送消息(内容: String) {
        let 新消息 = 消息(内容: 内容)
        消息数组.append(新消息)
    }
}

// 消息气泡组件
struct 消息气泡: View {
    let 消息: 消息
    
    var body: some View {
        HStack {
            if 消息.发送者 == .user {
                Spacer()
            }
            Text(消息.内容)
                .padding()
                .background(消息.发送者 == .user ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            if 消息.发送者 == .other {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}



#Preview {
    飞信Contact()
        .environmentObject(模态())
}

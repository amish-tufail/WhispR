//
//  ContactsView.swift
//  WhispR
//
//  Created by Amish on 22/07/2023.
//

import SwiftUI

// Passed from convo participants array into this as binding

struct ContactsView: View {
    @Environment(ContactsViewModel.self) var contacts
    @Environment(ChatViewModel.self) var chats
    @State private var filterText = ""
    @State var contentOffset = CGFloat(0)
    @State var hasScrolled: Bool = false
    @Binding var isChatting: Bool
    @Binding var newChat: Bool
    @Binding var participants: [UserModel]
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                ScrollDetection(hasScrolled: $hasScrolled)
                content
                    .padding(.top, 60)
            }
            VStack {
                Spacer()
                Button {
                    newChat = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        chats.getChatFor(contact: user)
                        if participants.count > 0 {
                            withAnimation {
                                isChatting = true
                            }
                        }
                    }
                } label: {
                    Text(participants.count > 0 ? "Create Chat" : "Done")
                        .font(Font.Body)
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: 40.0)
                .background(
                    RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                        .fill(participants.count > 0 ? Color.cyan : Color.cyan.opacity(0.65))
                )
                .padding(.horizontal)
            }
        }
        .overlay({
            NavigationBar(title: "Contacts", hasScrolled: $hasScrolled)
        })
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ContactsView(isChatting: .constant(false), newChat: .constant(false), participants: .constant([]))
            .environment(ContactsViewModel())
            .environment(ChatViewModel())
    }
}

extension ContactsView {
    var content: some View {
        ZStack {
            VStack {
                ZStack {
                    if filterText == "" {
                        Rectangle()
                            .foregroundStyle(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                            )
                    } else {
                        GradientOverlay(cornerRadius: 20.0, height: 48.0, color: .white, lineWidth: 1.5)
                    }
                    TextField("", text: $filterText, prompt: Text("Search for contacts").foregroundStyle(.black.opacity(0.65)))
                        .font(Font.TabBar)
                        .foregroundStyle(.black)
                        .padding()
                }
                .frame(height: 46.0)
                .padding(.top, 20)
                if contacts.users.count > 0 {
                    // TODO: Add your no details
                    VStack {
                        ScrollView {
                            ForEach(contacts.users.filter { contact in
                                filterText.isEmpty || contact.givenName?.localizedCaseInsensitiveContains(filterText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) ?? false || contact.lastName?.localizedCaseInsensitiveContains(filterText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) ?? false || contact.phoneNumber?.localizedCaseInsensitiveContains(filterText) ?? false
                            }) { user in
    //                            Button {
    //                                newChat = false
    //                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
    //                                    chats.getChatFor(contact: user)
    //                                    withAnimation {
    //                                        isChatting = true
    //                                    }
    //                                }
    //                            } label: {
    //                                ContactRow(user: user)
    //                                    .listRowSeparatorTint(.white.opacity(0.20))
    //
    //                            }
                                let isSelected = participants.contains { participant in
                                    participant.id == user.id
                                }
                                ZStack {
                                    ContactRow(user: user)
                                        .listRowSeparatorTint(.white.opacity(0.20))
                                    Button {
                                        if isSelected {
//                                            participants.removeAll()
                                            let index = participants.firstIndex(of: user)
                                            if let index = index {
                                                participants.remove(at: index)
                                            }
                                        } else {
//                                            participants.removeAll()
                                            if participants.count < 10 {
                                                participants.append(user)
                                            } else {
                                                // TODO: Show message of limit reached
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Spacer()
                                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                                .resizable()
                                                .frame(width: 25.0, height: 25.0)
                                                .foregroundStyle(isSelected ? Color.cyan : Color.white.opacity(0.65))
                                        }
                                    }
                                    .padding(.vertical, 8.0)
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listStyle(.plain)
                            .padding(.top, 12.0)
                            .padding(.horizontal)
                        }
                    }
                } else {
                    Spacer()
                    Image(.noContactsYet)
                    Text("Hmm... Zero contacts?")
                        .foregroundStyle(.white)
                        .font(Font.Title)
                        .padding(.top, 32.0)
                    Text("Try saving some contacts on your phone!")
                        .foregroundStyle(.white)
                        .font(Font.TabBar)
                        .padding(.top, 8.0)
                    Spacer()
                }
            }
            .padding(.horizontal)
        }
    }
}


//var body: some View {
//    ZStack {
//        VStack {
////                HStack {
////                    Text("Contacts")
////                        .foregroundStyle(.white)
////                        .font(Font.PageTitle)
////                    Spacer()
//////                    Button {
//////                        newChat = false
//////                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//////    //                        chats.getChatFor(contact: user)
//////                            if participants.count > 0 {
//////                                withAnimation {
//////                                    isChatting = true
//////                                }
//////                            }
//////                        }
//////                    } label: {
//////                       Text("Create Chat")
//////                            .font(Font.Body)
//////                            .foregroundStyle(.white)
//////                            .padding(.horizontal)
//////                            .frame(height: 30.0)
//////                            .background(
//////                                RoundedRectangle(cornerRadius: 8.0, style: .continuous)
//////                                    .fill(participants.count > 0 ? Color.cyan : Color.secondary)
//////                            )
//////                    }
////                }
////                .padding(.top, 20.0)
//            ZStack {
//                if filterText == "" {
//                    Rectangle()
//                        .foregroundStyle(.white)
//                        .clipShape(
//                            RoundedRectangle(cornerRadius: 20.0, style: .continuous)
//                        )
//                } else {
//                    GradientOverlay(cornerRadius: 20.0, height: 48.0, color: .white, lineWidth: 1.5)
//                }
//                TextField("", text: $filterText, prompt: Text("Search for contacts").foregroundStyle(.black.opacity(0.65)))
//                    .font(Font.TabBar)
//                    .foregroundStyle(.black)
//                    .padding()
//            }
//            .frame(height: 46.0)
//            if contacts.users.count > 0 {
//                // TODO: Add your no details
//                VStack {
//                    ScrollView {
//                        ForEach(contacts.users.filter { contact in
//                            filterText.isEmpty || contact.givenName?.localizedCaseInsensitiveContains(filterText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) ?? false || contact.lastName?.localizedCaseInsensitiveContains(filterText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) ?? false || contact.phoneNumber?.localizedCaseInsensitiveContains(filterText) ?? false
//                        }) { user in
////                            Button {
////                                newChat = false
////                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
////                                    chats.getChatFor(contact: user)
////                                    withAnimation {
////                                        isChatting = true
////                                    }
////                                }
////                            } label: {
////                                ContactRow(user: user)
////                                    .listRowSeparatorTint(.white.opacity(0.20))
////
////                            }
//                            let isSelected = participants.contains { participant in
//                                participant.id == user.id
//                            }
//                            ZStack {
//                                ContactRow(user: user)
//                                    .listRowSeparatorTint(.white.opacity(0.20))
//                                Button {
//                                    if isSelected {
////                                            participants.removeAll()
//                                        let index = participants.firstIndex(of: user)
//                                        if let index = index {
//                                            participants.remove(at: index)
//                                        }
//                                    } else {
////                                            participants.removeAll()
//                                        if participants.count < 10 {
//                                            participants.append(user)
//                                        } else {
//                                            // TODO: Show message of limit reached
//                                        }
//                                    }
//                                } label: {
//                                    HStack {
//                                        Spacer()
//                                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
//                                            .resizable()
//                                            .frame(width: 25.0, height: 25.0)
//                                            .foregroundStyle(isSelected ? Color.cyan : Color.white.opacity(0.65))
//                                    }
//                                }
//                                .padding(.vertical, 8.0)
//                            }
//                        }
//                        .listRowBackground(Color.clear)
//                        .listStyle(.plain)
//                        .padding(.top, 12.0)
//                        .padding(.horizontal)
//                    }
//                }
//            } else {
//                Spacer()
//                Image(.noContactsYet)
//                Text("Hmm... Zero contacts?")
//                    .foregroundStyle(.white)
//                    .font(Font.Title)
//                    .padding(.top, 32.0)
//                Text("Try saving some contacts on your phone!")
//                    .foregroundStyle(.white)
//                    .font(Font.TabBar)
//                    .padding(.top, 8.0)
//                Spacer()
//            }
//        }
//        .padding(.horizontal)
//        VStack {
//            Spacer()
//            Button {
//                newChat = false
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
////                        chats.getChatFor(contact: user)
//                    if participants.count > 0 {
//                        withAnimation {
//                            isChatting = true
//                        }
//                    }
//                }
//            } label: {
//                Text(participants.count > 0 ? "Create Chat" : "Done")
//                    .font(Font.Body)
//                    .foregroundStyle(.white)
//                    .padding(.horizontal)
//            }
//            .frame(maxWidth: .infinity, maxHeight: 40.0)
//            .background(
//                RoundedRectangle(cornerRadius: 8.0, style: .continuous)
//                    .fill(participants.count > 0 ? Color.cyan : Color.cyan.opacity(0.65))
//            )
//            .padding(.horizontal)
//        }
//    }
////        .onAppear {
////            do {
////                try contacts.getLocalContacts()
////            } catch {
////                print(error)
////            }
////        }
//}
//}

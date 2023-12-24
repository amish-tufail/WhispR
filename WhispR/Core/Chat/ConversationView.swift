//
//  ConversationView.swift
//  WhispR
//
//  Created by Amish on 23/07/2023.
//

import SwiftUI
import Combine
import SwiftUIX
import Photos
import EmojiPicker

struct ConversationView: View {
//    var user: UserModel
    @Binding var isChatting: Bool
    @State private var gradientColors: [Color] = [Color.pink, Color.orange, Color.cyan, Color.yellow]
    @State var chatMessage: String = ""
    @State private var isAnimating: Bool = false
    @State private var hasScrolled: Bool = false
    @State private var textfieldHeight: CGFloat = 46.0
    @State private var textfieldRadius: CGFloat = 40.0
    @State private var keyboardHeight: CGFloat = 0
    //    @State private var participants: [UserModel] = []
    @Binding var participants: [UserModel]
    @State private var bottomPadding: CGFloat = 0.0
    @State private var imageTapped: Bool = false
    @State private var tappedImage: Image?
    @State var selectedImage: UIImage?
    @State var isPhotoPickerShowing: Bool = false
    @State var isSourceMenuShowing: Bool = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    @State private var offset = CGSize.zero
    @State var change: Bool = false
    @State private var profileDetailShow: Bool = false
    @State private var emojiPickerShow: Bool = false
    @State var selectedEmoji: Emoji?
    @Namespace var chatPhotoNamespace
    @Environment(ChatViewModel.self) var chats
    @Environment(ContactsViewModel.self) var contacts
    
    private var lineHeight: CGFloat {
        return UIFont.preferredFont(forTextStyle: .body).lineHeight
    }
    
    var body: some View {
        //        let photoURL = URL(string: user.photo ?? "")
        let size = UIScreen.main.bounds
        ZStack {
            Color.black.ignoresSafeArea()
                .overlay {
                    //                    Blob3Graphic()
                    Blob2Graphic()
                        .offset(y: size.height / 6)
                }
            VStack {
                ZStack { // this stack was added for blur effect
                    //                    Color.clear
                    //                        .background(.cyan.opacity(0.35))
                    //                        .blur(radius: 10)
                    //                        .opacity(hasScrolled ? 1 : 0)
                    // -- End of scroll View bluw
                    VStack {
                        HStack(spacing: 10.0) {
                            // TODO: Camera Buttons, Theme Change Option in Profile Detail
                            Button {
                                withAnimation {
                                    isChatting = false
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18.0, height: 18.0)
                            }
                            .fontWeight(.semibold)
                            .foregroundStyle(.cyan)
                            .padding(.trailing, 10.0)
                            ZStack {
                                if participants.count > 0 {
                                    if participants.count == 1 {
                                        let participant = participants.first
                                        if let cacheImage = CacheService.shared.getImage(forKey: participant?.photo ?? "") {
                                            cacheImage
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .onTapGesture {
                                                    profileDetailShow = true
                                                }
                                        } else {
                                            AsyncImage(url: URL(string: participant?.photo ?? "")) { phase in
                                                switch phase {
                                                case AsyncImagePhase.empty:
                                                    ProgressView()
                                                case AsyncImagePhase.success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(Circle())
                                                        .onAppear {
                                                            CacheService.shared.setImage(image: image, forKey: participant?.photo ?? "")
                                                        }
                                                    
                                                case AsyncImagePhase.failure:
                                                    ZStack {
                                                        Circle()
                                                            .foregroundStyle(.white)
                                                        Text(participant?.givenName?.prefix(1) ?? "")
                                                            .foregroundStyle(.black)
                                                            .bold()
                                                    }
                                                @unknown default:
                                                    ZStack {
                                                        Circle()
                                                            .foregroundStyle(.white)
                                                        Text(participant?.givenName?.prefix(1) ?? "")
                                                            .foregroundStyle(.black)
                                                            .bold()
                                                    }
                                                }
                                            }
                                            .onTapGesture {
                                                profileDetailShow = true
                                            }
                                        }
                                        Circle()
                                            .stroke(
                                                LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom),
                                                lineWidth: 1.0
                                            )
                                            .animation(.linear(duration: 3).repeatForever(), value: gradientColors)
                                            .onAppear {
                                                startAnimation()
                                            }
                                    } else if participants.count > 1 {
                                        GroupProfilePicView(users: participants)
                                            .frame(width: 44.0, height: 44.0)
                                            .padding(.trailing, 10.0)
                                            .padding(.leading, 10.0)
                                    }
                                }
                            }
                            .sheet(isPresented: $profileDetailShow) {
                                ProfileDetailView(givenName: participants.first?.givenName ?? "", lastName: participants.first?.lastName ?? "" , url: participants.first?.photo ?? "", phoneNumber: participants.first?.phoneNumber ?? "")
                                    .presentationDetents([.height(UIScreen.main.bounds.height / 2.5)])
                                    .presentationBackground(Color.black)
                            }
                            .frame(width: 44.0, height: 44.0)
                            .shadow(color: .cyan, radius: 5.0, x: 0.0, y: 3.0)
                            VStack(alignment: .leading, spacing: 2.0) {
                                if participants.count > 0 {
                                    let participant = participants.first
                                    // This is done for Group Chat
                                    if participants.count == 1 {
                                        Text("\(participant?.givenName ?? "") \(participant?.lastName ?? "")")
                                            .font(Font.custom("LexendDeca-SemiBold", size: 16))
                                    } else if participants.count == 2 {
                                        let participantTwo = participants[1]
                                        Text("\(participant?.givenName ?? ""), \(participantTwo.givenName ?? "")")
                                            .font(Font.custom("LexendDeca-SemiBold", size: 16))
                                    } else if participants.count > 2 {
                                        let participantTwo = participants[1]
                                        Text("\(participant?.givenName ?? ""), \(participantTwo.givenName ?? "") + \(participants.count - 2) other")
                                            .font(Font.custom("LexendDeca-SemiBold", size: 16))
                                    }
//                                    HStack(spacing: 6.0) {
//                                        Image(systemName: "circle.fill")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 5.0, height: 5.0)
//                                            .foregroundStyle(.green)
//                                        Text("Online")
//                                            .font(.Caption)
//                                    }
                                }
                            }
                            .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.horizontal)
                        Rectangle()
                            .fill(Color.white.opacity(0.25))
                            .frame(height: 1)
                    }
                } // End of scroll view blue
                .frame(height: 50.0)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 24.0) {
                            ForEach(Array(chats.messages.enumerated()), id: \.element) { index, message in
                                let isFromUser = message.senderID == AuthenticationManager.shared.getUserID()
                                HStack {
                                    HStack(alignment: .lastTextBaseline) {
                                        // For our message
                                        if isFromUser {
//                                            Text(DateHelper.chatTimestampFrom(date: message.timeStamp))
//                                                .font(Font.Caption)
//                                                .foregroundStyle(.white.opacity(0.35))
//                                                .padding(.trailing)
                                            Spacer()
                                        } else if message.senderID != AuthenticationManager.shared.getUserID() {
                                            let userOfMessage = participants.filter { user in
                                                user.id == message.senderID
                                            }.first
                                            ZStack {
                                                if let cacheImage = CacheService.shared.getImage(forKey: userOfMessage?.photo ?? "") {
                                                    cacheImage
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(Circle())
                                                        .onTapGesture {
                                                            profileDetailShow = true
                                                        }
                                                } else {
                                                    AsyncImage(url: URL(string: userOfMessage?.photo ?? "")) { phase in
                                                        switch phase {
                                                        case AsyncImagePhase.empty:
                                                            ProgressView()
                                                        case AsyncImagePhase.success(let image):
                                                            image
                                                                .resizable()
                                                                .scaledToFill()
                                                                .clipShape(Circle())
                                                            //                                                            .onAppear {
                                                            //                                                                CacheService.shared.setImage(image: image, forKey: participant?.photo ?? "")
                                                            //                                                            }
                                                            
                                                        case AsyncImagePhase.failure:
                                                            ZStack {
                                                                Circle()
                                                                    .foregroundStyle(.white)
                                                                Text(userOfMessage?.givenName?.prefix(1) ?? "")
                                                                    .foregroundStyle(.black)
                                                                    .bold()
                                                            }
                                                        @unknown default:
                                                            ZStack {
                                                                Circle()
                                                                    .foregroundStyle(.white)
                                                                Text(userOfMessage?.givenName?.prefix(1) ?? "" )
                                                                    .foregroundStyle(.black)
                                                                    .bold()
                                                            }
                                                        }
                                                    }
                                                    .onTapGesture {
                                                        profileDetailShow = true
                                                    }
                                                }
                                            }
                                            .frame(width: 34.0, height: 34.0)
                                            .padding(.trailing, 6.0)
                                        }
                                        if message.imageURL != "" {
                                            if let cacheImage = CacheService.shared.getImage(forKey: message.imageURL ?? "") {
                                                cacheImage
                                                    .resizable()
                                                    .scaledToFill()
                                                    .clipShape(
                                                        RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                                                    )
                                                    .frame(maxWidth: UIScreen.main.bounds.width / 2, alignment: isFromUser ? .trailing : .leading)
                                                    .id(index)
                                                    .onTapGesture {
                                                        withAnimation(.easeIn) {
                                                            imageTapped = true
                                                            tappedImage = cacheImage
                                                        }
                                                    }
                                            } else {
                                                AsyncImage(url: URL(string: message.imageURL ?? "")) { phase in
                                                    switch phase {
                                                    case AsyncImagePhase.empty:
                                                        ProgressView()
                                                            .id(index)
                                                    case AsyncImagePhase.success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                            .clipShape(
                                                                RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                                                            )
                                                            .frame(maxWidth: UIScreen.main.bounds.width / 2, alignment: isFromUser ? .trailing : .leading)
                                                            .id(index)
                                                            .onAppear {
                                                                CacheService.shared.setImage(image: image, forKey: message.imageURL ?? "")
                                                            }
                                                    case AsyncImagePhase.failure:
                                                        Text("Couldn't load image")
                                                            .foregroundStyle(Color.white)
                                                            .font(Font.Body)
                                                            .padding(.vertical, 12.0)
                                                            .padding(.horizontal, 24.0)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                                                                    .fill(isFromUser ? Color(.sender) : Color(.reciever))
                                                            )
                                                            .frame(maxWidth: UIScreen.main.bounds.width / 2, alignment: isFromUser ? .trailing : .leading)
                                                            .id(index)
                                                    @unknown default:
                                                        Text("Couldn't load image")
                                                            .foregroundStyle(Color.white)
                                                            .font(Font.Body)
                                                            .padding(.vertical, 12.0)
                                                            .padding(.horizontal, 24.0)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                                                                    .fill(isFromUser ? Color(.sender) : Color(.reciever))
                                                            )
                                                            .frame(maxWidth: UIScreen.main.bounds.width / 2, alignment: isFromUser ? .trailing : .leading)
                                                            .id(index)
                                                    }
                                                }
                                            }
                                        } else {
                                            VStack(alignment: .leading, spacing: 4.0) {
                                                if participants.count > 1 && !isFromUser {
                                                    let userOfMessage = participants.filter { user in
                                                        user.id == message.senderID
                                                    }.first
                                                    Text("\(userOfMessage?.givenName ?? "") \(userOfMessage?.lastName ?? "")")
                                                        .font(Font.custom("LexendDeca-SemiBold", size: 10.0))
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .padding(.leading, 10.0)
                                                }
                                                // TODO: Fix the line limit issue
                                                Text(message.message)
                                                    .foregroundStyle(Color.white)
                                                    .font(Font.Body)
                                                    .padding(.vertical, 12.0)
                                                    .padding(.horizontal, 14.0)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: calculateCornerRadius(message: message.message, maxWidth: UIScreen.main.bounds.width / 1.5), style: .continuous)
                                                            .fill(isFromUser ? Color(.sender) : Color(.reciever))
                                                    )
                                                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: isFromUser ? .trailing : .leading)
                                                    .textSelection(.enabled)
                                            }
                                            .offset(y: -12.0)
                                        }
                                        // For their message
                                        if !isFromUser {
                                            Spacer()
                                        }
                                    }
//                                    .id(index)
//                                    .if(index == chats.messages.count - 1) {
//                                        $0.padding(.bottom, keyboardHeight > 0 ? 4.0 : (textfieldHeight + 8.0))
//                                    }
                                    
                                    if change {
                                        HStack {
                                            Image(systemName: isFromUser ? "arrow.right.circle" : "arrow.left.circle")
                                                .imageScale(.large)
                                            Text(DateHelper.chatTimestampFrom(date: message.timeStamp))
                                        }
                                        .font(Font.Caption)
                                        .foregroundStyle(.white.opacity(0.50))
                                        .padding(.leading)
                                        .transition(AnyTransition.opacity)
                                    }
                                }
                                .id(index)
//                                .if(index == chats.messages.count - 1) {
////                                    $0.padding(.bottom, keyboardHeight > 0 ? 4.0 : (textfieldHeight + 8.0))
//                                }
                            }
                        }
                        .padding(.horizontal)
//                        .padding(.top, 24.0)
                    }
                    .offset(x: offset.width)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let translation = gesture.translation
                                if translation.width < -20 {
                                    if translation.width > -70 {
                                        withAnimation(.easeIn(duration: 0.25)) {
                                            offset = gesture.translation
                                            change = true
                                        }
                                    }
                                }
                            }
                            .onEnded({ _ in
                                withAnimation(.easeIn(duration: 0.25)) {
                                    offset = .zero
                                    change = false
                                }
                            })
                    )
//                    .padding(.bottom, keyboardHeight > 0 ? bottomPadding : 0.0)
                    .padding(.bottom, keyboardHeight > 0 ? bottomPadding : (textfieldHeight + 8.0)) // TODO
                    .onChange(of: chats.messages.count) { oldValue, newCount in
                        withAnimation(.linear) {
                            proxy.scrollTo(newCount - 1)
                        }
                    }
                    //                    .onChange(of: textfieldHeight, { oldValue, newValue in // TODO
                    //                        bottomPadding = newValue
                    //                        withAnimation(.linear) {
                    //                            proxy.scrollTo(chats.messages.count - 1)
                    //                        }
                    //                    })
                    .onAppear {
                        withAnimation(.linear) {
                            proxy.scrollTo(chats.messages.count - 1)
                        }
                    }
                    // TODO: Do this when chat functionality is implemented
                    .padding(.bottom, keyboardHeight > 0 ? 60.0 : 0.0)
                    .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                        // Update keyboardHeight when the keyboard frame changes
                        withAnimation(.linear) {
                            proxy.scrollTo(chats.messages.count - 1)
                        }
                    }
                }
            }
            
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: textfieldRadius, style: .continuous)
                        .fill(.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: textfieldRadius, style: .continuous)
                                .stroke(
                                    LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                                    ,
                                    lineWidth: 1.5
                                )
                                .animation(.linear(duration: 3).repeatForever(), value: gradientColors)
                                .onAppear {
                                    startAnimation()
                                }
                        }
                    HStack(alignment: .bottom) {
                        Button {
                            self.source = .camera
                            isPhotoPickerShowing = true
                        } label: {
                            Image(.camera)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20.0, height: 20.0)
                                .foregroundStyle(Color(.sender))
                        }
                        Spacer()
                        if selectedImage != nil {
                            HStack(spacing: 10.0) {
                                Spacer()
                                Text("Image")
                                    .font(Font.Body)
                                    .foregroundStyle(.black.opacity(0.65))
                                Button {
                                    withAnimation(.easeIn) {
                                        selectedImage = nil
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15.0, height: 15.0)
                                }
                                .foregroundStyle(Color(.sender))
                                Spacer()
                            }
                        } else {
                            TextField("", text: $chatMessage, prompt: Text("Message...").foregroundStyle(.black.opacity(0.65)), axis: .vertical)
                                .lineSpacing(5.0)
                                .lineLimit(5)
                                .font(Font.TabBar)
                                .foregroundStyle(.black)
                                .offset(y: -2.0)
                        }
                        
                        Spacer()
                        if chatMessage == "" && selectedImage == nil {
                            Button {
                                
                            } label: {
                                Image(systemName: "mic")
                                    .resizable()
                                    .scaledToFit()
                                    .fontWeight(.medium)
                                    .frame(width: 20.0, height: 20.0)
                            }
                            .foregroundStyle(Color(.sender))
                            Button {
                                self.source = .photoLibrary
                                isPhotoPickerShowing = true
                            } label: {
                                Image(.gallery)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .fontWeight(.medium)
                                    .frame(width: 20.0, height: 20.0)
                            }
                            .foregroundStyle(Color(.sender))
                            Button {
                                emojiPickerShow = true
                            } label: {
                                Image(systemName: "face.smiling.inverse")
                                    .resizable()
                                    .scaledToFit()
//                                Text("Ai")
//                                    .fontDesign(.rounded)
                                    .fontWeight(.medium)
                                    .frame(width: 20.0, height: 20.0)
                                    .foregroundStyle(Color(.sender))
//                                    .foregroundStyle(
//                                        LinearGradient(colors: [Color.cyan, Color.pink], startPoint: .leading, endPoint: .trailing)
//                                    )
                            }
                        } else {
                            Button {
                                if selectedImage != nil {
                                    chats.sendImageMessage(image: selectedImage!)
                                    selectedImage = nil
                                } else {
                                    chatMessage = chatMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                                    chats.sendMessage(message: chatMessage)
                                    chatMessage = ""
                                }
                            } label: {
                                Text("Send")
                                    .foregroundStyle(Color(.sender))
                                    .font(Font.custom("LexendDeca-SemiBold", size: 12))
                            }
                            .disabled(chatMessage.trimmingCharacters(in: .whitespacesAndNewlines) == "" && selectedImage == nil)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: textfieldHeight)
                .padding(.horizontal)
                .padding(.bottom, keyboardHeight > 0 ? 10.0 : 0.0)
                // TODO: Add a modifier from
                .background {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                        .offset(y: 22.0)
                }
            }
            
            if imageTapped == true && tappedImage != nil {
                ZStack {
                    VisualEffectBlurView(blurStyle: .systemMaterialDark)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            tappedImage!
                                .resizable()
                                .scaledToFit()
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                                )
                                .frame(width: UIScreen.main.bounds.width - 20.0 , height: UIScreen.main.bounds.height / 1.5)
                                .padding(.horizontal, 50.0)
                        )
                }
                .zIndex(2.0)
                .onTapGesture {
                    withAnimation(.easeIn) {
                        tappedImage = nil
                        imageTapped = false
                    }
                }
            }
        }
        .sheet(isPresented: $emojiPickerShow, content: {
            NavigationStack {
                EmojiPickerView(selectedEmoji: $selectedEmoji, selectedColor: .orange)
                    .navigationTitle("Emojis")
                    .navigationBarTitleDisplayMode(.inline)
                    .onDisappear {
                        chats.sendMessage(message: selectedEmoji?.value ?? "")
                    }
            }
        })
        .onReceive(Publishers.keyboardHeight) { keyboardHeight in
            // Update keyboardHeight when the keyboard frame changes
            self.keyboardHeight = keyboardHeight
        }
        .onAppear {
            isAnimating = true
            chats.getMessages()
            // The bottom work is to get user detail back
            // First here we are getting the other participant id
            let ids = chats.getParticipantsIDs()
            // Now, we are pasing it into this function to get their detail
            participants = contacts.getParticipants(ids: ids)
            //            print(chats.selectedChat?.id)
        }
        .onDisappear {
            // To stop real-time listener
            chats.closeConversationViewListener()
        }
        //        .confirmationDialog("From where?", isPresented: $isSourceMenuShowing) {
        //            Button {
        //                self.source = .photoLibrary
        //                isPhotoPickerShowing = true
        //            } label: {
        //                Text("Photo Library")
        //            }
        //            Button {
        //                self.source = .camera
        //                isPhotoPickerShowing = true
        //            } label: {
        //                Text("Take Photo")
        //            }
        //        }
        .sheet(isPresented: $isPhotoPickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPhotoPickerShowing, source: source)
                .ignoresSafeArea(edges: source == .photoLibrary ? .bottom : .all)
        }
        .onChange(of: chatMessage) { oldValue, newValue in
            withAnimation(.easeIn(duration: 0.1)) {
                if newValue.count <= 45 {
                    textfieldHeight = 46
                    textfieldRadius = 40.0
                } else if newValue.count <= 45 * 2 {
                    textfieldHeight = 60
                    textfieldRadius = 26.0
                } else if newValue.count <= (45 * 2) + 45 {
                    textfieldHeight = 70
                    textfieldRadius = 22.0
                } else if newValue.count <= (45 * 2) + 55 {
                    textfieldHeight = 80
                    textfieldRadius = 18.0
                } else if newValue.count <= (45 * 2) + 65 {
                    textfieldHeight = 90
                    textfieldRadius = 18.0
                } else {
                    textfieldHeight = 100
                    textfieldRadius = 18.0
                }
            }
        }
    }
    func countWords(in text: String) -> Int {
        let words = text.split { !$0.isLetter }
        return words.count
    }
}

#Preview {
    ConversationView(isChatting: .constant(true), participants: .constant([]))
        .environment(ChatViewModel())
        .environment(ContactsViewModel())
}

extension ConversationView {
    
    // This function already exist in GradientOverlay file, but here for circle photo we needed to add this and the @State gradient up in the start
    func startAnimation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                // Rotate the array of colors to create the animation effect
                gradientColors.rotate()
            }
        }
        timer.fire()
    }
    
    var scrollDetection: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    hasScrolled = true
                } else {
                    hasScrolled = false
                }
            }
        })
    }
    
    func calculateCornerRadius(message: String, maxWidth: CGFloat) -> CGFloat {
        let maxCornerRadius: CGFloat = 20.0
        let messageLength = CGFloat(message.count)
        let scaleFactor: CGFloat = 0.5  // You can adjust this to your preference
        let singleLineThreshold: CGFloat = maxWidth / 4  // Adjust this threshold as needed
        
        if messageLength <= singleLineThreshold {
            return maxCornerRadius
        } else {
            return min(messageLength * scaleFactor, maxCornerRadius)
        }
    }

}



struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct AnimatableFontModifier: AnimatableModifier {
    var size: Double // size gets in here
    var weight: Font.Weight = .regular
    var design : Font.Design = .default
    
    var animatableData: Double {
        get { size } // gets the size
        set { size = newValue } // sets the size
    }
    func body(content: Content) -> some View {
        content
            .font(Font.custom("LexendDeca-SemiBold", size: size)) // applies the required Result
    }
}

extension View {
    func animatableFont(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        modifier(AnimatableFontModifier(size: size, weight: weight, design: design))
    }
}


extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>( _ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

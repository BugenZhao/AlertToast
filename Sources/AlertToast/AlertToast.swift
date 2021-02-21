import SwiftUI

@available(iOS 13, macOS 11, *)
fileprivate struct AnimatedCheckmark: View {
    
    ///Checkmark color
    var color: Color = .black
    
    ///Checkmark color
    var size: Int = 50
    
    var height: CGFloat {
        return CGFloat(size)
    }
    
    var width: CGFloat {
        return CGFloat(size)
    }
    
    @State private var percentage: CGFloat = .zero
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: height / 2))
            path.addLine(to: CGPoint(x: width / 2.5, y: height))
            path.addLine(to: CGPoint(x: width, y: 0))
        }
        .trim(from: 0, to: percentage)
        .stroke(color, style: StrokeStyle(lineWidth: CGFloat(size / 8), lineCap: .round, lineJoin: .round))
        .animation(Animation.spring().speed(0.75).delay(0.25))
        .onAppear {
            percentage = 1.0
        }
        .frame(width: width, height: height, alignment: .center)
    }
}

@available(iOS 13, macOS 11, *)
fileprivate struct AnimatedXmark: View {
    
    ///xmark color
    var color: Color = .black
    
    ///xmark size
    var size: Int = 50
    
    var height: CGFloat {
        return CGFloat(size)
    }
    
    var width: CGFloat {
        return CGFloat(size)
    }
    
    var rect: CGRect{
        return CGRect(x: 0, y: 0, width: size, height: size)
    }
    
    @State private var percentage: CGFloat = .zero
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxY, y: rect.maxY))
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        .trim(from: 0, to: percentage)
        .stroke(color, style: StrokeStyle(lineWidth: CGFloat(size / 8), lineCap: .round, lineJoin: .round))
        .animation(Animation.spring().speed(0.75).delay(0.25))
        .onAppear {
            percentage = 1.0
        }
        .frame(width: width, height: height, alignment: .center)
    }
}

@available(iOS 13, macOS 11, *)
public struct AlertToast: View{
    
    ///Determine how the alert will be display
    public enum DisplayMode: Equatable{
        
        ///Present at the center of the screen
        case alert
        
        ///Drop from the top of the screen
        case hud
    }
    
    ///Determine what the alert will display
    public enum AlertType: Equatable{
        
        ///Animated checkmark
        case complete(Color)
        
        ///Animated xmark
        case error(Color)
        
        ///System image from `SFSymbols`
        case systemImage(String, Color)
        
        ///Image from Assets
        case image(String)
        
        ///Loading indicator (Circular)
        case loading
        
        ///Only text alert
        case regular
    }
    
    ///The display mode
    ///`.alert`
    ///`.hud`
    public var displayMode: DisplayMode = .alert
    
    ///What the alert would show
    ///`complete`, `error`, `systemImage`, `image`, `loading`, `regular`
    public var type: AlertType
    
    ///The title of the alert (`Optional(String)`)
    public var title: String? = nil
    
    ///The subtitle of the alert (`Optional(String)`)
    public var subTitle: String? = nil
    
    ///The font title (`Optional(Font)`)
    public var titleFont: Font? = .body
    
    ///The subtitle font (`Optional(Font)`)
    public var subTitleFont: Font? = .footnote
    
    ///Choose bold title boolean (`Optional(Bool)`)
    public var boldTitle: Bool? = true
    
    ///The background of the alert (`Optional(Color)`)
    ///When `nil` background is `VisualEffectBlur`
    public var backgroundColor: Color?
    
    public init(displayMode: DisplayMode = .alert,
                type: AlertType,
                title: String? = nil,
                subTitle: String? = nil,
                titleFont: Font? = .body,
                subTitleFont: Font? = .footnote,
                boldTitle: Bool? = true,
                backgroundColor: Color? = nil){
        
        self.displayMode = displayMode
        self.type = type
        self.title = title
        self.subTitle = subTitle
        self.titleFont = titleFont
        self.subTitleFont = subTitleFont
        self.boldTitle = boldTitle
        self.backgroundColor = backgroundColor
        
    }
    
    ///HUD View
    public var hud: some View{
        VStack{
            HStack(spacing: 16){
                switch type{
                case .complete(let color):
                    Image(systemName: "checkmark")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 20, maxHeight: 20, alignment: .center)
                        .foregroundColor(color)
                case .error(let color):
                    Image(systemName: "xmark")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 20, maxHeight: 20, alignment: .center)
                        .foregroundColor(color)
                case .systemImage(let name, let color):
                    Image(systemName: name)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 20, maxHeight: 20, alignment: .center)
                        .foregroundColor(color)
                case .image(let name):
                    Image(name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 20, maxHeight: 20, alignment: .center)
                case .loading:
                    ActivityIndicator()
                case .regular:
                    EmptyView()
                }
                
                if title != nil || subTitle != nil{
                    VStack(alignment: type == .regular ? .center : .leading, spacing: 2){
                        if title != nil{
                            Text(LocalizedStringKey(title ?? ""))
                                .font(titleFont)
                                .isBold(boldTitle)
                                .multilineTextAlignment(.center)
                        }
                        if subTitle != nil{
                            Text(LocalizedStringKey(subTitle ?? ""))
                                .font(subTitleFont)
                                .opacity(0.7)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .frame(maxHeight: 150)
            .alertBackground(backgroundColor)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.gray.opacity(0.2), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 6)
            .compositingGroup()
            
            Spacer()
        }
        .padding(.top)
    }
    
    ///Alert View
    public var alert: some View{
        VStack{
            switch type{
            case .complete(let color):
                Spacer()
                AnimatedCheckmark(color: color)
                Spacer()
            case .error(let color):
                Spacer()
                AnimatedXmark(color: color)
                Spacer()
            case .systemImage(let name, let color):
                Spacer()
                Image(systemName: name)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .foregroundColor(color)
                    .padding(.bottom)
                Spacer()
            case .image(let name):
                Spacer()
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .padding(.bottom)
                Spacer()
            case .loading:
                ActivityIndicator()
            case .regular:
                EmptyView()
            }
            
            VStack(spacing: type == .regular ? 8 : 2){
                if title != nil{
                    Text(LocalizedStringKey(title ?? ""))
                        .font(titleFont)
                        .isBold(boldTitle)
                        .multilineTextAlignment(.center)
                }
                if subTitle != nil{
                    Text(LocalizedStringKey(subTitle ?? ""))
                        .font(subTitleFont)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
        .withFrame(type != .regular && type != .loading)
        .alertBackground(backgroundColor)
        .cornerRadius(10)
    }
    
    ///Body init determine by `displayMode`
    public var body: some View{
        switch displayMode{
        case .alert:
            alert
        case .hud:
            hud
        }
    }
}

@available(iOS 13, macOS 11, *)
public struct AlertToastModifier: ViewModifier{
    
    ///Presentation `Binding<Bool>`
    @Binding var isPresenting: Bool
    
    ///Duration time to display the alert
    @State var duration: Double = 2
    
    ///Tap to dismiss alert
    @State var tapToDismiss: Bool = true
    
    ///Init `AlertToast` View
    var alert: () -> AlertToast
    
    ///Completion block returns `true` after dismiss
    var completion: ((Bool) -> ())? = nil
    
    @State private var hostRect: CGRect = .zero
    @State private var alertRect: CGRect = .zero
    
    private var screen: CGRect {
        #if os(iOS)
        return UIScreen.main.bounds
        #else
        return NSScreen.main?.frame ?? .zero
        #endif
    }
    
    private var offset: CGFloat{
        #if os(iOS)
        return -hostRect.midY + alertRect.height - (screen.height * 0.01)
        #else
        return (-hostRect.midY + screen.midY) + alertRect.height
        #endif
    }
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader{ geo -> AnyView in
                    let rect = geo.frame(in: .global)
                    
                    if rect.integral != hostRect.integral{
                        DispatchQueue.main.async {
                            self.hostRect = rect
                        }
                    }
                    
                    return AnyView(EmptyView())
                }
                .overlay(ZStack{
                    if isPresenting{
                        
                        switch alert().displayMode{
                        case .alert:
                            alert()
                                .onAppear {
                                    
                                    if alert().type == .loading{
                                        duration = 0
                                        tapToDismiss = false
                                    }
                                    
                                    if duration > 0{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                            withAnimation(.spring()){
                                                isPresenting = false
                                            }
                                        }
                                    }
                                }
                                .onTapGesture {
                                    if tapToDismiss{
                                        withAnimation(.spring()){
                                            isPresenting = false
                                        }
                                    }
                                }
                                .onDisappear(perform: {
                                    completion?(true)
                                })
                                .transition(AnyTransition.scale(scale: 0.8).combined(with: .opacity))
                        case .hud:
                            alert()
                                .overlay(
                                    GeometryReader{ geo -> AnyView in
                                        let rect = geo.frame(in: .global)
                                        
                                        if rect.integral != alertRect.integral{
                                            
                                            DispatchQueue.main.async {
                                            
                                            self.alertRect = rect
                                            }
                                        }
                                        return AnyView(EmptyView())
                                    }
                                )
                                .onAppear {
                                    
                                    if alert().type == .loading{
                                        duration = 0
                                        tapToDismiss = false
                                    }
                                    
                                    if duration > 0{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                            withAnimation(.spring()){
                                                isPresenting = false
                                            }
                                        }
                                    }
                                }
                                .onTapGesture {
                                    if tapToDismiss{
                                        withAnimation(.spring()){
                                            isPresenting = false
                                        }
                                    }
                                }
                                .onDisappear(perform: {
                                    completion?(true)
                                })
                                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: alert().displayMode == .alert ? .infinity : -hostRect.midY / 2, alignment: .center)
                .offset(x: 0, y: alert().displayMode == .alert ? 0 : offset)
                .edgesIgnoringSafeArea(alert().displayMode == .alert ? .all : .bottom)
                .animation(.spring()))
            )
        
    }
}

///Fileprivate View Modifier for dynamic frame when alert type is `.regular` / `.loading`
@available(iOS 13, macOS 11, *)
fileprivate struct WithFrameModifier: ViewModifier{
    
    var withFrame: Bool
    
    var maxWidth: CGFloat = 175
    var maxHeight: CGFloat = 175
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if withFrame{
            content
                .frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .center)
        }else{
            content
        }
    }
}

///Fileprivate View Modifier to change the alert background
@available(iOS 13, macOS 11, *)
fileprivate struct BackgroundModifier: ViewModifier{
    
    var color: Color?
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if color != nil{
            content
                .background(color)
        }else{
            content
                .background(BlurView())
        }
    }
}

@available(iOS 13, macOS 11, *)
public extension View{
    
    /// Return some view w/o frame depends on the condition.
    /// This view modifier function is set by default to:
    /// - `maxWidth`: 175
    /// - `maxHeight`: 175
    fileprivate func withFrame(_ withFrame: Bool) -> some View{
        modifier(WithFrameModifier(withFrame: withFrame))
    }
    
    /// Present `AlertToast`.
    /// - Parameters:
    ///   - show: Binding<Bool>
    ///   - alert: () -> AlertToast
    /// - Returns: `AlertToast`
    func presentAlert(isPresenting: Binding<Bool>, duration: Double = 2, tapToDismiss: Bool = true, alert: @escaping () -> AlertToast, completion: ((Bool) -> ())? = nil) -> some View{
        modifier(AlertToastModifier(isPresenting: isPresenting, duration: duration, tapToDismiss: tapToDismiss, alert: alert, completion: completion))
    }
    
    /// Choose the alert background
    /// - Parameter color: Some Color, if `nil` return `VisualEffectBlur`
    /// - Returns: some View
    fileprivate func alertBackground(_ color: Color? = nil) -> some View{
        modifier(BackgroundModifier(color: color))
    }
}

@available(iOS 13, macOS 11, *)
fileprivate extension Text{
    func isBold(_ isBold: Bool? = true) -> Text{
        if isBold ?? true{
            return self.bold()
        }else{
            return self
        }
    }
}

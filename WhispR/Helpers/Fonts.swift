//
//  Fonts.swift
//  WhispR
//
//  Created by Amish on 15/07/2023.
//

import SwiftUI

extension Font {
    
    public static var Body: Font {
        return Font.custom("LexendDeca-Regular", size: 14)
    }
    
    public static var Button: Font {
        return Font.custom("LexendDeca-SemiBold", size: 14)
    }
    
    public static var Caption: Font {
        return Font.custom("LexendDeca-Regular", size: 10)
    }
    
    public static var TabBar: Font {
        return Font.custom("LexendDeca-Regular", size: 12)
    }
    
    public static var Settings: Font {
        return Font.custom("LexendDeca-Regular", size: 16)
    }
    
    public static var Title: Font {
        return Font.custom("LexendDeca-Bold", size: 23)
    }
    
    public static var PageTitle: Font {
        return Font.custom("LexendDeca-SemiBold", size: 33)
    }
    
    public static var ChatHeading: Font {
        return Font.custom("LexendDeca-SemiBold", size: 19)
    }
}

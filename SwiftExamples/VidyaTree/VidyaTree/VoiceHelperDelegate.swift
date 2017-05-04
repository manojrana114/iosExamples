//
//  VoiceHelperDelegate.swift
//  VidyaTree
//
//  Created by Manoj pratap singh rana on 04/05/17.
//  Copyright © 2017 Impetus. All rights reserved.
//


protocol VoiceHelperDelegate : class {
    
    func textFromSpeech(text : String);
    
    func enableMicrophone(enable : Bool)
}

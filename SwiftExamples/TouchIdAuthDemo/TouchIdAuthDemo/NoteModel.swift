//
//  NoteModel.swift
//  TouchIdAuthDemo
//
//  Created by Manoj pratap singh rana on 10/06/17.
//  Copyright © 2017 Impetus. All rights reserved.
//

import Foundation

class NoteModel {
    var notes : [Note] = []
    struct Note{
        var noteName:String
        var noteDescription:String
    }
    
    //MARK : File handling methods
   class func getPathOfDataFile() -> URL {
        let fileManager = FileManager.default
        let pathsArray = fileManager.urls(for: .applicationDirectory, in: .userDomainMask)
        let documentsPath = pathsArray[0]
        let dataFilePath = documentsPath.appendingPathComponent("notesData")
        return dataFilePath
    }
    
   class func checkIfDataFileExists() -> Bool {
        if FileManager.default.fileExists(atPath: String(describing: getPathOfDataFile())) {
            return true
        }
        return false
    }
}

extension NoteModel{

    func saveNote(note: Note) {
        notes.append(note)
        (notes as NSArray).write(to: NoteModel.getPathOfDataFile(), atomically:true)
            
    }
    
    func fetchNotes() -> [Note] {
        if NoteModel.checkIfDataFileExists() {
            self.notes = NSMutableArray(contentsOfFile: String(NoteModel.getPathOfDataFile()))
        }else{
            print("File does not exist")
        }
        
    }
    
   
    
}

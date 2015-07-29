//
//  TheRest.swift
//  FigureOutAKTableFMOsc
//
//  Created by Niklas Saers on 29/07/15.
//  Copyright (c) 2015 SAERS. All rights reserved.
//

import UIKit

protocol JSONEncodable {
    func toDict() -> [String : AnyObject]
}

protocol JSONDecodable {
    init(dict: [ String : AnyObject ])
}

enum Note : Int, JSONEncodable, JSONDecodable {
    case None = -1
    case C = 3
    case Csharp = 4
    case D = 5
    case Dsharp = 6
    case E = 7
    case F = 8
    case Fsharp = 9
    case G = 10
    case Gsharp = 11
    case A = 0
    case Asharp = 1
    case B = 2
    
    func toDict() -> [String : AnyObject] {
        return [ "note" : self.stringValue() ]
    }
    
    
    init(dict: [ String : AnyObject ]) {
        if let json = dict["note"] as? String, note = Note.noteForString(json) {
            self = note
        } else {
            self = Note.None
        }
    }
    
    static func noteForString(note: String) -> Note? {
        let sNote = note.capitalizedString
        switch(sNote) {
        case "C":
            return Note.C
        case "C#":
            return Note.Csharp
        case "D":
            return Note.D
        case "D#":
            return Note.Dsharp
        case "E":
            return Note.E
        case "F":
            return Note.F
        case "F#":
            return Note.Fsharp
        case "G":
            return Note.G
        case "G#":
            return Note.Gsharp
        case "A":
            return Note.A
        case "A#":
            return Note.Asharp
        case "B":
            return Note.B
        default:
            return nil
        }
    }
    
    func localizedStringValue() -> String {
        return self.stringValue()
    }
    
    func CBasedValue() -> Int {
        var c = (self.rawValue - Note.C.rawValue)
        while c < 0 {
            c = c + 12
        }
        return c % 12
    }
    
    func stringValue() -> String {
        switch(self) {
        case None:
            return "NA"
        case C:
            return "C"
        case Csharp:
            return "C♯"
        case D:
            return "D"
        case Dsharp:
            return "D♯"
        case E:
            return "E"
        case F:
            return "F"
        case Fsharp:
            return "F♯"
        case G:
            return "G"
        case Gsharp:
            return "G♯"
        case A:
            return "A"
        case Asharp:
            return "A♯"
        case B:
            return "B"
        }
    }
    
    
}

struct NoteInOctave : JSONEncodable, JSONDecodable {
    var note : Note
    var octave : Int
    
    func toDict() -> [String : AnyObject] {
        return [ "note": self.note.toDict(), "octave": self.octave ]
    }
    
    init(dict: [ String : AnyObject ]) {
        self.note = Note(dict: dict["note"] as! [ String : AnyObject ])
        self.octave = dict["octave"] as! Int
    }
    
    init(note: Note, octave: Int) {
        self.note = note
        self.octave = octave
    }
    
    
    func noteVal() -> Int {
        var ret = (octave * 12) + note.rawValue
        if note.rawValue < Note.C.rawValue {
            ret = ret + 12
        }
        return ret
    }
    
    static func valueForIndex(index: Int) -> NoteInOctave {
        
        var index = index
        if index < 0 {
            index = 0
        }
        
        let note : Note = Note(rawValue: index % 12)!
        var octave : Int = index / 12
        if note.rawValue < Note.C.rawValue {
            octave = octave - 1
        }
        
        return NoteInOctave(note: note, octave: octave)
    }
    
    func localizedStringValue() -> String {
        return note.stringValue() + String(octave)
    }
    
    func stringValue() -> String {
        return note.stringValue() + String(octave)
    }
}

class FMSynthesizerNote : AKNote {
    var frequency: AKNoteProperty
    var color: AKNoteProperty
    
    init(frequency: Float) {
        self.frequency = AKNoteProperty(value: frequency, minimum: 20, maximum: 20000)
        self.color = AKNoteProperty(value: 0.5, minimum: 0.0, maximum: 1.0)
        
        super.init()
        
        self.addProperty(self.frequency)
        self.addProperty(self.color)
        
        self.frequency.value = frequency
        self.color.value = 0.5
        self.duration = AKNoteProperty(float: 99)
    }
}

class SoundingNote : FMSynthesizerNote {
    var noteInOctave : NoteInOctave
    
    init(noteInOctave: NoteInOctave) {
        self.noteInOctave = noteInOctave
        let frequency : Float = 440.0
        super.init(frequency: frequency)
        self.duration = AKNoteProperty(float: -2)
    }
}

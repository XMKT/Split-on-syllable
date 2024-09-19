// чтение файла midi
import Foundation

/*
- - - - - - Структура - - - - - -
1. Заголовок MTdh (14 байт)
    a) символы MTdh     - 4 байта
    б) длина блока      - 4 байта
    в) формат midi      - 2 байта
    г) число блоков MTrk- 2 байта
    д) формат времени   - 2 байта
2. Блок MTrk
    а) символы MTrk     - 4 байта
    б) длина MTrk       - 4 байта
    в) событие
*/
struct action {
    var a = 1
}


struct MTrk {
    var title       : String    = ""
    var type_midi   : UInt32    = 4
    var action      : [action]  = []
}


struct MTdh {
    var title       : String    = ""
    var type_midi   : UInt32    = 0
    var lenght_MThd : UInt32    = 6
    var count_MTrk  : UInt32    = 1
    var time        : UInt32    = 120
}


class Midi{
    var index       : Int       = 0
    var bytes       : [UInt8]   = []
    
    var mtdh : MTdh = MTdh()
    var mtrk_array : [MTrk] = []
    
    
    func setTitleMThd(){
        // a) символы MTdh     - 4 байта
        self.mtdh.title = String(bytes: self.bytes[0..<4], encoding: .ascii)!
        
        // б) длина блока      - 4 байта
        var lenght_MThd : UInt32 = 0
        for i in self.bytes[4..<8]{
            lenght_MThd = lenght_MThd << 8 + UInt32(i)}
        self.mtdh.lenght_MThd = lenght_MThd
        
        // в) формат midi      - длина блока % 3 байт
        var type_midi : UInt32 = 0
        for i in self.bytes[8..<Int(8+Int(self.mtdh.lenght_MThd / 3))]{
            type_midi = type_midi << 8 + UInt32(i)}
        self.mtdh.type_midi = type_midi

        // г) число блоков MTrk- длина блока % 3 байт
        var count_MTrk : UInt32 = 0
        for i in self.bytes[Int(8+Int(self.mtdh.lenght_MThd / 3))..<Int(8+(Int(self.mtdh.lenght_MThd / 3)*2))]{
            count_MTrk = count_MTrk << 8 + UInt32(i)}
        self.mtdh.count_MTrk = count_MTrk
        
        // д) формат времени   - длина блока % 3 байт
        var time : UInt32 = 0
        for i in self.bytes[Int(8+(Int(self.mtdh.lenght_MThd / 3)*2))..<Int(8+self.mtdh.lenght_MThd)]{
            time = time << 8 + UInt32(i)}
        self.mtdh.time = time
        self.index += Int(8+self.mtdh.lenght_MThd)
    }
    
    func findMTrk(){
        
    }
    
    
    func getDataFromFile(filename:String){
        let data : Data = FileManager().contents(atPath: filename)!
        for i in data{
            self.bytes.append(i)
        }
        setTitleMThd()
        //while(self.index < bytes.count){findMTrk()}
        print(self.bytes[0])
    }
    
    init(fileName : String) {
        getDataFromFile(filename: fileName)
    }
}



import Foundation

public class BlogPostDAO: BaseDAO {
    
    public static let sharedInstance: BlogPostDAO = {
        let instance = BlogPostDAO()
        return instance
    }()
    /*
    //插入方法
    public func create(_ model: BlogPost) -> Int {
        
        if self.openDB() {
            let sql = "INSERT INTO BlogPost (title, link,description,EventID) VALUES (?,?,?,?)"
            let cSql = sql.cString(using: String.Encoding.utf8)
            
            var statement:OpaquePointer? = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cSql, -1, &statement, nil) == SQLITE_OK {
                
                let cGameDate = model.GameDate!.cString(using: String.Encoding.utf8)
                let cGameTime = model.GameTime!.cString(using: String.Encoding.utf8)
                let cGameInfo = model.GameInfo!.cString(using: String.Encoding.utf8)
                
                //绑定参数开始
                sqlite3_bind_text(statement, 1, cGameDate, -1, nil)
                sqlite3_bind_text(statement, 2, cGameTime, -1, nil)
                sqlite3_bind_text(statement, 3, cGameInfo, -1, nil)
                sqlite3_bind_int(statement, 4, Int32(model.Event!.EventID!))
                //执行插入
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    sqlite3_finalize(statement)
                    sqlite3_close(db)
                    assert(false, "插入数据失败。")
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return 0
    }
 

    //查询所有数据方法
    public func findAll() -> [BlogPost] {
        
        var listData = [BlogPost]()
        
        if self.openDB() {
            
            let sql = "SELECT GameDate, GameTime,GameInfo,EventID,ScheduleID FROM Schedule"
            let cSql = sql.cString(using: String.Encoding.utf8)
            
            var statement:OpaquePointer? = nil
            
            //预处理过程
            if sqlite3_prepare_v2(db, cSql, -1, &statement, nil) == SQLITE_OK {
                
                //执行
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    let schedule = BlogPost()
                    let event  = Events()
                    schedule.Event = event
                    
                    if let strGameDate = getColumnValue(index:0, stmt:statement!) {
                        schedule.GameDate = strGameDate
                    }
                    if let strGameTime = getColumnValue(index:1, stmt:statement!) {
                        schedule.GameTime = strGameTime
                    }
                    if let strGameInfo = getColumnValue(index:2, stmt:statement!) {
                        schedule.GameInfo = strGameInfo
                    }
                    schedule.Event!.EventID = Int(sqlite3_column_int(statement, 3))
                    schedule.ScheduleID = Int(sqlite3_column_int(statement, 4))
                    
                    listData.append(schedule)
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return listData
    }   */
}

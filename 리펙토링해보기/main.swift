//
//  main.swift
//  MyCreditManagerVer2
//
//  Created by 윤준영 on 2023/05/15.
//

import Foundation

struct Subject: Equatable {
    var name: String
    var grade: String
    var credit: Int
    var score: Double
}

enum InputError: Error, CustomDebugStringConvertible {
    case wrongInput
    case duplicated(name: String)
    case notFound(name: String)
    
    var debugDescription: String {
        switch self {
        case .wrongInput: return "입력이 잘못되었습니다. 다시 확인해주세요"
        case .duplicated(let name): return "\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다"
        case .notFound(let name): return "\(name)학생을 찾지 못했습니다"
        }
    }
}

class MyCreditManager {
    private var isRunning = true
    private var students: [String : [Subject]] = [:]
    
    func run() {
        while isRunning {
            switch self.getMenu() {
            case "1" : do { try addStudent() } catch { print(error) }
            case "2" : do { try deleteStudent() } catch { print(error) }
            case "3" : do { try addGrade() } catch { print(error) }
            case "4" : do { try deleteGrade() } catch { print(error) }
            case "5" : do { try showGPA() } catch { print(error) }
            case "X" : exitProgram()
            default : break
            }
        }
    }
    
    private func getMenu() -> String {
        print("원하는 기능을 입력하세요")
        print("1: 학생추가 , 2: 학생삭제 , 3: 성적추가(변경) , 4: 성적삭제 , 5: 평점보기 , X: 종료")
        return readLine() ?? "0"
    }
    
    private func addStudent() throws {
        print("추가할 학생의 이름을 입력해주세요.")
        guard let name = readLine(), !name.contains(" ") else {
            throw InputError.wrongInput
        }
        guard students[name] == nil else {
            throw InputError.duplicated(name: name)
        }
        students[name] = []
        print("\(name) 학생을 추가했습니다.")
    }
    
    private func deleteStudent() throws {
        print("삭제할 학생의 이름을 입력해주세요.")
        guard let name = readLine() else {
            throw InputError.wrongInput
        }
        if let _ = students[name] {
            throw InputError.notFound(name: name)
        }
        students.removeValue(forKey: name)
        print("\(name) 학생을 삭제했습니다.")
    }

    private func addGrade() throws {
        print("성적을 추가할 학생의 이름, 과목이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력예) Mickey Swift A+")
        print("만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
        
        guard let input = readLine()?.components(separatedBy: " "),
            input.count == 3,
            let name = input.first,
            let subjectName = input.dropFirst().first,
            let grade = input.last
        else {
            throw InputError.wrongInput
        }

        guard let subjects = students[name] else {
            throw InputError.notFound(name: name)
        }

        var newSubjects: [Subject] = []

        for subject in subjects {
            if subject.name == subjectName {
                let gradePoint = getGradePoint(grade: grade)
                let newSubject = Subject(name: subject.name, grade: grade, credit: subject.credit, score: gradePoint)
                newSubjects.append(newSubject)
            } else {
                newSubjects.append(subject)
            }
        }

        if subjects.count == newSubjects.count {
            let gradePoint = getGradePoint(grade: grade)
            newSubjects.append(Subject(name: subjectName, grade: grade, credit: 3, score: gradePoint))
        }

        students[name] = newSubjects
        print("\(name) 학생의 \(subjectName) 과목이 \(grade)로 추가(변경)되었습니다.")
    }

    private func deleteGrade() throws{
        print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력예) Mickey Swift")
        
        guard let input = readLine()?.split(separator: " "), input.count == 2 else {
                throw InputError.wrongInput
            }
        
            let name = String(input[0])
            let subjectName = String(input[1])
            guard let subjects = students[name], subjects.contains(where: { $0.name == subjectName }) else {
                throw InputError.notFound(name: name)
            }
        
        let updatedSubjects = subjects.filter({ $0.name != subjectName })
            students[name] = updatedSubjects
            print("\(name) 학생의 \(subjectName) 과목의 성적이 삭제되었습니다.")
    }
    
    private func showGPA() throws {
        print("평점을 알고싶은 학생의 이름을 입력해주세요.")
        guard let name = readLine(), !name.isEmpty else {
            throw InputError.wrongInput
        }
        
        guard let subjects = students[name], !subjects.isEmpty else {
            throw InputError.notFound(name: name)
        }
        
        var totalGrade = 0.0
        var totalCredits = 0
        
        for subject in subjects {
            totalGrade += subject.score * Double(subject.credit)
            totalCredits += subject.credit
            
            print("\(subject.name): \(subject.score)")
        }
        
        let gpa = totalGrade / Double(totalCredits)
        print("평점: \(gpa)")
    }
    
    private func getGradePoint(grade: String) -> Double {
        switch grade {
        case "A+":
            return 4.5
        case "A":
            return 4.0
        case "B+":
            return 3.5
        case "B":
            return 3.0
        case "C+":
            return 2.5
        case "C":
            return 2.0
        case "D+":
            return 1.5
        case "D":
            return 1.0
        default:
            return 0.0
        }
    }
    
    private func exitProgram() {
        print("프로그램을 종료합니다...")
        isRunning.toggle()
    }
}

MyCreditManager().run()

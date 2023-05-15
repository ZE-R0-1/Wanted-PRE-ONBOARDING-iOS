//
//  main.swift
//  MyCreditManager
//
//  Created by 윤준영 on 2023/04/27.
//

import Foundation

class Student {
    let name: String
    let subject: String
    var grades: [String: String]
    
    init(name: String, subject: String, grades: [String : String]) {
        self.name = name
        self.subject = subject
        self.grades = grades
    }
    
    func addGrade(subject: String, grade: String) {
        self.grades[subject] = grade
        print("\(self.name) 학생의 \(subject) 과목에 \(grade) 성적이 추가(변경)되었습니다.")
    }

    func deleteGrade(subject: String) {
        if let removedGrade = self.grades.removeValue(forKey: subject) {
            print("\(self.name) 학생의 \(subject) 과목의 성적 \(removedGrade)이 삭제되었습니다.")
        } else {
            print("\(self.name) 학생을 찾지 못했습니다.")
        }
    }
    
    func showGrades() {
        var totalScore: Double = 0
        var numSubjects: Double = 0
        
        print("\(self.name)")
        
        for (subject, grade) in self.grades {
            var score: Double = 0
            switch grade {
            case "A+":
                score = 4.5
            case "A":
                score = 4
            case "B+":
                score = 3.5
            case "B":
                score = 3
            case "C+":
                score = 2.5
            case "C":
                score = 2
            case "D+":
                score = 1.5
            case "D":
                score = 1
            case "F":
                score = 0
            default: break
            }
            totalScore += score
            numSubjects += 1
            print("\(subject): \(grade)")
        }
        
        if numSubjects > 0 {
            let avgScore = totalScore / numSubjects
            print("평점: \(String(format: "%.2f", avgScore))")
        }
    }
}

func addStudent() {
    print("학생의 이름을 입력해주세요.")
    let name = readLine() ?? ""
    studentList[name] = Student(name: name, subject: "",  grades: [:])
    print("\(name) 학생이 추가되었습니다.")
}

func deleteStudent() {
    print("삭제할 학생의 이름을 입력해주세요.")
    let name = readLine() ?? ""
    if let _ = studentList.removeValue(forKey: name) {
        print("\(name) 학생이 삭제되었습니다.")
    } else {
        print("\(name) 학생을 찾을 수 없습니다.")
    }
}

func addGrade() {
    print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 입력해주세요.")
    let input = readLine()?.split(separator: " ")
    if let input = input, input.count == 3,
       let student = studentList[String(input[0])] {
        let subject = String(input[1])
        let grade = String(input[2])
        student.addGrade(subject: subject, grade: grade)
    } else {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    }
}

func deleteGrade() {
    print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.")
    if let input = readLine()?.split(separator: " ").map(String.init),
        input.count == 2,
        let name = input.first,
        let subject = input.last,
        let student = studentList[name] {
        
        student.deleteGrade(subject: subject)
    } else {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    }
}

func showGrades() {
    print("성적을 조회할 학생의 이름을 입력해주세요.")
    let name = readLine() ?? ""
    if let student = studentList[name] {
        student.showGrades()
    } else {
        print("\(name) 학생을 찾을 수 없습니다.")
    }
}

func showMenu() {
    print("1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
    
}

var studentList = [String: Student]()
while true {
    showMenu()
    let input = readLine()
    switch input {
    case "1":
        addStudent()
        break
    case "2":
        deleteStudent()
        break
    case "3":
        addGrade()
        break
    case "4":
        deleteGrade()
        break
    case "5":
        showGrades()
        break
    case "X":
        exit(0)
    default:
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
}

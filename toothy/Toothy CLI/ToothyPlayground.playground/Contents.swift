import Cocoa

let grade = 0.0

func ima(grade: Double) -> Double {
    var advantage = 1.0
    if grade > 0.0 {
        advantage = sin(atan(grade))
    } else if grade < 0.0 {
        advantage = sin(atan(abs(grade)))
    }
    return advantage
}

ima(grade: 0.0)
ima(grade: 0.05)
ima(grade: 1.0)
ima(grade: -0.05)
ima(grade: 0.1)
ima(grade: -1.0)

func totalForce(pedalForce: Double, gearRatio: Double, grade: Double, chainringFactor: Double) -> Double {
    return pedalForce * gearRatio * ima(grade: grade) * chainringFactor
}

totalForce(pedalForce: 100.0, gearRatio: 1.0, grade: 0.0, chainringFactor: 1.0)
totalForce(pedalForce: 100.0, gearRatio: 1.0, grade: 0.1, chainringFactor: 1.0)
totalForce(pedalForce: 100.0, gearRatio: 5.0, grade: 0.0, chainringFactor: 1.0)

func adjustedGrade(initialGrade: Double, chainringFactor: Double) -> Double {
    return tan(asin(sin(atan(initialGrade)) * chainringFactor))
}

adjustedGrade(initialGrade: -1.0, chainringFactor: 2.0)
sin(atan(0.0))
asin(sin(atan(-1.0)) * 2.0)

//
//  TaskList.swift
//  tdlpp-swiftui
//
//  Created by Ryan Chen on 11/15/22.
//

import SwiftUI

struct TaskRow: View {
    var task: Task


    // get the current time
    var currentTime: Date

    @State private var progress = 0.0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {

        VStack {
            Text(task.title).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color)))

            let totalSecondsLeft = task.timeRemaining(currentTime: Date())
            // convert the time left to days, hours, minutes
            //
            let daysLeft = totalSecondsLeft / 86400
            let hoursLeft = totalSecondsLeft % 86400 / 3600
            let minutesLeft = totalSecondsLeft % 3600 / 60
            let secondsLeft = totalSecondsLeft % 60

            // if there is still time left, display the time left
            if daysLeft > 0 {
                Text("\(daysLeft) D, \(hoursLeft) H, \(minutesLeft) M, \(secondsLeft) S Left") .foregroundColor(Color(uiColor: util.hex2color(hexString: task.color)))
            } else if hoursLeft > 0 {
                Text("\(hoursLeft) H, \(minutesLeft) M, \(secondsLeft) S Left").foregroundColor(Color(uiColor: util.hex2color(hexString: task.color)))
            } else if minutesLeft > 0 {
                Text("\(minutesLeft) M, \(secondsLeft) S Left").foregroundColor(Color(uiColor: util.hex2color(hexString: task.color)))
            } else if secondsLeft > 0 {
                Text("\(secondsLeft) Seconds left").foregroundColor(Color(uiColor: util.hex2color(hexString: task.color)))
            } else {
                // in red
                Text("Overdue").foregroundColor(.red)
            }

            ProgressView(value: progress, total: 1.0)
                    .onReceive(timer) { _ in
                        let taskProgress = task.getProgress(currentTime: Date())

                        if taskProgress < 0.0 || taskProgress > 1.0 {
                            progress = 1.0
                        } else {
                            progress = taskProgress
                        }

                    }
                    // if the task is overdue, tint the progress bar red
                    .tint(totalSecondsLeft < 0 ? .red : Color(uiColor: util.hex2color(hexString: task.color)))


            //Text("progress remaining: \(task.getProgress(currentTime: Date()))")
        }
        .tint(Color(uiColor: util.hex2color(hexString: task.color)))
//        .background(Color(uiColor: util.colorWithHexString(hexString: task.color)))
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var tasks = TaskData().tasks

    static var previews: some View {
        Group {
            TaskRow(task: tasks[0], currentTime: Date())
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}

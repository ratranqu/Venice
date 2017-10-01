import CLibvenice

public typealias PID = pid_t

/// Runs the expression in a lightweight coroutine.
public func coroutine(_ routine: @escaping () -> Void) {
    var _routine = routine
    CLibvenice.co(&_routine, { routinePointer in
        routinePointer!.assumingMemoryBound(to: (() -> Void).self).pointee()
    }, "co")
}

/// Runs the expression in a lightweight coroutine.
public func coroutine(_ routine: @autoclosure @escaping  () -> Void) {
    var _routine: () -> Void = routine
    CLibvenice.co(&_routine, { routinePointer in
        routinePointer!.assumingMemoryBound(to: (() -> Void).self).pointee()
    }, "co")
}

/// Runs the expression in a lightweight coroutine.
public func co(_ routine: @escaping () -> Void) {
    coroutine(routine)
}

/// Runs the expression in a lightweight coroutine.
public func co(_ routine: @autoclosure @escaping () -> Void) {
    var _routine: () -> Void = routine
    CLibvenice.co(&_routine, { routinePointer in
        routinePointer!.assumingMemoryBound(to: (() -> Void).self).pointee()
    }, "co")
}

/// Runs the expression in a lightweight coroutine after the given duration.
public func after(_ napDuration: Double, routine: @escaping () -> Void) {
    co {
        nap(for: napDuration)
        routine()
    }
}

/// Runs the expression in a lightweight coroutine periodically. Call done() to leave the loop.
public func every(_ napDuration: Double, routine: @escaping (_ done: () -> Void) -> Void) {
    co {
        var done = false
        while !done {
            nap(for: napDuration)
            routine {
                done = true
            }
        }
    }
}

/// Sleeps for duration.
public func nap(for duration: Double) {
    mill_msleep(duration.fromNow().int64milliseconds, "nap")
}

/// Wakes up at deadline.
public func wake(at deadline: Double) {
    mill_msleep(deadline.int64milliseconds, "wakeUp")
}

/// Passes control to other coroutines.
public var yield: Void {
    mill_yield("yield")
}

/// Fork the current process.
public func fork() -> PID {
    return mfork()
}

/// Get the number of logical CPU cores available. This might return a bigger number than the physical CPU Core number if the CPU supports hyper-threading.
public var logicalCPUCount: Int {
    return Int(mill_number_of_cores())
}

public func dump() {
    goredump()
}

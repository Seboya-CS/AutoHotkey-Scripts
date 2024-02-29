#SingleInstance force
#Requires AutoHotkey >=2.0-
SetWinDelay 2
CoordMode "Mouse"


monitors := []

Class mon {
	
	__New(n) {
        DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
		MonitorGet(n, &left, &top, &right, &bottom)
		this.left := left
		this.top := top
		this.right := right
		this.bottom := bottom
        this.TopBottomDirection
        this.LeftRightDirection
	}
	left {
		get {
			return this._left
		}
		set {
			this._left := value
		}
	}
	top {
		get {
			return this._top
		}
		set {
			this._top := value
		}
	}
	right {
		get {
			return this._right
		}
		set {
			this._right := value
		}
	}
	bottom {
		get {
			return this._bottom
		}
		set {
			this._bottom := value
		}
    }
    IsInMonitor(x, y) {
        return (x >= this.left && x <= this.right && y >= this.top && y <= this.bottom)
    }
}

Class square {
    __New(x, y, h, w) {
        this.left := x
        this.right := x + w
        this.top := y
        this.bottom := y + h
    }
    left {
        get {
            return this._left
        }
        set {
            this._left := value
        }
    }
    right {
        get {
            return this._right
        }
        set {
            this._right := value
        }
    }
    top {
        get {
            return this._top
        }
        set {
            this._top := value
        }
    }
    bottom {
        get {
            return this._bottom
        }
        set {
            this._bottom := value
        }
    }
    TopLeftMonitor() {
        global monitors
        loop monitors.Length {
            if (monitors[A_Index].IsInMonitor(this.left, this.top)) {
                return A_Index
            }
        }
    }
    TopRightMonitor() {
        global monitors
        loop monitors.Length {
            if (monitors[A_Index].IsInMonitor(this.right, this.top)) {
                return A_Index
            }
        }
    }
    BottomLeftMonitor() {
        global monitors
        loop monitors.Length {
            if (monitors[A_Index].IsInMonitor(this.left, this.bottom)) {
                return A_Index
            }
        }
    }
    BottomRightMonitor() {
        global monitors
        loop monitors.Length {
            if (monitors[A_Index].IsInMonitor(this.right, this.bottom)) {
                return A_Index
            }
        }
    }
    SplitMonitor() {
        tl := this.TopLeftMonitor()
        tr := this.TopRightMonitor()
        bl := this.BottomLeftMonitor()
        br := this.BottomRightMonitor()
        if (tl = tr && tr = bl && bl = br) {
            return tl
        } else {
            return 0
        }
    }
}

GetMonitorInfo() {
    global monitors
    monitors.Length := MonitorGetCount()
    Loop monitors.Length {
        monitors[A_Index] := mon(A_Index)
    }
}

CheckMonitor(x, y, h, w) {
    global monitors
    temp := square(x, y, h, w)
    return temp.SplitMonitor()
}

let Hooks = {}

let Debugger = Hooks.Debugger = {
  create() {
    // Create the engagementTime element on the page
    this.ensureElement()
    // Initialize the engagement time variable to 0
    this.engagementTime = 0
    console.log(this.el)
    return this
  },

  mounted() {
    // Initialize the engagement time variable to 0
    this.engagementTime = 0
  },

  /**
   * Clear the timer
   */
  pause() {
    this.timer = clearInterval(this.timer)
  },

  /**
   * If the document is not hidden, reset the timer
   */
  resume() {
    if (!document.hidden) {
      this.timer = clearInterval(this.timer)
      this.timer = setInterval(this.onInterval.bind(this), 500)
    }
  },

  /**
   * Reset all time
   */
  unload() {
    this.resetTime()
  },

  /**
   * Resets time.
   * Resets the timer and counter.
   * Removes the counter element and creates a new one
   */
  resetTime() {
    this.timer = clearInterval(this.timer)
    this.engagementTime = 0

    this.ensureElement()
  },

  /**
   * If no counter element exists on the page,
   * create one
   */
  ensureElement() {
    if (!this.el) {
      var value = document.createElement("span")
      value.innerHTML = this.engagementTime
      this.el = document.createElement("div")
      this.el.classList.add('absolute', 'p-4', 'bg-orange-400/80', 'text-white', 'cursor-default')
      this.el.append(document.createTextNode("Current engagement time: "))
      this.el.append(value)
      document.body.prepend(this.el)
      this.el.value = value
    }
  },

  /**
   * Update the counter value on each interval run
   */
  onInterval() {
    this.engagementTime += 0.5
    this.updateEngagementTime()
  },

  /**
   * Update the counter value
   */
  updateEngagementTime() {
    this.ensureElement()
    this.el.value.innerHTML = this.engagementTime
  },

  setEngagementTime(engagementTime) {
    this.engagementTime = engagementTime
    this.updateEngagementTime()
  }
}

Hooks.PageView = {
  mounted() {
    // Store the current page name
    this.currentPage = this.getPage()

    this.debugger = Debugger.create()

    // Monitor tab visibility change events
    document.addEventListener("visibilitychange", () => {
      if (document.hidden) {
        this.pause()
      } else {
        this.resume()
      }
    })

    // When the window is no longer in foreground, pause the pageview
    window.addEventListener("blur", (e) => {
      this.pause()
    })

    // When the window is back in foreground, resume the pageview
    window.addEventListener("focus", (e) => {
      if (!document.hidden) {
        this.resume()
      }
    })

    // When the window is unloaded (browser/tab closed)
    window.addEventListener("beforeunload", (e) => {
      this.unload()
    }, false);

    // Attempt resuming the pageview, if the document is not hidden
    this.resume()
  },

  /**
   * Whenever the element gets updated,
   * if the page has changed, reset time and resume pageview 
   */
  updated() {
    page = this.getPage()
    if (this.currentPage != page) {
      this.currentPage = page
      this.debugger.resetTime()
      this.resume()
    }
  },

  /**
   * Pause the PageView
   * Clear the timer
   * and send the `page-pause` event to the backend
   */
  pause() {
    this.debugger.pause()
    this.signalPause()
  },

  /**
   * Resume the PageView
   * If the document is not hidden, reset the timer
   * and send the `page-resume` event to the backend
   */
  resume() {
    if (!document.hidden) {
      this.debugger.resume()
      this.signalResume()
    }
  },

  /**
   * Unload the PageView
   * Reset all time
   * and send the `page-unload` event to the backend
   */
  unload() {
    this.debugger.unload()
    this.signalUnload()
  },

  /**
   * Resets time.
   * Resets the timer and counter.
   * Removes the counter element and creates a new one
   */
  resetTime() {
    this.timer = clearInterval(this.timer)
    this.engagementTime = 0
    if (this.el.firstChild == this.elEngagementTime) {
      this.el.removeChild(this.elEngagementTime)
    }
    this.elEngagementTime = null
    this.ensureEngagementTimeElement()
  },

  /**
   * If no counter element exists on the page,
   * create one
   */
  ensureEngagementTimeElement() {
    if (!this.elEngagementTime) {
      var value = document.createElement("span")
      value.innerHTML = this.engagementTime
      this.elEngagementTime = document.createElement("div")
      this.elEngagementTime.append(document.createTextNode("Current engagement time: "))
      this.elEngagementTime.append(value)
      this.el.prepend(this.elEngagementTime)
      this.elEngagementTime.value = value
    }
  },

  /**
   * Update the counter value on each interval run
   */
  onInterval() {
    this.engagementTime += 0.5
    this.updateEngagementTime()
  },

  /**
   * Update the counter value
   */
  updateEngagementTime() {
    this.ensureEngagementTimeElement()
    this.elEngagementTime.value.innerHTML = this.engagementTime
  },

  /**
   * Send the `page-pause` event to the backend
   */
  signalPause() {
    this.pushEvent("page-pause", { page: this.currentPage }, (reply, ref) => {
      this.debugger.setEngagementTime(reply["engagementTime"])
    })
  },

  /**
   * Send the `page-resume` event to the backend
   */
  signalResume() {
    this.pushEvent("page-resume", { page: this.currentPage }, (reply, ref) => {
      this.debugger.setEngagementTime(reply["engagementTime"])
    })
  },

  /**
   * Send the `page-unload` event to the backend
   */
  signalUnload() {
    this.pushEvent("page-unload", { page: this.currentPage }, (reply, ref) => {
      this.debugger.setEngagementTime(reply["engagementTime"])
    })
  },

  /**
   * Retrieve the page set on the element
   */
  getPage() {
    return this.el.dataset.page
  }
}


export { Hooks }

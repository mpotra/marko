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

export { Hooks }

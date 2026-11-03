// Preload for `marp -s`: bind host-less TCP listens to loopback only.
// Marp CLI calls server.listen(port) without a host, which binds all interfaces.
// Load it per command via NODE_OPTIONS="--require=<this file>", never globally.
'use strict'

const net = require('net')

const LOOPBACK = '127.0.0.1'
const PATCHED = Symbol.for('marp.loopback.patched')

// Patch only once, even if the file is required twice.
if (!net.Server.prototype[PATCHED]) {
  const originalListen = net.Server.prototype.listen

  // A port is a number, or a string of digits (Node treats other strings as pipe paths).
  const isPort = (v) => typeof v === 'number' || (typeof v === 'string' && /^\d+$/.test(v))

  net.Server.prototype.listen = function (...args) {
    const [first, second] = args

    if (isPort(first)) {
      // listen(port, host, ...) with a real host: leave as is.
      if (typeof second === 'string') return originalListen.apply(this, args)
      // listen(port, undefined|null, backlog, cb) e.g. from ws: fill the empty host slot.
      if (args.length >= 2 && (second === undefined || second === null)) {
        args[1] = LOOPBACK
      } else {
        // listen(port), listen(port, cb), listen(port, backlog, cb): insert host after port.
        args.splice(1, 0, LOOPBACK)
      }
    } else if (first && typeof first === 'object' && !Array.isArray(first) &&
               first.path === undefined && first.port !== undefined && !first.host) {
      // listen({ port }) without host or path: add host, keep the other options.
      args[0] = { ...first, host: LOOPBACK }
    }
    // Pipe paths, handles, listen() without args and explicit hosts pass through unchanged.
    return originalListen.apply(this, args)
  }

  Object.defineProperty(net.Server.prototype, PATCHED, { value: true })
}

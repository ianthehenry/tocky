window.util =
  on: (events..., fn) -> fn.on(events...)
  prop: (deps..., fn) -> fn.property(deps...)
  observes: (paths..., fn) -> fn.observes(paths...)
  getter: (fn) -> fn.property().volatile().readOnly()
  readOnly: (fn) -> fn.property().readOnly()
  assert: (val, message) -> unless val then throw new Error message

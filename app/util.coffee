window.util =
  on: (events..., fn) -> fn.on(events...)
  prop: (deps..., fn) -> fn.property(deps...)
  getter: (fn) -> fn.property().volatile().readOnly()
  assert: (val, message) -> unless val then throw new Error message

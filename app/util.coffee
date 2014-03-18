window.util =
  on: (events..., fn) -> fn.on(events...)
  prop: (deps..., fn) -> fn.property(deps...)

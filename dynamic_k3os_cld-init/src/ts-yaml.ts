import { load as original } from "js-yaml"

export const load = <T = ReturnType<typeof original>>(
  ...args: Parameters<typeof original>
): T => load(...args)

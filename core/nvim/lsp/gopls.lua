return {
  settings = {
    gopls = {
      -- https://go.dev/gopls/inlayHints#functiontypeparameters
      hints = {
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
        ignoredError = true,
        constantValues = true,
      },
    },
  },
}

export interface IGitCommandOptions {
  silent?: boolean
}

export interface IRepo {
  git(command: string, options?: IGitCommandOptions): string
}

export interface IBranch {
  name: string
  gitName: string
  hash(): string
  resetHash(): void
}

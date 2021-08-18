import { ExecOptions } from "shelljs";

export interface IRepo {
  git(command: string, options?: ExecOptions): string;
}

export interface IBranch {
  name: string;
  gitName: string;
  hash(): string;
  resetHash(): void;
}

import { IRepo } from "./types";
import { printProgress, clearLine } from "../utils";

export class Remote {
  constructor(private repo: IRepo, public name: string) {
    this.name = name;
  }

  public fetch(): void {
    printProgress(`Fetching remote '${this.name}'`);
    this.repo.git(`fetch ${this.name}`);
    clearLine();
  }

  public prune(): void {
    printProgress(`Removing dead branches from '${this.name}'`);
    this.repo.git(`remote prune ${this.name}`);
    clearLine();
  }
}

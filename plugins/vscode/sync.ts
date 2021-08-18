import { copyFileSync, existsSync, readFileSync, statSync } from "fs";
import { join } from "path";
import { exec } from "shelljs";
import ExtensionSyncer from "./extension_syncer";

class Syncer {
  private configPath: string;

  constructor() {
    this.configPath = this.getConfigPath();
  }

  public run(): void {
    this.syncConfigFiles("settings.json");
    this.syncConfigFiles("keybindings.json");
    new ExtensionSyncer(this.configPath).run();

    if (process.platform === "darwin") {
      exec("defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false");
    }
  }

  private getConfigPath(): string {
    switch (process.platform) {
      case "win32":
        return join(process.env.USERPROFILE, "AppData", "Roaming", "Code");

      case "darwin":
        return join(process.env.HOME, "Library", "Application Support", "Code");

      default:
        return join(process.env.HOME, ".config", "Code");
    }
  }

  private syncConfigFiles(filename: string): void {
    const dotfilesPath = join(__dirname, filename);
    const vscodePath = join(this.configPath, "User", filename);

    if (!existsSync(vscodePath)) {
      console.info("  Using dotfiles version (target is missing)");
      copyFileSync(dotfilesPath, vscodePath);
    }

    if (readFileSync(dotfilesPath).toString() === readFileSync(vscodePath).toString()) {
      return;
    }

    const dotfilesStat = statSync(dotfilesPath);
    const vscodeStat = statSync(vscodePath);

    console.info(`Config file '${filename}' has changed`);

    if (dotfilesStat.mtime > vscodeStat.mtime) {
      console.info("  Using dotfiles version");
      copyFileSync(dotfilesPath, vscodePath);
    } else {
      console.info("  Updating dotfiles version");
      copyFileSync(vscodePath, dotfilesPath);
    }
  }
}
new Syncer().run();

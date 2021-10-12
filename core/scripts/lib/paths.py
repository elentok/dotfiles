from os import path
from pathlib import Path

DOTF = Path(path.abspath(path.join(__file__, "..", "..", "..", "..")))
DOTL = Path.home().joinpath(".dotlocal")


def find_components() -> list[Path]:
    components = find_path_components(DOTF.joinpath("core"))
    components.extend(find_path_components(DOTF.joinpath("extra")))

    local_plugins_path = DOTL.joinpath("plugins")
    if local_plugins_path.exists():
        components.extend(find_path_components(local_plugins_path))

    components.sort(key=lambda c: c.name)
    return components


def find_path_components(path: Path) -> list[Path]:
    components = []
    for item in path.iterdir():
        if item.is_dir():
            if item.joinpath("install").exists():
                components.append(item)
        elif item.is_file():
            components.append(item)

    return components

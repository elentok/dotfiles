#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import shutil
import subprocess
from pathlib import Path


DEFAULT_STUB_BASE = Path(__file__).resolve().parent / ".stubs"
DEFAULT_KITTY_BINARY = "kitty"
EXCLUDED_EXPORTS = {
    "Any",
    "Callable",
    "Color",
    "NamedTuple",
    "Screen",
    "Sequence",
    "StringFormatter",
    "lru_cache",
    "os",
    "partial",
    "re",
    "run_once",
    "safe_builtins",
}
EXCLUDED_EXPORTS_JSON = json.dumps(sorted(EXCLUDED_EXPORTS))
EXCLUDED_FAST_DATA_TYPES_EXPORTS = {
    "false",
    "true",
}
EXCLUDED_FAST_DATA_TYPES_EXPORTS_JSON = json.dumps(sorted(EXCLUDED_FAST_DATA_TYPES_EXPORTS))

RUNPY_CODE = r"""
import json
import inspect
from typing import Union, get_args, get_origin

import kitty.fast_data_types as fast_data_types
from kitty.fast_data_types import Screen
import kitty.tab_bar as tab_bar
from kitty.tab_bar import DrawData, ExtraData, TabBarData


def stringify(value, get_origin=get_origin, get_args=get_args, Union=Union):
    def atom(item):
        if item is None or item is type(None):
            return "None"

        if isinstance(item, str):
            return item

        module = getattr(item, "__module__", "")
        qualname = getattr(item, "__qualname__", "")
        if qualname:
            if module == "builtins":
                return qualname
            if module == "collections.abc":
                return f"collections.abc.{qualname}"
            if module.startswith("kitty.fast_data_types"):
                return qualname
            if module.startswith("kitty.tab_bar"):
                return qualname
            return f"{module}.{qualname}"

        return repr(item)

    if value is None or value is type(None):
        return "None"

    if isinstance(value, str):
        return value

    origin = get_origin(value)
    if origin is not None:
        args = get_args(value)

        if origin is Union:
            return " | ".join(atom(arg) for arg in args)

        origin_name = atom(origin)
        if args:
            args_text = ", ".join(atom(arg) for arg in args)
            return f"{origin_name}[{args_text}]"

        return origin_name

    return atom(value)


def signature_of(obj, inspect=inspect):
    if not callable(obj):
        return None

    try:
        return str(inspect.signature(obj))
    except Exception:
        return None


payload = {
    "fast_data_types_cursor_fields": [name for name in dir(fast_data_types.Cursor) if not name.startswith("_")],
    "fast_data_types_exports": [
        {
            "annotations": {
                key: stringify(value)
                for key, value in getattr(getattr(fast_data_types, name), "__annotations__", {}).items()
            },
            "kind": type(getattr(fast_data_types, name)).__name__,
            "name": name,
            "repr": repr(getattr(fast_data_types, name)),
            "signature": signature_of(getattr(fast_data_types, name)),
        }
        for name in dir(fast_data_types)
        if not name.startswith("_") and name not in __EXCLUDED_FAST_DATA_TYPES_EXPORTS__
    ],
    "exports": [
        {
            "annotations": {
                key: stringify(value)
                for key, value in getattr(getattr(tab_bar, name), "__annotations__", {}).items()
            },
            "kind": type(getattr(tab_bar, name)).__name__,
            "name": name,
            "repr": repr(getattr(tab_bar, name)),
            "signature": signature_of(getattr(tab_bar, name)),
        }
        for name in dir(tab_bar)
        if not name.startswith("_") and name not in __EXCLUDED_EXPORTS__
    ],
    "tab_bar": {
        "TabBarData": {key: stringify(value) for key, value in TabBarData.__annotations__.items()},
        "DrawData": {key: stringify(value) for key, value in DrawData.__annotations__.items()},
        "ExtraData": {key: stringify(value) for key, value in ExtraData.__annotations__.items()},
    },
    "screen": {
        "public_attributes": [name for name in dir(Screen) if not name.startswith("_")],
    },
}

print(json.dumps(payload, indent=2, sort_keys=True))
"""
RUNPY_CODE = RUNPY_CODE.replace("__EXCLUDED_EXPORTS__", EXCLUDED_EXPORTS_JSON)
RUNPY_CODE = RUNPY_CODE.replace(
    "__EXCLUDED_FAST_DATA_TYPES_EXPORTS__",
    EXCLUDED_FAST_DATA_TYPES_EXPORTS_JSON,
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate local Kitty .pyi stubs from the installed Kitty runtime.",
    )
    parser.add_argument(
        "--kitty-binary",
        default=DEFAULT_KITTY_BINARY,
        help="Path to the Kitty executable to use for `+runpy` introspection.",
    )
    parser.add_argument(
        "--stub-base",
        type=Path,
        default=DEFAULT_STUB_BASE,
        help="Directory where the generated `kitty` stub package root should be written.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print the generated files instead of writing them.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        payload = inspect_kitty(args.kitty_binary)
    except FileNotFoundError as exc:
        raise SystemExit(str(exc)) from exc

    stub_root = args.stub_base / "kitty"

    files = {
        "__init__.pyi": render_init_stub(),
        "fast_data_types.pyi": render_fast_data_types_stub(payload),
        "tab_bar.pyi": render_tab_bar_stub(payload),
    }

    if args.dry_run:
        for name, content in files.items():
            print(f"==> {stub_root / name}")
            print(content, end="" if content.endswith("\n") else "\n")
        return 0

    stub_root.mkdir(parents=True, exist_ok=True)
    for name, content in files.items():
        path = stub_root / name
        path.write_text(content, encoding="utf-8")
        print(path)

    return 0


def inspect_kitty(kitty_binary: str) -> dict[str, object]:
    resolved_kitty_binary = resolve_kitty_binary(kitty_binary)
    result = subprocess.run(
        [str(resolved_kitty_binary), "+runpy", RUNPY_CODE],
        check=True,
        capture_output=True,
        text=True,
    )
    return json.loads(result.stdout)


def resolve_kitty_binary(kitty_binary: str) -> Path:
    candidate = Path(kitty_binary).expanduser()

    if candidate.is_absolute() or "/" in kitty_binary or "\\" in kitty_binary:
        if candidate.is_file():
            return candidate
        raise FileNotFoundError(f"Kitty binary not found: {candidate}")

    which_result = shutil.which(kitty_binary)
    if which_result:
        return Path(which_result)

    if kitty_binary != DEFAULT_KITTY_BINARY:
        raise FileNotFoundError(
            f"Kitty binary `{kitty_binary}` was not found on PATH. "
            "Pass `--kitty-binary /path/to/kitty` to use a specific executable."
        )

    fallback_candidates = [
        Path.home() / ".local/kitty.app/bin/kitty",
    ]
    for fallback in fallback_candidates:
        if fallback.is_file():
            return fallback

    checked = ", ".join(str(path) for path in fallback_candidates)
    raise FileNotFoundError(
        "Could not find the Kitty binary. Checked PATH for `kitty` and these fallback paths: "
        f"{checked}. Pass `--kitty-binary /path/to/kitty` to use a specific executable."
    )


def render_init_stub() -> str:
    return """from .fast_data_types import Color, Cursor, Screen
from .tab_bar import DrawData, ExtraData, TabBarData

__all__ = [
    "Color",
    "Cursor",
    "DrawData",
    "ExtraData",
    "Screen",
    "TabBarData",
]
"""


def render_fast_data_types_stub(payload: dict[str, object]) -> str:
    exports = payload["fast_data_types_exports"]
    cursor_fields = payload["fast_data_types_cursor_fields"]

    lines = [
        "from __future__ import annotations",
        "",
        "from collections.abc import Callable, Sequence",
        "from typing import Any, TypeAlias",
        "",
    ]

    declared_classes = {"Color", "Cursor", "Screen"}

    lines.extend(render_color_class())
    lines.append("")
    lines.extend(render_cursor_class(cursor_fields))
    lines.append("")
    lines.extend(render_screen_class())
    lines.append("")

    for item in exports:
        name = item["name"]
        if name in declared_classes:
            continue

        lines.extend(render_export(item))
        lines.append("")

    all_exports = ", ".join(f'"{item["name"]}"' for item in exports)
    lines.append(f"__all__ = [{all_exports}]")
    lines.append("")

    return "\n".join(lines)


def render_color_class() -> list[str]:
    return [
        "class Color:",
        "    ...",
    ]


def render_cursor_class(cursor_fields: list[str]) -> list[str]:
    type_map = {
        "bg": "int | None",
        "blink": "bool",
        "bold": "bool",
        "decoration": "int",
        "decoration_fg": "int | None",
        "dim": "bool",
        "fg": "int | None",
        "italic": "bool",
        "reverse": "bool",
        "shape": "int",
        "strikethrough": "bool",
        "text_blink": "bool",
        "x": "int",
        "y": "int",
    }
    method_map = {
        "copy": "def copy(self) -> Cursor: ...",
        "reset_display_attrs": "def reset_display_attrs(self) -> None: ...",
    }

    lines = ["class Cursor:"]
    for field in cursor_fields:
        if field in method_map:
            lines.append(f"    {method_map[field]}")
        else:
            lines.append(f"    {field}: {type_map.get(field, 'Any')}")

    return lines


def render_screen_class() -> list[str]:
    return [
        "class Screen:",
        "    cursor: Cursor",
        "    columns: int",
        "    lines: int",
        "    def draw(self, text: str) -> None: ...",
    ]


def render_tab_bar_stub(payload: dict[str, object]) -> str:
    exports = payload["exports"]
    tab_bar_data = payload["tab_bar"]

    lines = [
        "from __future__ import annotations",
        "",
        "from collections.abc import Callable, Sequence",
        "from typing import Any, TypeAlias",
        "",
        "from .fast_data_types import Color, Screen",
        "",
    ]

    declared_classes = {"TabBarData", "DrawData", "ExtraData"}

    for class_name in ("TabBarData", "DrawData", "ExtraData"):
        annotations = tab_bar_data[class_name]
        lines.append(f"class {class_name}:")

        if annotations:
            for name, annotation in annotations.items():
                lines.append(f"    {name}: {normalize_annotation(annotation)}")
        else:
            lines.append("    pass")

        lines.append("")

    for item in exports:
        name = item["name"]
        if name in declared_classes:
            continue

        lines.extend(render_export(item))
        lines.append("")

    all_exports = ", ".join(f'"{item["name"]}"' for item in exports)
    lines.append(f"__all__ = [{all_exports}]")
    lines.append("")

    return "\n".join(lines)


def render_export(item: dict[str, object]) -> list[str]:
    name = item["name"]
    kind = item["kind"]
    signature = item["signature"]
    annotations = item["annotations"]
    representation = item["repr"]

    if kind == "_CallableGenericAlias":
        return [f"{name}: TypeAlias = {normalize_annotation(representation)}"]

    if kind in {"function", "builtin_function_or_method", "_lru_cache_wrapper", "RunOnce"}:
        return [render_function(name, signature)]

    if kind in {"int", "str"}:
        return [f"{name}: {kind}"]

    if kind == "dict":
        return [f"{name}: dict[str, Any]"]

    if kind == "module":
        return [f"{name}: Any"]

    if representation == "<class 'str'>":
        return [f"{name}: TypeAlias = str"]

    if representation == "typing.Any":
        return [f"{name}: TypeAlias = Any"]

    if kind in {"type", "EnumType", "ABCMeta", "_AnyMeta"}:
        return render_class(name, annotations)

    return [f"{name}: Any"]


def render_function(name: str, signature: str | None) -> str:
    if not signature:
        return f"def {name}(*args: Any, **kwargs: Any) -> Any: ..."

    return f"def {name}{normalize_signature(signature)}: ..."


def render_class(name: str, annotations: dict[str, str]) -> list[str]:
    lines = [f"class {name}:"]
    if annotations:
        for field_name, annotation in annotations.items():
            lines.append(f"    {field_name}: {normalize_annotation(annotation)}")
    else:
        lines.append("    ...")
    return lines


def normalize_annotation(annotation: str) -> str:
    replacements = {
        "typing.Any": "Any",
        "collections.abc.Sequence": "Sequence",
        "collections.abc.Callable": "Callable",
        "fast_data_types.Color": "Color",
        "fast_data_types.Cursor": "Cursor",
        "fast_data_types.Screen": "Screen",
        "kitty.fast_data_types.Color": "Color",
        "kitty.fast_data_types.Cursor": "Cursor",
        "kitty.fast_data_types.Screen": "Screen",
        "kitty.borders.BorderColor": "Any",
        "kitty.borders.Border": "Any",
        "kitty.tab_bar.CellRange": "CellRange",
        "kitty.tab_bar.ColorFormatter": "ColorFormatter",
        "kitty.tab_bar.CustomDrawTitleFunc": "CustomDrawTitleFunc",
        "kitty.tab_bar.DrawData": "DrawData",
        "kitty.tab_bar.ExtraData": "ExtraData",
        "kitty.tab_bar.Formatter": "Formatter",
        "kitty.tab_bar.SupSub": "SupSub",
        "kitty.tab_bar.TabAccessor": "TabAccessor",
        "kitty.tab_bar.TabBar": "TabBar",
        "kitty.tab_bar.TabBarData": "TabBarData",
        "kitty.tab_bar.TabExtent": "TabExtent",
        "kitty.types.Edges": "Any",
        "kitty.types.RunOnce": "Any",
        "kitty.types.WindowGeometry": "Any",
        "re.Pattern[str]": "Any",
        "Region": "Any",
        "~_T": "Any",
    }

    for source, target in replacements.items():
        annotation = annotation.replace(source, target)

    if annotation.startswith("collections.abc.Sequence["):
        return annotation.removeprefix("collections.abc.")

    return annotation


def normalize_signature(signature: str) -> str:
    return normalize_annotation(signature)


if __name__ == "__main__":
    raise SystemExit(main())

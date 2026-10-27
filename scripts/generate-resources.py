#!/usr/bin/env python3
"""Reproduce watchface images from the official ZSvirt source assets."""
import argparse
import json
from pathlib import Path
from PIL import Image, ImageChops, ImageDraw
from configure import APPS, girl_resource_paths, girl_resource_profile

ROOT = Path(__file__).resolve().parents[1]


def render(source, destination, width, height=None, monochrome=False):
    image = Image.open(ROOT / "assets" / source).convert("RGBA")
    bounds = image.getchannel("A").getbbox()
    if bounds is None:
        raise ValueError(f"Empty logo: {source}")
    image = image.crop(bounds)
    if height is None:
        height = round(width * image.height / image.width)
        image = image.resize((width, height), Image.Resampling.LANCZOS)
    else:
        image.thumbnail((width, height), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (width, height), (0, 0, 0, 255))
    canvas.alpha_composite(image, ((width - image.width) // 2, (height - image.height) // 2))
    levels = (0, 255) if monochrome else (0, 85, 170, 255)
    palette = Image.new("P", (1, 1))
    colors = [channel for level in levels for channel in (level, level, level)]
    palette.putpalette(colors + [0] * (768 - len(colors)))
    result = canvas.convert("RGB").quantize(palette=palette, dither=Image.Dither.NONE)
    output = ROOT / destination
    output.parent.mkdir(parents=True, exist_ok=True)
    result.save(output, optimize=True, bits=1 if monochrome else 2)
    print(f"{output.relative_to(ROOT)}: {width}x{height}")


def save_girl_bitmap(image, directory, resource_id, filename, colors):
    if colors is None:
        # AMOLED device packages use 16-bit RGB565 resources.
        channels = [
            channel.point([round(round(value * levels / 255) * 255 / levels)
                           for value in range(256)])
            for channel, levels in zip(image.split(), (31, 63, 31))
        ]
        result = Image.merge("RGB", channels)
    else:
        palette = Image.new("P", (1, 1))
        entries = list(colors) + [colors[-1]] * (256 - len(colors))
        palette.putpalette([channel for rgb in entries for channel in rgb])
        result = image.quantize(palette=palette, dither=Image.Dither.FLOYDSTEINBERG)
    directory.mkdir(parents=True, exist_ok=True)
    result.save(directory / filename, optimize=True)
    (directory / "drawables.xml").write_text(
        '<drawables>\n'
        f'    <bitmap id="{resource_id}" filename="{filename}" dithering="none"/>\n'
        '</drawables>\n')
    print(f"{(directory / filename).relative_to(ROOT)}: {image.width}x{image.height}")


def render_girl():
    app_root = APPS["girl"]["root"]
    source = Image.open(app_root / "assets/zsvirt-girl-portrait.png").convert("RGB")
    red, green, blue = source.split()
    highlights = ImageChops.darker(red, ImageChops.darker(green, blue)).point(
        lambda value: 255 if value >= 248 else 0)
    source.paste((255, 255, 255), mask=highlights)
    # Keep the original crop's visual centering, including its 10px rightward offset.
    portrait_crop = source.crop((176, 0, 826, 650))
    launcher_crop = source.crop((300, 0, 730, 430))
    targets = json.loads((app_root / "docs/compatibility.json").read_text())["targets"]
    portraits = {}
    launchers = {}
    for target in targets:
        portrait_path, launcher_path = girl_resource_paths(target)
        _, colors = girl_resource_profile(target)
        screen = target["resolution"]
        icon = target["launcher_icon"]
        portraits[portrait_path] = (screen["width"], screen["height"], colors)
        launchers[launcher_path] = (icon["width"], icon["height"], colors)
    for path, (width, height, colors) in sorted(portraits.items()):
        # Scale both axes equally; wide screens receive white side margins.
        square = portrait_crop.resize((height, height), Image.Resampling.LANCZOS)
        portrait = Image.new("RGB", (width, height), "white")
        portrait.paste(square, ((width - height) // 2, 0))
        portrait_height = round(height * 184 / 280)
        fade_start = round(height * 154 / 280)
        fade_end = round(height * 172 / 280)
        fade = Image.new("L", (width, height), 0)
        draw = ImageDraw.Draw(fade)
        for y in range(fade_start, height):
            draw.line((0, y, width - 1, y),
                      fill=round(255 * min(1, (y - fade_start) / (fade_end - fade_start))))
        portrait = Image.composite(Image.new("RGB", (width, height), "white"), portrait, fade)
        # Keep the white margin below the fade; the view clears the remaining screen.
        portrait = portrait.crop((0, 0, width, portrait_height))
        save_girl_bitmap(portrait, app_root / path, "GirlPortrait", "girl-portrait.png", colors)
    for path, (width, height, colors) in sorted(launchers.items()):
        launcher = launcher_crop.resize((width, height), Image.Resampling.LANCZOS)
        save_girl_bitmap(launcher, app_root / path, "LauncherIcon", "launcher-icon.png", colors)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--face", choices=APPS, default="time")
    args = parser.parse_args()
    if args.face == "girl":
        render_girl()
        return
    targets = json.loads((ROOT / "docs/compatibility.json").read_text())["targets"]
    logos = {}
    launchers = {}
    for target in targets:
        width = target["resolution"]["width"]
        logo_width = target["logo_width"]
        if width in logos and logos[width][0] != logo_width:
            raise ValueError(f"Conflicting logo width for screen width {width}")
        palette = target["resource_palette_colors"]
        monochrome = palette is not None and not {"555555", "AAAAAA"}.issubset(palette)
        logos[width] = (logo_width, monochrome or logos.get(width, (0, False))[1])
        icon = target["launcher_icon"]
        size = (icon["width"], icon["height"])
        launchers[size] = monochrome or launchers.get(size, False)
    for width, (logo_width, monochrome) in sorted(logos.items()):
        directory = ROOT / f"resources-logos/{width}"
        render("zsvirt-horizontal-white.png", directory / "zsvirt-logo.png", logo_width,
               monochrome=monochrome)
        (directory / "drawables.xml").write_text(
            '<drawables>\n    <bitmap id="ZsvirtLogo" filename="zsvirt-logo.png" dithering="none"/>\n</drawables>\n')
    for (width, height), monochrome in sorted(launchers.items()):
        directory = ROOT / f"resources-launchers/{width}x{height}"
        render("zsvirt-symbol-white.png", directory / "launcher-icon.png", width, height,
               monochrome=monochrome)
        (directory / "drawables.xml").write_text(
            '<drawables>\n    <bitmap id="LauncherIcon" filename="launcher-icon.png" dithering="none"/>\n</drawables>\n')


if __name__ == "__main__":
    main()

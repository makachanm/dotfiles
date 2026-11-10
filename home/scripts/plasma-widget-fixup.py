#!/usr/bin/env python3
"""Restore desktop widget positions and the webbrowser widget url.

Run this after plasma-manager re-creates desktop widgets
(home-manager switch that touches panels/widgets), because Plasma's
folder containment grid layout re-places new applets and the
webbrowser applet overwrites its url with the default after creation.

Usage: plasma-widget-fixup [--restart]
"""

import configparser
import os
import re
import subprocess
import sys

FILE = os.path.expanduser("~/.config/plasma-org.kde.plasma.desktop-appletsrc")
RES = "ItemGeometries-2648x1490"  # built-in + DP-1 monitor

# plugin -> x, y, w, h
LAYOUT = {
    "org.kde.plasma.weather": (64, 32, 576, 400),
    "org.kde.plasma.systemmonitor.memory": (64, 432, 240, 240),
    "org.kde.plasma.systemmonitor.net": (64, 672, 240, 240),
    "org.kde.plasma.systemmonitor.cpucore": (304, 432, 336, 480),
    "org.kde.plasma.webbrowser": (64, 912, 576, 448),
}

BROWSER_URL = "https://news.hada.io/"
BROWSER_FAVICON = "https://news.hada.io/favicon-dark.ico?20260826e"


def read_sections(path):
    sections = {}
    cur = None
    with open(path) as f:
        for line in f:
            line = line.rstrip("\n")
            m = re.match(r"^\[(.+)\]$", line)
            if m:
                cur = m.group(1)
                sections.setdefault(cur, {})
            elif "=" in line and cur:
                k, _, v = line.partition("=")
                sections[cur][k] = v
    return sections


def desktop_containment(sections):
    """The folder containment that holds the desktop widgets."""
    folder_ids = []
    for name, entries in sections.items():
        m = re.match(r"^Containments\]\[(\d+)$", name)
        if m and entries.get("plugin") == "org.kde.plasma.folder":
            folder_ids.append(m.group(1))
    for fid in folder_ids:
        if any(k.startswith(f"Containments][{fid}][Applets][")
               for k in sections):
            return fid
    return folder_ids[0] if folder_ids else None


def main():
    if not os.path.exists(FILE):
        sys.exit("appletsrc not found")
    sections = read_sections(FILE)
    cid = desktop_containment(sections)
    if cid is None:
        sys.exit("desktop containment not found")

    # applet id -> plugin
    applets = {}
    for name, entries in sections.items():
        m = re.match(rf"^Containments\]\[{cid}\]\[Applets\]\[(\d+)$", name)
        if m and "plugin" in entries:
            applets[m.group(1)] = entries["plugin"]

    wanted = {aid: LAYOUT[plug] for aid, plug in applets.items() if plug in LAYOUT}
    missing = set(LAYOUT) - {plug for plug in applets.values() if plug in LAYOUT}
    if missing:
        print(f"warning: widgets not found: {sorted(missing)}")

    geo = ";".join(
        f"Applet-{aid}:{x},{y},{w},{h},0"
        for aid, (x, y, w, h) in sorted(wanted.items(), key=lambda kv: kv[1])
    ) + ";"

    browser_id = next((aid for aid, p in applets.items() if p == "org.kde.plasma.webbrowser"), None)

    def kw(groups, key, value):
        cmd = [
            "kwriteconfig6", "--file",
            "plasma-org.kde.plasma.desktop-appletsrc",
            "--group", "Containments", "--group", cid,
        ]
        for g in groups:
            cmd += ["--group", g]
        cmd += ["--key", key, value]
        subprocess.run(cmd, check=True)

    kw([], RES, geo)
    kw([], "ItemGeometriesHorizontal", geo)
    if browser_id:
        g = ["Applets", browser_id, "Configuration", "General"]
        kw(g, "url", BROWSER_URL)
        kw(g, "favIcon", BROWSER_FAVICON)
        kw(g, "useDefaultUrl", "false")

    if "--restart" in sys.argv:
        subprocess.run(
            ["systemctl", "--user", "restart", "plasma-plasmashell.service"],
            check=True,
        )
    print("done: positions restored"
          + (f", browser url set (applet {browser_id})" if browser_id else ""))


if __name__ == "__main__":
    main()

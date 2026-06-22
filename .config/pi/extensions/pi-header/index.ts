/**
 * pi-pixel-header
 *
 * Custom TUI header with pixel Pi logo and Catppuccin Mocha accents.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function ansi(code: number, text: string): string {
  return `\x1b[38;5;${code}m${text}\x1b[0m`;
}

function center(text: string, width: number): string {
  const padding = Math.max(0, Math.floor((width - text.length) / 2));
  return `${" ".repeat(padding)}${text}`;
}

// Pi logo — pixel "P" from pi.dev SVG, mapped to 4x4 grid
// ■ ■ ■ ·
// ■ · ■ ·
// ■ ■ · ■
// ■ · · ■
const B = "██";
const S = "  ";
const LOGO = [
  `${B}${B}${B}${S}`,
  `${B}${S}${B}${S}`,
  `${B}${B}${S}${B}`,
  `${B}${S}${S}${B}`,
];

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    ctx.ui.setHeader((_tui, _theme) => {
      return {
        render(_width: number): string[] {
          const lines: string[] = [];

          for (const line of LOGO) {
            lines.push(ansi(209, center(line, _width)));
          }

          return lines;
        },
        invalidate() {},
      };
    });
  });

  pi.registerCommand("default-header", {
    description: "Restore built-in header",
    handler: async (_args, ctx) => {
      ctx.ui.setHeader(undefined);
      ctx.ui.notify("Built-in header restored", "info");
    },
  });
}

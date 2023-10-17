import { prompt, type Values } from "./.flows/type.ts";
import { $ } from "npm:zx";

export const SCHEMA = {
  word: prompt.text({ label: "Word", required: true }),
};

export const RUN = ({ word }: Values<typeof SCHEMA>) => {
  $`xdg-open https://youglish.com/pronounce/${word}/english/us`;
};

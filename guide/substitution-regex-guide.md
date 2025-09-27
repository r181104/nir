# 📝 The Ultimate Neovim Substitution & Regex Guide

Welcome, fellow Vim explorer! 🚀 This is your **one-stop, complete guide** to mastering substitution (`:s`) in Neovim **with regex**. By the end, you won’t need any other guide. Let’s dive in!

---

## 🔑 Basics of Substitution

The general form is:

```vim
:[range]s/{pattern}/{replacement}/[flags]
```

* **`[range]`** → Which lines to affect
* **`{pattern}`** → What you’re searching for (regex supported ✅)
* **`{replacement}`** → What to replace it with
* **`[flags]`** → Extra options (like replace all, confirm, etc.)

✨ Example:

```vim
:%s/cat/dog/g
```

➡️ Replace all `cat` with `dog` in the entire file.

---

## 🎯 Ranges in Substitution

* `:%` → Whole file 📜
* `:1,10` → Lines 1 to 10 🔢
* `:.,$` → From current line (`.`) to end (`$`) 🏁
* `:'<,'>` → Selected lines in Visual mode ✂️

👉 You can even use search patterns in ranges:

```vim
:/start/,/end/s/foo/bar/g
```

➡️ Replace only between lines containing `start` and `end`.

---

## ⚡ Flags Cheat Sheet

* `g` → Replace **all** matches on a line (not just the first)
* `c` → Confirm each replacement 🤔
* `i` → Ignore case 🔠
* `I` → Case-sensitive match 🔡
* `n` → Show number of matches (no change) 🔍
* `p` → Print each line after substitution 📢

Example with confirmation:

```vim
:%s/todo/done/gc
```

➡️ Go through every `todo` and decide whether to replace.

---

## 🔮 Regex in Neovim

Regex = **power tool** 🛠️ for text matching.

### 🧩 Basic Patterns

* `.` → Any character (except newline)
* `\d` → Digit (0–9)
* `\w` → Word character (letters, digits, underscore)
* `\s` → Whitespace
* `\t` → Tab character
* `^` → Start of line ⬆️
* `$` → End of line ⬇️
* `\b` → Word boundary 📍

### 📦 Quantifiers

* `*` → 0 or more
* `+` → 1 or more
* `?` → 0 or 1 (optional)
* `{n}` → Exactly n times
* `{n,m}` → Between n and m times
* `{,m}` → Up to m times

### 🎭 Groups & Alternation

* `(abc)` → Grouping
* `\1`, `\2`... → Backreferences to groups
* `a|b` → Either `a` or `b`

---

## 🛠️ Practical Regex + Sub Examples

1. **Add quotes around numbers**

```vim
:%s/\d\+/"&"/g
```

➡️ Turns `123` → `"123"` everywhere.

2. **Remove trailing spaces**

```vim
:%s/\s\+$//
```

➡️ Clean up ugly whitespace! ✨

3. **Swap words (capture groups)**

```vim
:%s/\(\w\+\) \(\w\+\)/\2 \1/g
```

➡️ Turns `first last` → `last first`.

4. **Only match at start of line**

```vim
:%s/^ERROR/⚠️ ERROR/
```

➡️ Adds emoji in front of every `ERROR` line.

5. **Replace tabs with 4 spaces**

```vim
:%s/\t/    /g
```

➡️ Converts indentation.

6. **Add a semicolon if missing**

```vim
:%s/[^;]$/&;/
```

➡️ Ensures every line ends with a semicolon.

7. **Reformat date (YYYY-MM-DD → DD/MM/YYYY)**

```vim
:%s/\(\d\{4}\)-\(\d\{2}\)-\(\d\{2}\)/\3\/\2\/\1/g
```

➡️ 2025-09-14 → 14/09/2025.

---

## 💡 Advanced Tips

* `&` → Reuse last replacement pattern
* `:s//new/` → Reuse last search, change replacement only
* `:&&` → Repeat last substitution with same settings
* `:noh` → Clear highlights after searching 🔦
* `:%s///gn` → Count matches without changing text 🔢
* `:%s///~` → Repeat last replacement string
* Use `:vimgrep` with regex to preview matches before replacing
* `:%s/foo/bar/ge` → Replace `foo` with `bar`, **ignore errors** if no match
* Use `:%!command` to pipe buffer through external tools (like `sed`, `awk`, `jq`) 🌐
* `:%s/\vpattern/replacement/` → Use **very magic mode** (`\v`) for cleaner regex syntax (less escaping)

---

## 🎓 Extra Beginner-Friendly Tricks

✅ **Preview before replacing**

```vim
:%s/foo/bar/gn
```

➡️ Counts how many matches before making changes.

✅ **Do it line by line**

```vim
:%s/foo/bar/gc
```

➡️ Lets you confirm each change interactively.

✅ **Search only, don’t replace**

```vim
/word
```

➡️ Highlights `word`, move with `n` (next) and `N` (previous).

✅ **Limit to a block of code**

* Select lines in **Visual Mode** → `:'<,'>s/foo/bar/g`

✅ **Change only whole words**

```vim
:%s/\<foo\>/bar/g
```

➡️ Doesn’t replace `foobar`, only `foo`.

✅ **Dry-run complex patterns**

* Test first with `/pattern` before `:s`.

✅ **Save time with macros**

* Record (`q`), run substitution, replay (`@`).

✅ **Undo mistakes instantly**

* Just press `u` after substitution. (Phew 😅)

✅ **Keep your hands on home row**

* Use `:noh` after searches to remove distracting highlights.

---

## 🏆 Exercises with Solutions

1. Replace all `foo` with `bar` **only in the first 20 lines**.

```vim
:1,20s/foo/bar/g
```

2. Add `;` at the end of every line that doesn’t already have one.

```vim
:%s/[^;]$/&;/
```

3. Turn `2025-09-14` into `14/09/2025`.

```vim
:%s/\(\d\{4}\)-\(\d\{2}\)-\(\d\{2}\)/\3\/\2\/\1/g
```

4. Replace `TODO: something` with ✅ `Done: something`.

```vim
:%s/^TODO:/✅ Done:/g
```

5. Delete all blank lines.

```vim
:%s/^\s*$//g
```

6. Replace only the **first word of every line**.

```vim
:%s/^\w\+/NEWWORD/
```

7. Convert snake\_case to camelCase.

```vim
:%s/_\(\w\)/\u\1/g
```

➡️ `hello_world` → `helloWorld`.

---

## 📚 Quick Reference Cheatsheet

**Substitution Command:**

```vim
:[range]s/{pattern}/{replacement}/[flags]
```

**Ranges:**

* `%` → whole file
* `1,10` → lines 1–10
* `.,$` → current → end
* `'<,'>` → visual selection
* `/pat1/,/pat2/` → between patterns

**Flags:**

* `g` → global on line
* `c` → confirm
* `i` → ignore case
* `I` → match case
* `n` → count only
* `p` → print result line
* `e` → no error if no match

**Regex Essentials:**

* `.` any char | `\d` digit | `\w` word | `\s` space
* `^` start | `$` end | `\b` boundary
* `*` 0+ | `+` 1+ | `?` 0/1 | `{n,m}` repeat
* `( )` group | `\1` backref | `a|b` alt
* `\<` start of word | `\>` end of word
* `\v` very magic regex mode (less escaping!)

---

## 🎉 Final Words

You now have **everything**: basics, ranges, flags, regex, advanced tricks, beginner tips, and exercises ✅. This guide is your **all-in-one substitution + regex bible** for Neovim.

Substitution is like wielding a **lightsaber** ✨—powerful but precise. Combine it with regex, and you’ll be unstoppable. 🧙‍♂️

👉 Happy Vimming! 🖤

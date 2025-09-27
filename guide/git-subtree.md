# 🌳 Git Subtree Guide

A **Git Subtree** lets you include one Git repository inside another without the extra complexity of submodules.  
When you clone the main repository, the nested one is included **automatically** ✨.

---

## 📌 Why use Subtrees?
- ✅ No need for extra commands after cloning  
- ✅ Easy to keep the nested repo updated  
- ✅ Works well when you want **one seamless repo**  

---

## 🚀 Setup Instructions

### 1. Go to your main repository
```bash
cd main-repo
````

### 2. Add the nested repo as a remote

```bash
git remote add nested https://github.com/username/nested-repo.git
```

### 3. Fetch it

```bash
git fetch nested
```

### 4. Add it as a subtree

Here, we add the `main` branch of `nested-repo` into the folder `path/to/nested-repo`:

```bash
git subtree add --prefix=path/to/nested-repo nested main --squash
```

💡 *You can replace `main` with any branch you want.*

---

## 🔄 Updating Later

To pull in the latest changes from the nested repo:

```bash
git subtree pull --prefix=path/to/nested-repo nested main --squash
```

---

## 📂 Cloning

Anyone who clones your **main repo** will automatically get the nested repo contents:

```bash
git clone https://github.com/username/main-repo.git
```

👉 No extra steps required! 🎉

---

## 🆚 Subtree vs Submodule

| Feature            | 🌳 Subtree | 📦 Submodule      |
| ------------------ | ---------- | ----------------- |
| Included on clone  | ✅ Yes      | ❌ No (needs init) |
| Independent repo   | ⚡ Kind of  | ✅ Yes             |
| Easy for users     | ✅ Yes      | ❌ No              |
| Good for vendoring | ✅ Yes      | ❌ No              |

---

## 🎯 Summary

* Use **Subtree** if you want a smooth experience for everyone cloning your repo.
* Use **Submodule** if you need strict separation of projects.

✨ *For most cases, subtrees are the simpler and friendlier choice!*

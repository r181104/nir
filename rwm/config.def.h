static const char nord0[]  = "#2E3440"; // Polar Night 0 - background
static const char nord1[]  = "#3B4252"; // Polar Night 1 - darker elements
static const char nord2[]  = "#434C5E"; // Polar Night 2 - borders
static const char nord3[]  = "#4C566A"; // Polar Night 3 - faded text
static const char nord4[]  = "#D8DEE9"; // Snow Storm 0 - normal text
static const char nord5[]  = "#E5E9F0"; // Snow Storm 1 - light highlight
static const char nord6[]  = "#ECEFF4"; // Snow Storm 2 - bright text
static const char nord8[]  = "#88C0D0"; // Frost 0 - selected background
static const char nord9[]  = "#81A1C1"; // Frost 1 - subtle accent
static const char nord11[] = "#BF616A"; // Aurora 0 - red accent
static const char nord12[] = "#B48EAD"; // Aurora 1 - purple accent
static const char nord13[] = "#D08770"; // Aurora 2 - orange accent

/* Window & Bar settings */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "MesloLGS Nerd Font:size=14" };
static const unsigned int gappih    = 4;        /* horiz inner gap */
static const unsigned int gappiv    = 4;        /* vert inner gap */
static const unsigned int gappoh    = 4;        /* horiz outer gap */
static const unsigned int gappov    = 4;        /* vert outer gap */
static       int smartgaps          = 1;        /* 1 = no outer gap if only 1 window */
static const int vertpad            = 2;        /* bar vertical padding */
static const int sidepad            = 8;        /* bar horizontal padding */
static int hidden_tags_start = 5;               // zero-indexed, tags 6–10 are hidden
static int hidden_tags_visible = 1;             // 0 = hidden, 1 = visible

/* Colors */
static const char *colors[][3] = {
    /*               fg           bg        border   */
    [SchemeNorm] = { nord4,      nord0,    nord2 },    // normal text: light on dark
    [SchemeSel]  = { nord6,      nord8,    nord13 },   // selected: bright text on icy bg with orange border
};

static const char *tags[] = {
    "  ", "  ", "  ", "  ", "  ",
    "  ", "  ", "  ", "  ", "  "
};

/* rules */
static const Rule rules[] = {
    { "Gimp",     NULL,       NULL,       0,            1,           -1 },
    { "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.5;
static const int nmaster     = 1;
static const int resizehints = 1;
static const int lockfullscreen = 1;
static const int refreshrate = 60;

#define FORCE_VSPLIT 1
#include "vanitygaps.c"

static const Layout layouts[] = {
    { "﩯",      tile },
    { "舘",      spiral },
    { "",      NULL },
    { "",      monocle },
    { "﩯﩯",    dwindle },
    { "ﳴ",      deck },
    { "",      bstack },
    { "恵",      bstackhoriz },
    { "﩯恵",    grid },
    { "",      nrowgrid },
    { "ﭿ",      horizgrid },
    { "",      gaplessgrid },
    { "﩯並",    centeredmaster },
    { "ﲔ",      centeredfloatingmaster }
};

/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
    { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *menu[] = {
    "bemenu-run",
    "--fn", "MesloLGS Nerd Font 20",
    "-l", "8",
    "-i",
    "--nb", "#2E3440",
    "--nf", "#D8DEE9",
    "--sb", "#88C0D0",
    "--sf", "#ECEFF4",
    "--hb", "#3B4252",
    "--hf", "#D8DEE9",
    NULL
};

static const char *termcmd[]  = { "alacritty", NULL };
static const char *browser0[]  = { "firefox-developer-edition", "--no-remote", NULL };
static const char *browser1[]  = { "brave",  "--no-sandbox", "--disable-extensions", "--disable-plugins", "--disable-background-networking", "--disk-cache-dir=/tmp/brave-cache", "--new-window about:blank", NULL };
static const char *incvol[] = {"/usr/bin/amixer", "set", "Master", "5%+", NULL};
static const char *decvol[] = {"/usr/bin/amixer", "set", "Master", "5%-", NULL};
static const char *brightnessup[] = { "brightnessctl", "set", "5%+", NULL };
static const char *brightnessdown[] = { "brightnessctl", "set", "5%-", NULL };

/* keys */
static const Key keys[] = {
    { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
    { MODKEY,                       XK_space,  spawn,          {.v = menu } },
    { MODKEY,                       XK_b,      spawn,          {.v = browser0 } },
    { MODKEY|ShiftMask,             XK_b,      spawn,          {.v = browser1 } },
    { MODKEY,                       XK_f,      togglefullscr,  {0} },
    { MODKEY|ShiftMask,             XK_f,      togglebar,      {0} },
    { MODKEY,                       XK_j,      shiftview,      { .i = -1 } },
    { MODKEY,                       XK_k,      shiftview,      { .i = +1 } },
    { MODKEY,                       XK_Left,   shiftview,      { .i = -1 } },
    { MODKEY,                       XK_Right,  shiftview,      { .i = +1 } },
    { ALTKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { ALTKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { ALTKEY,                       XK_h,      setmfact,       {.f = -0.05} },
    { ALTKEY,                       XK_l,      setmfact,       {.f = +0.05} },
    { MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
    { MODKEY,                       XK_Tab,    view,           {0} },
    { MODKEY,                       XK_q,      killclient,     {0} },
    { MODKEY|ShiftMask,             XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_p,      togglefloating, {0} },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    TAGKEYS(                        XK_6,                      5)
    TAGKEYS(                        XK_7,                      6)
    TAGKEYS(                        XK_8,                      7)
    TAGKEYS(                        XK_9,                      8)
    TAGKEYS(                        XK_0,                      9)
    { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
    { MODKEY|ShiftMask,             XK_r,      quit,           {1} },
    { 0,XF86XK_AudioLowerVolume,               spawn,          {.v = decvol} },
    { 0,XF86XK_AudioRaiseVolume,               spawn,          {.v = incvol} },
    { 0, XF86XK_MonBrightnessUp,               spawn,          {.v = brightnessup } },
    { 0, XF86XK_MonBrightnessDown,             spawn,          {.v = brightnessdown } },
};

/* mouse buttons */
static const Button buttons[] = {
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

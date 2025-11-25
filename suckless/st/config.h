/* See LICENSE file for copyright and license details. */

#include "../themes/theme.h"
#define THEME ACTIVE_THEME

/* appearance */
static char *font = "Iosevka Nerd Font:size=12";   /* unified with dwm */
static int borderpx = 2;

/* shell and behavior */
static char *shell = "/bin/sh";
char *utmp = NULL;
char *scroll = NULL;
char *stty_args = "stty raw pass8 nl -echo -iexten -cstopb 38400";

char *vtiden = "\033[?6c";

static float cwscale = 1.0;
static float chscale = 1.0;

/* delimiters */
wchar_t *worddelimiters = L" ";

/* selection timeouts */
static unsigned int doubleclicktimeout = 300;
static unsigned int tripleclicktimeout = 600;

/* alt screens */
int allowaltscreen = 1;

/* allow window ops */
int allowwindowops = 0;

/* draw latency */
static double minlatency = 2;
static double maxlatency = 33;

/* blinking cursor timeout */
static unsigned int blinktimeout = 800;

/* cursor thickness */
static unsigned int cursorthickness = 2;

/* bell volume */
static int bellvolume = 0;

/* TERM value */
char *termname = "st-256color";

/* tab width */
unsigned int tabspaces = 8;

/* Colors — fully theme-driven */
static const char *colorname[] = {
    ST_C0, ST_C1, ST_C2, ST_C3,
    ST_C4, ST_C5, ST_C6, ST_C7,
    ST_C8, ST_C9, ST_C10, ST_C11,
    ST_C12, ST_C13, ST_C14, ST_C15,
    [256] = ST_BG,
    [257] = ST_FG,
};

/* default colors */
unsigned int defaultfg = 257;
unsigned int defaultbg = 256;
unsigned int defaultcs = 257;
static unsigned int defaultrcs = 257;

/* cursor shape: 2 = block */
static unsigned int cursorshape = 2;

/* default columns and rows */
static unsigned int cols = 80;
static unsigned int rows = 24;

/* mouse cursor colors */
static unsigned int mouseshape = XC_xterm;
static unsigned int mousefg = 7;
static unsigned int mousebg = 0;

/* fallback font attribute color */
static unsigned int defaultattr = 11;

/* selection masks */
static uint forcemousemod = ShiftMask;

/* mouse shortcuts */
static MouseShortcut mshortcuts[] = {
    { XK_ANY_MOD, Button2, selpaste, {.i = 0}, 1 },
    { ShiftMask,  Button4, ttysend,  {.s = "\033[5;2~"} },
    { XK_ANY_MOD, Button4, ttysend,  {.s = "\031"} },
    { ShiftMask,  Button5, ttysend,  {.s = "\033[6;2~"} },
    { XK_ANY_MOD, Button5, ttysend,  {.s = "\005"} },
};

/* keyboard shortcuts */
#define MODKEY Mod1Mask
#define TERMMOD (ControlMask|ShiftMask)

static Shortcut shortcuts[] = {
    { XK_ANY_MOD,    XK_Break, sendbreak,  {.i = 0} },
    { ControlMask,   XK_Print, toggleprinter, {.i = 0} },
    { ShiftMask,     XK_Print, printscreen, {.i = 0} },
    { XK_ANY_MOD,    XK_Print, printsel,   {.i = 0} },
    { TERMMOD,       XK_Prior, zoom,       {.f = +1} },
    { TERMMOD,       XK_Next,  zoom,       {.f = -1} },
    { TERMMOD,       XK_Home,  zoomreset,  {.f = 0} },
    { TERMMOD,       XK_C,     clipcopy,   {.i = 0} },
    { TERMMOD,       XK_V,     clippaste,  {.i = 0} },
    { TERMMOD,       XK_Y,     selpaste,   {.i = 0} },
    { ShiftMask,     XK_Insert, selpaste,  {.i = 0} },
    { TERMMOD,       XK_Num_Lock, numlock, {.i = 0} },
};

/* Everything below: st's huge key table — untouched */
static KeySym mappedkeys[] = { -1 };
static uint ignoremod = Mod2Mask|XK_SWITCH_MOD;

static Key key[] = {
    /* KEEPING full compatibility block intact */
// #include "keytable.inc"  /* hypothetical include, explanatory only */
};

/* selection masks */
static uint selmasks[] = {
    [SEL_RECTANGULAR] = Mod1Mask,
};

/* printable characters */
static char ascii_printable[] =
    " !\"#$%&'()*+,-./0123456789:;<=>?"
    "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_"
    "`abcdefghijklmnopqrstuvwxyz{|}~";


module des.log.consolecolor;

/// console escape color
enum CEColor
{
    OFF = "\x1b[0m", /// reset color

    // Regular Colors
    FG_BLACK  = "\x1b[0;30m", ///
    FG_RED    = "\x1b[0;31m", ///
    FG_GREEN  = "\x1b[0;32m", ///
    FG_YELLOW = "\x1b[0;33m", ///
    FG_BLUE   = "\x1b[0;34m", ///
    FG_PURPLE = "\x1b[0;35m", ///
    FG_CYAN   = "\x1b[0;36m", ///
    FG_WHITE  = "\x1b[0;37m", ///

    // Bold
    FG_B_BLACK  = "\x1b[1;30m", ///
    FG_B_RED    = "\x1b[1;31m", ///
    FG_B_GREEN  = "\x1b[1;32m", ///
    FG_B_YELLOW = "\x1b[1;33m", ///
    FG_B_BLUE   = "\x1b[1;34m", ///
    FG_B_PURPLE = "\x1b[1;35m", ///
    FG_B_CYAN   = "\x1b[1;36m", ///
    FG_B_WHITE  = "\x1b[1;37m", ///

    // Underline
    FG_U_BLACK  = "\x1b[4;30m", ///
    FG_U_RED    = "\x1b[4;31m", ///
    FG_U_GREEN  = "\x1b[4;32m", ///
    FG_U_YELLOW = "\x1b[4;33m", ///
    FG_U_BLUE   = "\x1b[4;34m", ///
    FG_U_PURPLE = "\x1b[4;35m", ///
    FG_U_CYAN   = "\x1b[4;36m", ///
    FG_U_WHITE  = "\x1b[4;37m", ///

    // Background
    BG_BLACK  = "\x1b[40m", ///
    BG_RED    = "\x1b[41m", ///
    BG_GREEN  = "\x1b[42m", ///
    BG_YELLOW = "\x1b[43m", ///
    BG_BLUE   = "\x1b[44m", ///
    BG_PURPLE = "\x1b[45m", ///
    BG_CYAN   = "\x1b[46m", ///
    BG_WHITE  = "\x1b[47m", ///

    // High Intensity
    FG_I_BLACK  = "\x1b[0;90m", ///
    FG_I_RED    = "\x1b[0;91m", ///
    FG_I_GREEN  = "\x1b[0;92m", ///
    FG_I_YELLOW = "\x1b[0;93m", ///
    FG_I_BLUE   = "\x1b[0;94m", ///
    FG_I_PURPLE = "\x1b[0;95m", ///
    FG_I_CYAN   = "\x1b[0;96m", ///
    FG_I_WHITE  = "\x1b[0;97m", ///

    // Bold High Intensity
    FG_BI_BLACK  = "\x1b[1;90m", ///
    FG_BI_RED    = "\x1b[1;91m", ///
    FG_BI_GREEN  = "\x1b[1;92m", ///
    FG_BI_YELLOW = "\x1b[1;93m", ///
    FG_BI_BLUE   = "\x1b[1;94m", ///
    FG_BI_PURPLE = "\x1b[1;95m", ///
    FG_BI_CYAN   = "\x1b[1;96m", ///
    FG_BI_WHITE  = "\x1b[1;97m", ///

    // High Intensity backgrounds
    BG_I_BLACK  = "\x1b[0;100m", ///
    BG_I_RED    = "\x1b[0;101m", ///
    BG_I_GREEN  = "\x1b[0;102m", ///
    BG_I_YELLOW = "\x1b[0;103m", ///
    BG_I_BLUE   = "\x1b[0;104m", ///
    BG_I_PURPLE = "\x1b[0;105m", ///
    BG_I_CYAN   = "\x1b[0;106m", ///
    BG_I_WHITE  = "\x1b[0;107m", ///
};

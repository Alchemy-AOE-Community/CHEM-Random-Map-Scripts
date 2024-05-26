rule chat_warning_notrade_ffa
active
{
    xsChatData("If this is a diplomacy game, please restart and put everyone in team 1.");
    xsChatData("Otherwise you won't be able to make any trade units.");
    xsDisableSelf();
}
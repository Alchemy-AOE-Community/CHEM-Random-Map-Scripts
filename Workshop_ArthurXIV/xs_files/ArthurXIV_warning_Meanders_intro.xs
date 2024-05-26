rule chat_warning_notrade_ffa
active
{
    xsChatData("SmallTrees, Age of Cubes, Topiary Trees etc are forbidden on this map.");
    xsChatData(" ");
    xsChatData("Docking is possible only at map edges.");
    xsDisableSelf();
}
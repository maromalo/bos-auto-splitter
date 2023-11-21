state("BACKOFSPACE")
{
    //GameManager
    bool timerStarted : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x18, 0xE0, 0x60, 0x1C0; 
    bool isMainMenu : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x18, 0xE0, 0x60, 0x194; 

    //SaveLoadManager
    //-gameSaveData
    //--regionsSaveData[]
    int completedTimes : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x10, 0x10, 0x20, 0x1c; //every region's completedTimes just goes to STS's
    //-statistics
    int clicks : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x38, 0x48;
}

startup
{
    settings.Add("IL", false, "Individual Level");
}

start
{
    return ((settings["IL"] && !current.isMainMenu && old.isMainMenu) //on leaving main menu for IL (entering a region, though this also counts entering settings/system/stats/drones/terminal)
    || (current.clicks == 0 && current.timerStarted)); //on game start after factory reset (doesn't count STS intro)
}

split
{
    return (current.completedTimes > old.completedTimes);
}

reset
{
    if (settings["IL"]) {
        return (current.isMainMenu && !old.isMainMenu); //on failing
    }
    return (current.clicks < old.clicks); //on factory reset
}
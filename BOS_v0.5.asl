state("BACKOFSPACE")
{
    //GameManager
    bool timerStarted : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x18, 0xE0, 0x60, 0x1C0; 
    bool isMainMenu : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x18, 0xE0, 0x60, 0x194; 

    //SaveLoadManager
    //-gameSaveData
    //--regionsSaveData[]
    // (all of these are bools)
    byte STScompleted : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x10, 0x10, 0x20, 0x18;
    byte EScompleted : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x10, 0x10, 0x28, 0x18;
    byte EMcompleted : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x10, 0x10, 0x30, 0x18;
    byte FMcompleted : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x10, 0x10, 0x38, 0x18;
    byte TKVcompleted : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x10, 0x10, 0x40, 0x18;

    //-statistics
    int clicks : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x38, 0x48;
}

startup
{
    settings.Add("IL", false, "Individual Level");
}

update
{
    current.completedRegions = current.STScompleted + current.EScompleted + current.EMcompleted + current.FMcompleted + current.TKVcompleted;
}

start
{
    return ((settings["IL"] && !current.isMainMenu && old.isMainMenu) //on leaving main menu for IL (entering a region, though this also counts entering settings/system/stats/drones/terminal)
    || (current.clicks == 0 && current.timerStarted)); //on game start after factory reset (doesn't count STS intro)
}

split
{
    return current.completedRegions > old.completedRegions;
}

reset
{
    if (settings["IL"]) {
        return (current.isMainMenu && !old.isMainMenu); //on failing
    }
    return (current.clicks < old.clicks); //on factory reset
}
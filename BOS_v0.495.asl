state("BACKOFSPACE")
{
    //GameManager
    //int curSelectedRegion : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x18, 0xE0, 0x60, 0x1c4;
    bool timerStarted : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x18, 0xE0, 0x60, 0x1B4; 
    bool isMainMenu : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x18, 0xE0, 0x60, 0x18C; 

    //SaveLoadManager
    //-gameSaveData
    int selectedRegion : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x60;
    //--regionsSaveData[]
    int STScompletedTimes : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x10, 0x10, 0x20, 0x1c;
    int EScompletedTimes : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x10, 0x10, 0x28, 0x1c;
    int EMcompletedTimes : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x10, 0x10, 0x30, 0x1c;
    int FMcompletedTimes : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x30, 0x10, 0x10, 0x38, 0x1c;
    //-statistics
    int clicks : "UnityPlayer.dll", 0x1A36F98, 0x8, 0x0, 0x30, 0x30, 0xE0, 0x60, 0x38, 0x48;
}

startup
{
    settings.Add("IL", false, "Individual Level");
}

start
{
    if ((settings["IL"] && !current.isMainMenu && old.isMainMenu) || (current.clicks == 0 && current.timerStarted)) //can't figure out how to detect STS's intro without counting the tutorial
    {
        vars.cachedTimes = new int[] {current.STScompletedTimes, current.EScompletedTimes, current.EMcompletedTimes, current.FMcompletedTimes};
        vars.lastRegion = current.selectedRegion;
        return true;
    }
}

update
{
    vars.currentTimes = new int[] {current.STScompletedTimes, current.EScompletedTimes, current.EMcompletedTimes, current.FMcompletedTimes};
}

split
{
    if (vars.currentTimes[vars.lastRegion] > vars.cachedTimes[vars.lastRegion])
    {
        if (!settings["IL"]) {
            vars.lastRegion = current.selectedRegion;
            vars.cachedTimes = vars.currentTimes;
        }
        return true;
    }
}

reset
{
    if (settings["IL"]) {
        return (vars.currentTimes[vars.lastRegion] == vars.cachedTimes[vars.lastRegion]) && (current.isMainMenu && !old.isMainMenu); //on failing
    }
    return (current.clicks < old.clicks); //on factory reset
}
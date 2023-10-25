# bos-auto-splitter
 Back Of Space auto splitter for LiveSplit

current problems:
- need a better start detection method
  - starts on settings/system/stats/terminal if IL is on
  - full run starts _after_ STS intro (doesn't it make more sense this way tho?)
- completedTimes is inconsistent, which breaks split method (game bug)
  - might use completed bool instead, but will not work on IL with a save file that has already completed said region
- reset sometimes doesn't work? idk

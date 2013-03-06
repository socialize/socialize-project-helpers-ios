on run argv

    try
    tell Application "CoverStory"
      activate
    end tell
    on error err
      log "\n\n-- Coverstory not found, download coverstory to export html coverage report"
      return
    end try

    tell application "CoverStory"
        set x to open (item 1 of argv)
        tell x to export to HTML in (item 2 of argv)
    end tell
    
    return "Exported CoverStory HTML to " & "'" & item 2 of argv & "'"
end run

local debug = {}

function debug.warn(objectCausingIssue, reason)
    warn(string.format('[TrainJunctionSetup]: "%s" is %s. This may cause issue when train switches on this junction. Click here to find it. -->', objectCausingIssue.Name, reason), objectCausingIssue)
end

return debug
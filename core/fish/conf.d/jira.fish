function jme --description "Show open tickets assigned to me"
    jira issue list --jql 'assignee = currentUser() AND statusCategory != Done AND status != "To Do"' --order-by status
end

abbr --add jc 'jira issue create'

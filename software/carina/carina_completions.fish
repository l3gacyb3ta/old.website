set -l commands create check publish

complete -c carina -f

complete -c carina -a create -r -d "Create a new file with a basic template"
complete -c carina -a check -f -d "Check for errors"
complete -c carina -a publish -f -d "Publish the content via git"
complete -c carina -a edit -f -d "Edit an existing post"
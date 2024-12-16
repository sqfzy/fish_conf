function gitpush
    git add .
    git commit -m "update" 
    git push origin (git branch --show-current)
end

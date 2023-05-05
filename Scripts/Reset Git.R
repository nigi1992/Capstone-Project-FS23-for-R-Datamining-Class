install.packages("usethis")
library(usethis)
usethis::create_github_token()

install.packages("gitcreds")
library(gitcreds)
gitcreds::gitcreds_set()

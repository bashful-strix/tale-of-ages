module ToA.Resource.Icon.Jobs
  ( jobs
  ) where

import ToA.Data.Icon.Job (Job)
import ToA.Resource.Icon.Job.Tactician (tactician)

jobs :: Array Job
jobs =
  [ tactician
  ]

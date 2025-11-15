module ToA.Resource.Icon.Jobs
  ( jobs
  ) where

import ToA.Data.Icon.Job (Job)
import ToA.Resource.Icon.Job.Tactician (tactician)
import ToA.Resource.Icon.Job.WorkshopKnight (workshopKnight)

jobs :: Array Job
jobs =
  [ tactician
  , workshopKnight
  ]

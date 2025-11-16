module ToA.Resource.Icon.Jobs
  ( jobs
  ) where

import ToA.Data.Icon.Job (Job)

import ToA.Resource.Icon.Job.Tactician (tactician)
import ToA.Resource.Icon.Job.Bastion (bastion)
import ToA.Resource.Icon.Job.Breaker (breaker)

import ToA.Resource.Icon.Job.Slayer (slayer)
import ToA.Resource.Icon.Job.WorkshopKnight (workshopKnight)
import ToA.Resource.Icon.Job.HawkKnight (hawkKnight)

import ToA.Resource.Icon.Job.Cleaver (cleaver)
import ToA.Resource.Icon.Job.Partizan (partizan)
import ToA.Resource.Icon.Job.Colossus (colossus)

import ToA.Resource.Icon.Job.Knave (knave)
import ToA.Resource.Icon.Job.BleakKnight (bleakKnight)
import ToA.Resource.Icon.Job.Corvidian (corvidian)

import ToA.Resource.Icon.Job.Spellblade (spellblade)

jobs :: Array Job
jobs =
  [ tactician
  , bastion
  , breaker

  , slayer
  , workshopKnight
  , hawkKnight

  , cleaver
  , partizan
  , colossus

  , knave
  , bleakKnight
  , corvidian

  , spellblade
  ]

module ToA.Resource.Icon
  ( icon
  ) where

import Prelude

import ToA.Data.Icon (Icon)

import ToA.Resource.Icon.Keywords (keywords)

import ToA.Resource.Icon.Class.Mendicant (mendicant)
import ToA.Resource.Icon.Class.Vagabond (vagabond)
import ToA.Resource.Icon.Class.Stalwart (stalwart)
import ToA.Resource.Icon.Class.Wright (wright)

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

import ToA.Resource.Icon.Job.Puppeteer (puppeteer)
import ToA.Resource.Icon.Job.WeepingAssassin (weepingAssassin)
import ToA.Resource.Icon.Job.Venomist (venomist)

import ToA.Resource.Icon.Job.Dragoon (dragoon)
import ToA.Resource.Icon.Job.Pathfinder (pathfinder)
import ToA.Resource.Icon.Job.Freelancer (freelancer)

import ToA.Resource.Icon.Job.Rake (rake)
import ToA.Resource.Icon.Job.Fool (fool)
import ToA.Resource.Icon.Job.Dancer (dancer)

import ToA.Resource.Icon.Job.Stormscale (stormscale)
import ToA.Resource.Icon.Job.Warden (warden)
import ToA.Resource.Icon.Job.Blightrunner (blightrunner)

import ToA.Resource.Icon.Job.Chanter (chanter)
import ToA.Resource.Icon.Job.Zephyr (zephyr)
import ToA.Resource.Icon.Job.Raconteur (raconteur)

import ToA.Resource.Icon.Job.Harvester (harvester)
import ToA.Resource.Icon.Job.FairyWright (fairyWright)
import ToA.Resource.Icon.Job.Herbalist (herbalist)

import ToA.Resource.Icon.Job.Sealer (sealer)
import ToA.Resource.Icon.Job.ShrineGuardian (shrineGuardian)
import ToA.Resource.Icon.Job.Yaman (yaman)

import ToA.Resource.Icon.Job.Seer (seer)
import ToA.Resource.Icon.Job.Chronomancer (chronomancer)
import ToA.Resource.Icon.Job.Celestian (celestian)

import ToA.Resource.Icon.Job.Enochian (enochian)
import ToA.Resource.Icon.Job.Theurgist (theurgist)
import ToA.Resource.Icon.Job.Runesmith (runesmith)

import ToA.Resource.Icon.Job.Geomancer (geomancer)
import ToA.Resource.Icon.Job.Auran (auran)
import ToA.Resource.Icon.Job.Alchemist (alchemist)

import ToA.Resource.Icon.Job.Spellblade (spellblade)
import ToA.Resource.Icon.Job.Wayfarer (wayfarer)
import ToA.Resource.Icon.Job.Entropist (entropist)

import ToA.Resource.Icon.Job.Stormbender (stormbender)
import ToA.Resource.Icon.Job.Mistwalker (mistwalker)
import ToA.Resource.Icon.Job.Snowbinder (snowbinder)

import ToA.Resource.Icon.Foe.Classes (foeClasses)
import ToA.Resource.Icon.Foe.Basic (basic)
import ToA.Resource.Icon.Foe.Relict (relict)
import ToA.Resource.Icon.Foe.Beast (beast)

icon :: Icon
icon =
  keywords
    -- stalwarts
    <> stalwart
    <> (tactician <> bastion <> breaker)
    <> (slayer <> workshopKnight <> hawkKnight)
    <> (cleaver <> partizan <> colossus)
    <> (knave <> bleakKnight <> corvidian)

    -- vaganbonds
    <> vagabond
    <> (puppeteer <> weepingAssassin <> venomist)
    <> (dragoon <> pathfinder <> freelancer)
    <> (rake <> fool <> dancer)
    <> (stormscale <> warden <> blightrunner)

    -- mendicants
    <> mendicant
    <> (chanter <> zephyr <> raconteur)
    <> (harvester <> fairyWright <> herbalist)
    <> (sealer <> shrineGuardian <> yaman)
    <> (seer <> chronomancer <> celestian)

    -- wrights
    <> wright
    <> (enochian <> theurgist <> runesmith)
    <> (geomancer <> auran <> alchemist)
    <> (spellblade <> wayfarer <> entropist)
    <> (stormbender <> mistwalker <> snowbinder)

    -- foes
    <> foeClasses
    <> (basic <> relict <> beast)

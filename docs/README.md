# Documentation – UUV Mission Planning

This document describes the PDDL domains and problem instances in this repository: how the world is modelled, what each action does, and what each problem asks the planner to achieve.

## Contents

1. [Overview](#1-overview)
2. [Base domain (`base/domain.pddl`)](#2-base-domain)
3. [Problems 1–3](#3-problems-13)
4. [Extension: ship engineer (`extension/domain1.pddl`)](#4-extension-ship-engineer)
5. [Problem 4](#5-problem-4)
6. [Running the planner](#6-running-the-planner)
7. [Known limitations](#7-known-limitations)

---

## 1. Overview

Unmanned underwater vehicles (UUVs) are deployed from ships on an inspection mission. A UUV navigates between waypoints, collects data (images and sonar scans) and physical samples, transmits the data to a ship, and brings samples back to a ship.

Modelling assumptions:

- A UUV is deployed from its ship once and is then "in action" until its mission ends.
- A UUV holds **one piece of data** at a time and must transmit it before collecting more.
- A UUV holds **one sample** at a time and must physically return it to a ship at the ship's location.
- Each ship stores **at most one sample**.
- Waypoint paths are **directed**: `(path A B)` does not imply `(path B A)`.

## 2. Base domain

**File:** `base/domain.pddl` (domain name `windfarm`)
**Requirements:** `:strips :typing`

### 2.1 Types

| Type | Meaning |
|---|---|
| `uuvs` | Underwater vehicles |
| `ships` | Support ships carrying/receiving UUVs |
| `samples` | Physical samples to be collected |
| `data` | Images and sonar scans |
| `locations` | Waypoints (WP1, WP2, …) |

### 2.2 Predicates

| Predicate | Meaning |
|---|---|
| `(uuv ?x)` / `(ship ?s)` | Declares an object as a UUV / ship |
| `(location ?m ?l)` | UUV, ship, sample or data `?m` is at waypoint `?l` |
| `(path ?l1 ?l2)` | Directed path from `?l1` to `?l2` |
| `(on_ship ?x ?s)` | UUV `?x` is aboard ship `?s` |
| `(inAction ?x)` | UUV `?x` is deployed and operating |
| `(noData ?x)` | UUV `?x` has an empty data store |
| `(collected ?x ?d)` | UUV or ship `?x` holds data `?d` |
| `(noSample ?m)` | UUV or ship `?m` holds no sample |
| `(carryingSample ?x ?y)` | UUV or ship `?x` holds sample `?y` |

### 2.3 Actions

| Action | Parameters | Preconditions | Effects |
|---|---|---|---|
| `deploy` | `?x` uuv, `?s` ship, `?l` location | UUV is on the ship | UUV leaves the ship; UUV and ship are at `?l`; UUV in action |
| `moving` | `?x` uuv, `?l1`, `?l2` | UUV at `?l1`, path `?l1→?l2`, in action | UUV moves to `?l2` |
| `collect_data` | `?x` uuv, `?l`, `?d` data | UUV and data at `?l`, data store empty, in action | UUV holds `?d`; data store no longer empty |
| `transmit_data` | `?x` uuv, `?s` ship, `?d` data | UUV holds `?d`, in action | Ship holds `?d`; UUV data store empty again |
| `collect_sample` | `?x` uuv, `?y` sample, `?l` | UUV and sample at `?l`, UUV has no sample, in action | UUV carries `?y` |
| `deliver_sample` | `?x` uuv, `?y` sample, `?ls`, `?s` ship | UUV and ship at `?ls`, ship has no sample, UUV carries `?y`, in action | Ship carries `?y`; UUV ends its mission (`inAction` false) |
| `back_to_ship` | `?x` uuv, `?s` ship, `?l` | UUV and ship at `?l`, in action | UUV ends its mission (`inAction` false) |

Data transmission has no location precondition: it models a wireless link to the ship.

## 3. Problems 1–3

All three problems use `base/domain.pddl`.

### Problem 1 – single UUV, data only

**File:** `base/problem1.pddl`

- **Objects:** `uuv1`, `ship1`, WP1–WP4, `image`, `sonarScan`
- **Initial state:** `uuv1` is on `ship1` with an empty data store. The image is at WP3 and the sonar scan at WP4.
- **Paths:** WP1→WP2, WP2→WP1, WP2→WP3, WP3→WP4, WP4→WP3, WP4→WP1
- **Goal:** `ship1` holds both the image and the sonar scan, and `uuv1` has ended its mission.

Plan produced: deploy `uuv1` at WP4 → collect sonar scan → transmit → move to WP3 → collect image → transmit → move back to WP4 → return to ship.

### Problem 2 – single UUV, data and a sample

**File:** `base/problem2.pddl`

- **Objects:** `uuv1`, `ship1`, WP1–WP5, `image`, `sonarScan`, `sample`
- **Initial state:** `uuv1` is on `ship1`. Neither UUV nor ship holds data or a sample. Image at WP5, sonar scan at WP3, sample at WP1.
- **Paths:** WP1→WP2, WP2→WP3, WP3→WP5, WP5→WP1, WP1→WP4, WP4→WP3
- **Goal:** `ship1` holds the image, the sonar scan and the sample.

Plan produced: deploy `uuv1`, collect and transmit both data items and the sample, and end by delivering the sample to the ship. Since `deliver_sample` ends the UUV's mission, the sample has to be the last task.

### Problem 3 – two UUVs, two ships

**File:** `base/problem3.pddl`

- **Objects:** `uuv1`, `uuv2`, `ship1`, `ship2`, WP1–WP6, `image1`, `image2`, `sonarScan1`, `sonarScan2`, `sample1`, `sample2`
- **Initial state:**
  - `uuv1` is already deployed and in action at WP2, with `ship1` also at WP2.
  - `uuv2` is aboard `ship2`.
  - Data: `image1`@WP2, `image2`@WP3, `sonarScan1`@WP4, `sonarScan2`@WP6
  - Samples: `sample1`@WP1, `sample2`@WP5
  - All UUVs and ships are empty.
- **Paths:** WP1↔WP2, WP2↔WP4, WP2→WP3, WP3↔WP5, WP5→WP6, WP6→WP4
- **Goal:**
  - `ship1` holds `image1`, `sonarScan1` and `sample1`
  - `ship2` holds `image2`, `sonarScan2` and `sample2`

Plan produced: both UUVs are used. Each one collects and transmits its share of the data and finishes by delivering one sample to its ship.

## 4. Extension: ship engineer

**File:** `extension/domain1.pddl` (domain name `windfarm-1`)

Each ship has an engineer who is either at the **bay** or at the **control centre**. Because there are only two positions, one predicate covers both:

| Predicate | Meaning |
|---|---|
| `(engineerIsAtBay ?s)` | The engineer on ship `?s` is at the bay. When false, they are at the control centre. |

New and changed rules:

| Action | Engineer requirement |
|---|---|
| `deploy` | Engineer at the **bay** |
| `deliver_sample` | Engineer at the **bay** |
| `collect_data` | Engineer at the **control centre** |
| `transmit_data` | Engineer at the **control centre** |
| `walk_to_bay` *(new)* | Moves the engineer from the control centre to the bay |
| `walk_to_controlSystem` *(new)* | Moves the engineer from the bay to the control centre |

The extension renames `moving` to `move_to` and does not include `back_to_ship`.

## 5. Problem 4

**File:** `extension/problem4.pddl`

This is the same scenario as Problem 3 (same objects, paths, data and sample locations, and goals). The difference is that both engineers start at the bay:

```pddl
(engineerIsAtBay ship1)
(engineerIsAtBay ship2)
```

The planner therefore has to fit `walk_to_controlSystem` / `walk_to_bay` actions around deployment, data handling and sample delivery.

## 6. Running the planner

The plans were generated with the **BFWS (FF-parser version)** planner on [planning.domains](https://planning.domains/):

1. Open the online editor and load a domain file and its matching problem file.
2. Choose **Solve** and select the BFWS–FF-parser planner.

Domain/problem pairs:

| Problem | Domain |
|---|---|
| `base/problem1.pddl` – `base/problem3.pddl` | `base/domain.pddl` |
| `extension/problem4.pddl` | `extension/domain1.pddl` |

## 7. Known limitations

- **Negative literals without the matching requirement.** Several preconditions and the Problem 1 goal use `(not ...)`, but `:negative-preconditions` isn't declared. Planners that enforce requirements strictly may reject the files.
- **`(not (on_ship uuv1 ship1))` in the `:init` of Problems 3 and 4.** This isn't valid PDDL. Under the closed-world assumption the fact is already false, so the line can be removed.
- **`deploy` adds a ship location without removing the old one.** A ship can end up at more than one waypoint.
- **`collect_data` in the extension** takes a ship `?s` that isn't linked to the UUV, so any ship's engineer at the control centre satisfies it.
- **Mission ends at the first delivery.** `deliver_sample` sets `inAction` false, so a UUV can deliver only one sample per mission.
- **Problem 4 is named `windfarm-mission-1`**, the same name as Problem 1.

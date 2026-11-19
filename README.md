# UUV Mission Planning (PDDL)

PDDL models in which unmanned underwater vehicles (UUVs), deployed from ships, navigate between waypoints to collect images, sonar scans and samples.

Developed for F29AI (Artificial Intelligence and Intelligent Agents) coursework at Heriot-Watt University Dubai.

## Structure

```
base/        domain.pddl  + problem1–3.pddl   (base UUV/ship domain)
extension/   domain1.pddl + problem4.pddl     (adds a ship engineer: bay / control centre)
docs/        README.md                        (full documentation)
```

## Quick start

Load a domain with its matching problem into planning domains and solve with BFWS (FF-parser).

| Problem | Domain |
|---|---|
| `base/problem1–3.pddl` | `base/domain.pddl` |
| `extension/problem4.pddl` | `extension/domain1.pddl` |

See [`docs/README.md`](docs/README.md) for the model, actions, problems and known limitations.

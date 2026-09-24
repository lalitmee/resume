# Role-Targeted Resume Design

## Goal

Maintain four factual, role-specific PDF resumes from this repository without installing a TeX toolchain on the host. The primary version targets senior frontend roles; the other versions target full-stack, technical-lead, and AI-developer opportunities.

## Source Structure

- Retain shared personal details, education, and prior employment facts once.
- Add four resume roots: `resume-frontend.tex`, `resume-fullstack.tex`, `resume-tech-lead.tex`, and `resume-ai-developer.tex`.
- Each root selects its own summary, Nykaa achievements, skills, and projects. This keeps the narratives independently editable without a conditional-heavy TeX template.
- Present Nykaa as one company entry with native Awesome-CV `\cvsubentry` role timelines:
  - SDE-III, Apr 2026-Present
  - Senior Software Engineer (SDE-II), Feb 2024-Apr 2026

## Content Rules

- Target one page. A second page is allowed only when it adds material value for a track.
- Nykaa receives four high-signal, track-specific bullets. Emphasize end-to-end web ownership, Akamai/edge work, marketing and analytics impact, and AI-assisted developer automation where relevant.
- Preserve the supported growth result: daily orders increased from 5-10 to 100+ after Nykaa technology adoption and marketing improvements.
- Describe AI work accurately as AI-assisted engineering automation, not AI model development.
- Compress older positions to establish progression:
  - Quartic: one or two enterprise frontend/platform bullets.
  - KoineArth: two frontend leadership and delivery bullets.
  - Cognitive Clouds: one frontend foundation bullet.
- Exclude generic collaboration, testing, and repeated UI-component statements. Include only factual technologies and outcomes.

## Local PDF Build

- Define a pinned TeX Live Docker image for the repository.
- Provide a small local build command with a track argument, such as `./build.sh frontend`.
- The build bind-mounts the repository, compiles with XeLaTeX, and writes `dist/<track>.pdf` to the host.
- Ignore generated PDFs and compiler artifacts. No host TeX installation is required.

## Validation

- Build all four tracks before completion.
- Fail the build on XeLaTeX errors.
- Review warnings for unresolved references, missing assets, layout overflow, and broken links.
- Verify each PDF's page count and visual rendering, targeting one page.

## Out Of Scope

- Inventing quantified impact, AI-model experience, or technologies not used.
- Replacing Awesome-CV or adding a general-purpose resume templating system.

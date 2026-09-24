# Role-Targeted Resumes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build four factual, role-targeted resume PDFs locally through Docker without a host TeX installation.

**Architecture:** A shared Awesome-CV preamble owns personal details and visual configuration. Four independent roots import track-specific content so each resume can prioritize its evidence without TeX conditionals. A pinned TeX Live container compiles selected roots through one shell command and bind-mounts the resulting PDF to `dist/`.

**Tech Stack:** XeLaTeX, latexmk, Awesome-CV, Docker 29+, Bash.

## Global Constraints

- Keep every claim factual and supportable; retain the Nykaa order result as 5-10 to 100+ daily orders.
- Describe Cursor, Codex, and ChatGPT work as AI-assisted engineering automation, not AI-model development.
- Target one page; permit two pages only when the selected content has clear value for that track.
- Preserve one Nykaa company header with SDE-III (Apr 2026-Present) and Senior Software Engineer/SDE-II (Feb 2024-Apr 2026) subentries.
- Do not add a host TeX dependency or a conditional-heavy resume template.

---

## File Structure

- Create: `Dockerfile` - pinned TeX compiler image.
- Create: `build.sh` - validates a resume track and runs its Dockerized build.
- Create: `.gitignore` - excludes only generated `dist/` compiler output.
- Create: `resume/preamble.tex` - shared document class, header details, fonts, and styling.
- Create: `resume-frontend.tex`, `resume-fullstack.tex`, `resume-tech-lead.tex`, `resume-ai-developer.tex` - four independently compilable roots.
- Create: `resume/frontend.tex`, `resume/fullstack.tex`, `resume/tech-lead.tex`, `resume/ai-developer.tex` - track-specific summary, experience, skills, and optional projects content.
- Retain: `awesome-cv.cls`, `fonts/`, `resume/education.tex` - existing reusable template assets and education data.
- Modify: `README.md` - document prerequisites and exact build commands.

### Task 1: Dockerized Resume Build

**Files:**
- Create: `Dockerfile`
- Create: `build.sh`
- Create: `.gitignore`
- Modify: `README.md`

**Interfaces:**
- Consumes: one argument: `frontend`, `fullstack`, `tech-lead`, `ai-developer`, or `all`.
- Produces: `dist/<track>.pdf`; exits non-zero for invalid tracks or XeLaTeX failures.

- [ ] **Step 1: Verify the current command fails before the build wrapper exists**

Run: `./build.sh frontend`

Expected: shell reports that `build.sh` does not exist.

- [ ] **Step 2: Add the pinned compiler image**

Create `Dockerfile`:

```dockerfile
FROM texlive/texlive@sha256:7334b00bf8e7a0996f7ddd65482363aaf7711d372e569f3ea78509619e3083ff

WORKDIR /workspace
ENTRYPOINT ["latexmk"]
```

- [ ] **Step 3: Add the minimal validated build wrapper**

Create `build.sh` and make it executable:

```bash
#!/usr/bin/env bash
set -euo pipefail

track="${1:-}"
case "$track" in
  frontend|fullstack|tech-lead|ai-developer)
    tracks=("$track")
    ;;
  all)
    tracks=(frontend fullstack tech-lead ai-developer)
    ;;
  *)
    printf 'Usage: %s {frontend|fullstack|tech-lead|ai-developer|all}\n' "$0" >&2
    exit 2
    ;;
esac

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
docker build --tag lalit-resume-tex:local "$root"
mkdir -p "$root/dist"

for name in "${tracks[@]}"; do
  docker run --rm --user "$(id -u):$(id -g)" \
    --mount "type=bind,source=$root,target=/workspace" \
    --workdir /workspace \
    lalit-resume-tex:local \
    -xelatex -interaction=nonstopmode -halt-on-error -outdir=dist "resume-$name.tex"
done
```

Run: `chmod +x build.sh`

- [ ] **Step 4: Exclude generated output and document the exact workflow**

Create `.gitignore`:

```gitignore
/dist/
```

Append this concise section to `README.md`:

    ## Build a resume

    Docker is the only build dependency. Build a role-specific PDF with:

    ```bash
    ./build.sh frontend
    ./build.sh fullstack
    ./build.sh tech-lead
    ./build.sh ai-developer
    ```

    Use `./build.sh all` to build every version. PDFs are written to `dist/`. The first build downloads the pinned TeX Live image.

- [ ] **Step 5: Verify argument validation and the Docker build**

Run: `./build.sh invalid`

Expected: exit status `2` and the usage line.

Run: `./build.sh frontend`

Expected: Docker builds `lalit-resume-tex:local`; compilation reaches the resume-source error because the new root is not present yet.

- [ ] **Step 6: Commit the build foundation**

```bash
git add Dockerfile build.sh .gitignore README.md
git commit -m "build: add Docker resume compiler"
```

### Task 2: Shared Resume Preamble and Frontend Track

**Files:**
- Create: `resume/preamble.tex`
- Create: `resume-frontend.tex`
- Create: `resume/frontend.tex`

**Interfaces:**
- Consumes: `awesome-cv.cls`, `fonts/`, and `resume/education.tex`.
- Produces: a standalone `resume-frontend.tex` that emits `dist/resume-frontend.pdf` through `build.sh frontend`.

- [ ] **Step 1: Create the shared preamble from the current `resume.tex` configuration**

Create `resume/preamble.tex` with the current document class, geometry, font directory, color, name, contact links, and centered header. Keep `\position` neutral:

```tex
\documentclass[11pt, a4paper]{awesome-cv}
\geometry{left=1.4cm, top=.8cm, right=1.4cm, bottom=1.8cm, footskip=.5cm}
\fontdir[fonts/]
\colorlet{awesome}{awesome-red}
\setbool{acvSectionColorHighlight}{true}
\renewcommand{\acvHeaderSocialSep}{\quad\textbar\quad}
\name{Lalit}{Kumar}
\position{Software Engineer {\enskip\cdotp\enskip} Frontend}
\mobile{(+91) 97-1261-8438}
\email{lalitkumar.meena.lk@gmail.com}
\github{lalitmee}
\linkedin{lalitmee}
```

- [ ] **Step 2: Create the frontend root and its tailored content**

Create `resume-frontend.tex`:

```tex
\input{resume/preamble.tex}
\begin{document}
\makecvheader[C]
\input{resume/frontend.tex}
\input{resume/education.tex}
\end{document}
```

Create `resume/frontend.tex` with a Frontend-focused summary, one Nykaa `\cventry` followed by two `\cvsubentry` blocks, and compact older roles. Use these factual Nykaa bullets:

```tex
\item {Own the Nysaa web application end-to-end, architecting and shipping React/Next.js features across SSR, caching, micro-frontends, production debugging, and upstream Nykaa code synchronization.}
\item {Replaced a Varnish-based mweb/dweb redirection layer with Akamai property rules and EdgeWorkers, simplifying edge routing and caching for public domains.}
\item {Built product-variant, cart-merging, and cart-stability improvements for a more reliable shopping experience.}
\item {Partnered on GTM, GA4, and marketing integrations that contributed to daily orders growing from 5-10 to 100+.}
```

Use no more than two Quartic bullets, two KoineArth bullets, and one Cognitive Clouds bullet. Keep only React, Next.js, GraphQL, frontend architecture, and leadership evidence relevant to this track.

- [ ] **Step 3: Run the first complete compilation check**

Run: `./build.sh frontend`

Expected: exit status `0` and `dist/resume-frontend.pdf` exists.

- [ ] **Step 4: Inspect the PDF and tighten content**

Open `dist/resume-frontend.pdf`. Confirm the nested Nykaa role dates render below one Nykaa header, links resolve, no lines overlap, and the document is one page. Remove lower-signal older-role copy before reducing font size or margins.

- [ ] **Step 5: Commit the frontend version**

```bash
git add resume/preamble.tex resume-frontend.tex resume/frontend.tex
git commit -m "feat: add frontend resume track"
```

### Task 3: Full-Stack, Technical-Lead, and AI-Developer Tracks

**Files:**
- Create: `resume-fullstack.tex`, `resume-tech-lead.tex`, `resume-ai-developer.tex`
- Create: `resume/fullstack.tex`, `resume/tech-lead.tex`, `resume/ai-developer.tex`

**Interfaces:**
- Consumes: `resume/preamble.tex`, `resume/education.tex`, and the Docker build contract from Task 1.
- Produces: `dist/resume-fullstack.pdf`, `dist/resume-tech-lead.pdf`, and `dist/resume-ai-developer.pdf`.

- [ ] **Step 1: Create the three roots with the shared document contract**

Create `resume-fullstack.tex`:

```tex
\input{resume/preamble.tex}
\begin{document}
\makecvheader[C]
\input{resume/fullstack.tex}
\input{resume/education.tex}
\end{document}
```

Create `resume-tech-lead.tex`:

```tex
\input{resume/preamble.tex}
\begin{document}
\makecvheader[C]
\input{resume/tech-lead.tex}
\input{resume/education.tex}
\end{document}
```

Create `resume-ai-developer.tex`:

```tex
\input{resume/preamble.tex}
\begin{document}
\makecvheader[C]
\input{resume/ai-developer.tex}
\input{resume/education.tex}
\end{document}
```

- [ ] **Step 2: Author the full-stack track**

Create `resume/fullstack.tex`. Prioritize these claims over frontend-only UI details:

```tex
\item {Owned the Nysaa web platform end-to-end across Next.js/React micro-frontends, Kong API Gateway integration, AWS services, CI/CD, production diagnosis, and upstream synchronization.}
\item {Configured Akamai properties, caching, public domains, and EdgeWorkers; removed the Varnish redirect layer through edge rules for mweb and dweb traffic.}
\item {Connected GTM, GA4, marketing platforms, BigQuery, and Looker Studio attribution to improve order-source visibility and support growth from 5-10 to 100+ daily orders.}
\item {Partnered with backend engineers on debugging and system design, using AWS, ECS, EC2, S3, CloudFront, OpenSearch, Docker, Jenkins, and Kong.}
```

- [ ] **Step 3: Author the technical-lead track**

Create `resume/tech-lead.tex`. Prioritize ownership, decision-making, and support for others:

```tex
\item {Act as the senior technical owner for Nysaa web delivery, taking features from architecture through release, production support, and ongoing synchronization with Nykaa upstream systems.}
\item {Led edge-platform decisions across Akamai properties, caching, domains, and EdgeWorkers, replacing a Varnish redirect layer with maintainable edge rules.}
\item {Unblocked backend teammates by debugging cross-system issues and connecting web, API, infrastructure, analytics, and marketing dependencies.}
\item {Drove Martech and attribution integrations across GTM, GA4, BigQuery, Looker Studio, and advertising platforms, contributing to daily orders increasing from 5-10 to 100+.}
```

- [ ] **Step 4: Author the AI-developer track without overstating experience**

Create `resume/ai-developer.tex`. Lead with developer-tooling and AI-assisted delivery, not model training:

```tex
\item {Built AI-assisted developer-workflow automation with Cursor, Codex, and ChatGPT to accelerate investigation, micro-frontend setup, package linking, and repetitive development tasks.}
\item {Created local tooling that detects the active micro-frontend, starts the relevant server, and links or unlinks selected common npm packages for monorepo development.}
\item {Automated Git worktree and tmux setup for isolated feature development and debugging, reducing manual environment preparation.}
\item {Applied the same delivery discipline to end-to-end Nysaa ownership across React/Next.js, Akamai edge configuration, AWS-integrated services, production debugging, and CI/CD.}
```

- [ ] **Step 5: Compile all variants and inspect page count and hierarchy**

Run: `./build.sh all`

Expected: exit status `0`; all four PDFs exist in `dist/`.

Open each PDF. Confirm the role-specific summary, skills, and Nykaa bullet ordering differs by track; each has one Nykaa company header with the two role timelines; each is one page unless genuinely stronger at two.

- [ ] **Step 6: Commit the additional tracks**

```bash
git add resume-fullstack.tex resume-tech-lead.tex resume-ai-developer.tex resume/fullstack.tex resume/tech-lead.tex resume/ai-developer.tex
git commit -m "feat: add targeted resume tracks"
```

### Task 4: Remove the Legacy Resume Path and Perform Final Verification

**Files:**
- Modify: `resume.tex`
- Modify: `README.md`

**Interfaces:**
- Consumes: all four dedicated roots.
- Produces: documentation that directs users to the Docker build and eliminates ambiguity about the legacy root.

- [ ] **Step 1: Replace the legacy root with a clear frontend alias**

Replace `resume.tex` with:

```tex
% The primary frontend resume. Build role-specific PDFs with ./build.sh.
\input{resume-frontend.tex}
```

- [ ] **Step 2: Update the README project description**

Replace the introductory text with:

```markdown
# Role-Targeted Resume

LaTeX resumes for frontend, full-stack, technical-lead, and AI-developer opportunities. See [Build a resume](#build-a-resume) for the Docker-only PDF workflow.
```

- [ ] **Step 3: Run final clean builds**

Run: `rm -rf dist && ./build.sh all`

Expected: exit status `0`, four PDF files in `dist/`, and no TeX error output.

- [ ] **Step 4: Perform final visual review**

Open every generated PDF and verify: header contact links, Nykaa promotion hierarchy, factual dates, no layout overflow, appropriate role-specific skills, and the one-page target.

- [ ] **Step 5: Commit the migration and final checks**

```bash
git add resume.tex README.md
git commit -m "docs: document targeted resume workflow"
```

## Self-Review

- Spec coverage: Tasks 1-4 implement the pinned Docker toolchain, four role-targeted sources, factual Nykaa promotion layout, concise older history, generated-output hygiene, and all-variant PDF verification.
- Placeholder scan: no deferred implementation markers or unspecified error behavior remain.
- Interface consistency: all roots use the `resume-<track>.tex` names accepted by `build.sh`; all builds write through `latexmk` to `dist/`.

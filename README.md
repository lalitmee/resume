# Lalit Kumar - Resume

The primary two-page resume presents Lalit as a Senior Software Engineer, with detailed Nykaa experience, concise earlier roles, selected projects, and technical skills.

`resume.tex` is the entry point. Its content is in `resume/current.tex`, and its layout is in `resume/current-preamble.tex`.

## Build the PDF

Docker is the only build dependency. Run:

```bash
./build.sh
```

The output is `dist/resume.pdf`. The first build downloads the pinned TeX Live image. Generated files in `dist/` are ignored by Git.

Role-targeted resumes are being developed separately and are not part of this build yet.

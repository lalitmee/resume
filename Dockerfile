FROM texlive/texlive@sha256:7334b00bf8e7a0996f7ddd65482363aaf7711d372e569f3ea78509619e3083ff

WORKDIR /workspace
ENTRYPOINT ["latexmk"]

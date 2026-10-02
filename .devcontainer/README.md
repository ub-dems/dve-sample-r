# DevContainer Podman Setup



## VS Code Config

- [Attach to a running container](https://code.visualstudio.com/docs/devcontainers/attach-container)
- [Visual Studio Code (VS Code) to attach to a running rootless Podman container](https://chatgpt.com/share/676557a0-04b0-8012-999b-2e2c3f28f5df)
- [VS Code Container Dev Setup](https://gemini.google.com/share/ac8056d69f7d)


## R plugin


```bash
/usr/bin/R --silent --no-echo --no-save --no-restore \
-e install.packages('languageserver', repos='https://p3m.dev/cran/__linux__/noble/latest') 
```
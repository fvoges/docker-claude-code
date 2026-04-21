# docker-claude-code

Containerized [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) plus Docker CLI and common troubleshooting tools. Rebuilt automatically when either `node:22-slim` or `@anthropic-ai/claude-code` ships an update.

- **Base**: `node:22-slim` (Debian 12 slim)
- **Architectures**: `linux/amd64`, `linux/arm64`
- **Registry**: `ghcr.io/fvoges/docker-claude-code`
- **Signed**: cosign keyless via GitHub OIDC
- **Attestations**: SBOM + SLSA provenance

## Pull

```bash
docker pull ghcr.io/fvoges/docker-claude-code:latest
```

## Run

Interactive shell with the host Docker socket mounted so Claude Code can manage containers:

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/fvoges/docker-claude-code:latest
```

## Tags

| Tag | Mutability | Use |
| --- | --- | --- |
| `latest` | mutable | Always the most recent build. |
| `<claude-version>` (e.g. `1.2.3`) | mutable | Pins the Claude Code version but floats when the base image gets security patches. |
| `22-slim-<claude-version>` | mutable | Same as above, scoped to the `22-slim` base variant. |
| `22-slim-<claude-version>-<base-short-digest>` | **immutable** | Frozen (claude, base) combo. Pin here for bit-for-bit reproducibility. |

## Build cadence

A scheduled workflow runs daily at 04:00 UTC:

1. Resolves the latest `@anthropic-ai/claude-code` version from npm.
2. Resolves the current `node:22-slim` manifest-list digest from Docker Hub.
3. Reads the `org.opencontainers.image.base.digest` and `io.anthropic.claude-code.version` labels from the previously-published `:latest` image.
4. Rebuilds and pushes only if at least one has changed.

To force a rebuild (e.g. to pick up an intermediate Docker-CE-CLI update), trigger the `Build and publish` workflow manually with `force: true`.

## Verify signatures

```bash
cosign verify ghcr.io/fvoges/docker-claude-code:latest \
  --certificate-identity-regexp='^https://github.com/fvoges/docker-claude-code/' \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com
```

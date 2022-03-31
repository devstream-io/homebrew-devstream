# Devstream-io Devstream

## How do I install `dtm`?

```bash
brew install devstream-io/devstream/dtm
```

## Version Bump

- update the URL and sha256 in the formula (manually or using `brew bump-formula-pr`)
- create a PR, wait till the PR's testing jobs are all green, then tag the PR with a label "pr-pull"
- since GitHub Actions runners only runs on macOS Big Sur not Monterey, we need to bottle for ARM64 Monterey manually by using `brew install devstream-io/devstream/dtm --build-bottle` and `brew bottle dtm`. Update the sha256 of the new bottle, upload the bottle manually.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

Some useful help:
- https://brew.sh/2020/11/18/homebrew-tap-with-bottles-uploaded-to-github-releases/
- https://docs.brew.sh/Bottles

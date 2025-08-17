# Unofficial builds of Zed for Linux (GLES)

[![Test Scripts](https://github.com/deevus/zed-windows-builds/actions/workflows/test.yml/badge.svg)](https://github.com/deevus/zed-windows-builds/actions/workflows/test.yml)
[![Test Integration](https://github.com/deevus/zed-windows-builds/actions/workflows/test-integration.yml/badge.svg)](https://github.com/deevus/zed-windows-builds/actions/workflows/test-integration.yml)
[![Scheduled Nightly Build](https://github.com/deevus/zed-windows-builds/actions/workflows/nightly.yml/badge.svg)](https://github.com/deevus/zed-windows-builds/actions/workflows/nightly.yml)
[![Scheduled Stable Build](https://github.com/deevus/zed-windows-builds/actions/workflows/stable.yml/badge.svg)](https://github.com/deevus/zed-windows-builds/actions/workflows/stable.yml)

**NOTE: This is not a support channel for Zed on Linux.**

These builds are for those who want to live on the bleeding edge or just want to test Zed out on Linux with GLES rendering.

Any issues with the Linux build should go through official channels, as this repository does not concern itself with the source code of Zed or issues found therein.

If you have suggestions for improvements to the build process, please start a discussion or make a PR.

## Is it safe?

This repository is just a [simple GitHub workflow](./.github/workflows/build.yml) that builds Zed from `main` and publishes a release every night at UTC+0000. (Additionally on push for testing).

See the [Zed homepage](https://zed.dev/) or [official repository](https://github.com/zed-industries/zed) for more details.

## Build Process

The build process is designed to be robust and handle partial failures gracefully:

- **Comprehensive Testing**: All build scripts are thoroughly tested with automated test suites
- **Quality Assurance**: Each release includes SHA256 checksums for integrity verification

### Testing

The build and release scripts are automatically tested with every change:

- **Script Tests**: Unit tests for the release preparation logic
- **Integration Tests**: End-to-end testing of the build and release workflows

See the [scripts directory](./scripts/) for more details about the testing infrastructure.
